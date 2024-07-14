import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
import 'package:quizapp/ui/views/attendance_with_q_r/attendance_with_q_r_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AttendanceWithQRView extends StatelessWidget {
  const AttendanceWithQRView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    // Using the reactive constructor gives you the traditional ViewModel
    // binding which will execute the builder again when notifyListeners is called.
    return ViewModelBuilder<AttendanceWithQRViewModel>.reactive(
      viewModelBuilder: () => AttendanceWithQRViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchStudentData(),
      builder: (context, viewModel, child) => Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: viewModel.onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 7,
              child: Center(
                child: (viewModel.result != null)
                    ? viewModel.selectedStudent != null
                        // ? Text(viewModel.qrMsg)
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: viewModel.updateBgColor(),
                                border: Border.all(
                                  color: Colors.black,
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Updating Attendance for below"),
                                verticalSpaceSmall,
                                Text(viewModel.selectedRollNumber!),
                                verticalSpaceSmall,
                                Text(
                                    'Name: ${viewModel.selectedStudent!['Name'] ?? 'Loading...'}'),
                                verticalSpaceSmall,
                                Text(
                                    'Father\'s Name: ${viewModel.selectedStudent!['Father\'s Name'] ?? 'Loading...'}'),
                                verticalSpaceSmall,
                                Text(
                                    "Class: ${viewModel.selectedStudent!["GROUP"]}"),
                                verticalSpaceSmall,
                                Text(
                                    "Oral Test: ${viewModel.selectedStudent!["Oral_Exam"]}"),
                                verticalSpaceSmall,
                                Text(
                                    "Final Exam: ${viewModel.selectedStudent!["Final_Exam"]}"),
                                verticalSpaceSmall,
                              ],
                            ),
                          )
                        : const Text("Loading....")
                    // ? Text(
                    //     'Barcode Type: ${describeEnum(viewModel.result!.format)}   Data: ${viewModel.result!.code}')
                    : Text('Scan a code'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
