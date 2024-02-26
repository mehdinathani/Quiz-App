import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/model/students_data.dart';
import 'package:quizapp/services/module_selection_service.dart';
import 'package:quizapp/services/students_data_service_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StudentsSelectionViewModel extends BaseViewModel {
  final _studentsDataService = locator<StudentsDataServiceService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ModuleSelectionService _moduleSelectionService =
      locator<ModuleSelectionService>();

  late StudentsData studentsData;

  List<String> rollNumbers = []; // Populate this list with roll numbers
  String? selectedRollNumber;
  Map<String, String>? selectedStudent;

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
      notifyListeners(); // Trigger UI update
    }
  }

  navigateToHome() {
    _navigationService.navigateToHomeView();
  }

  goToQuizPage() {
    _navigationService.navigateToQuizView();
  }

  Future<void> scanQRCode() async {
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scan button
        'Cancel', // Text for the cancel button
        true, // Whether to show the flash option
        ScanMode.QR, // Scan mode (QR code in this case)
      );
      if (barcodeScanRes != '-1') {
        debugPrint(barcodeScanRes.toString());
        // Update the selected roll number with the scanned QR code value
        setSelectedRollNumber(barcodeScanRes);
      }
    } on Exception catch (e) {
      debugPrint('Error scanning QR code: $e');
    }
  }

  goToExamView() {
    _navigationService.navigateToExamView();
  }

  void goToModule() {
    CurrentModuleType selectedModule =
        _moduleSelectionService.getSelectedModule();
    switch (selectedModule) {
      case CurrentModuleType.quiz:
        _navigationService.navigateToQuizView();
        break;
      case CurrentModuleType.exam:
        _navigationService.navigateToExamView();
        break;
      case CurrentModuleType.attendance:
        _navigationService.navigateToFastAttendanceView();
        break;
      default:
        _navigationService.navigateToHomeView();
    }
  }
}
