import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/model/students_data.dart';
import 'package:quizapp/services/students_data_service_service.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AttendanceWithQRViewModel extends BaseViewModel {
  Barcode? result;
  QRViewController? controller;
  String qrMsg = 'Scan a QR code to get attendance status';
  bool _isRecordingAttendance =
      false; // Flag to indicate if attendance is being recorded

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      qrMsg = 'Scanning...';

      if (rollNumbers.contains(result!.code) && !_isRecordingAttendance) {
        _isRecordingAttendance =
            true; // Set the flag to indicate recording is in progress
        log("Geting Current Student Data");
        await getCurrentStudentData();
        log("Set Selected Roll Number");
        await setSelectedRollNumber(result!.code);
        qrMsg = 'Student details loaded for ${result!.code}';
        log("Calling Record attendance Function");
        await recordAttendance();
        log("record attendance function called");
        qrMsg = 'Attendance recorded for ${result!.code}';
        _isRecordingAttendance = false; // Reset the flag
      }
      rebuildUi();
    });
  }

  final _studentsDataService = locator<StudentsDataServiceService>();
  final NavigationService _navigationService = locator<NavigationService>();
  Map<String, String>? selectedStudent;
  late StudentsData studentsData;
  String? selectedRollNumber;
  List<String> rollNumbers = []; // Populate this list with roll numbers

  // String get scanResult => _scanResult;

  // Future<void> scanQRCode() async {
  //   setBusy(true);
  //   try {
  //     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666',
  //       'Cancel',
  //       true,
  //       ScanMode.QR,
  //     );
  //     if (barcodeScanRes != '-1') {
  //       _scanResult = barcodeScanRes;
  //       setSelectedRollNumber(_scanResult);
  //       notifyListeners(); // Notify the UI of the new scan result
  //     }
  //   } finally {
  //     setBusy(false);
  //   }
  // }

  // Future<void> startBarcodeScanStream() async {
  //   FlutterBarcodeScanner.getBarcodeStreamReceiver(
  //           '#ff6666', 'Cancel', true, ScanMode.QR)!
  //       .listen((barcode) => print(barcode));
  // }

  Future<void> fetchStudentData() async {
    setBusy(true);
    final data = await _studentsDataService.fetchAllStudentsData();
    if (data != null) {
      studentsData = StudentsData(data);
      rollNumbers =
          studentsData.students.map((student) => student['Roll No']!).toList();
    }
    setBusy(false);
    notifyListeners(); // Trigger UI update
  }

  Future<void> setSelectedRollNumber(String? rollNumber) async {
    selectedRollNumber = rollNumber;

    selectedStudent = null;
    if (rollNumber != null && studentsData.students.isNotEmpty) {
      selectedStudent = studentsData.students.firstWhere(
        (student) => student['Roll No'] == rollNumber,
      );
      _studentsDataService.currentStudentRollNumber = rollNumber;
      _studentsDataService.updateCurrentStudentData(selectedStudent);
      var csg = selectedStudent!["GROUP"]!.toLowerCase();
      currentStudentGroup = csg.toLowerCase();
      notifyListeners(); // Trigger UI update
    }
  }

  recordAttendance() async {
    log("inside Record Attendance");
    if (selectedRollNumber != null) {
      // Construct reference ID
      String referenceId =
          'R-${selectedRollNumber!}-${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}${DateTime.now().year}';

      // Additional data for attendance record
      String date =
          '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
      String time =
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';
      String attendanceType = 'Present (In)'; // Assuming default is present
      String username = 'username'; // Assuming username is stored somewhere

      try {
        // Write attendance record to the spreadsheet
        await _studentsDataService.recordAttendance(
          referenceId: referenceId,
          rollNumber: selectedRollNumber!,
          date: date,
          time: time,
          attendanceType: attendanceType,
          username: username,
        );

        // Attendance recorded successfully
        // Perform any additional actions
      } catch (e) {
        // Failed to record attendance
        // Handle error or show message
        print('Failed to record attendance: $e');
      }
    } else {
      // No roll number selected, handle accordingly
    }
  }

  Color updateBgColor() {
    Color bgColor;
    var group = currentStudentGroup;
    switch (group.toLowerCase()) {
      case "junior":
        bgColor = juniorColor;
        break;
      case "middle":
        bgColor = middleColor;
        break;

      default:
        bgColor = Colors.white;
        break;
    }
    return bgColor;
  }

  navigateToHome() {
    _navigationService.navigateToHomeView();
  }

  showSnacBar(BuildContext context, content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
  }

  getCurrentStudentData() {
    rebuildUi();
    setBusy(true);
  }
}
