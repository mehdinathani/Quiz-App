import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'fast_attendance_viewmodel.dart';

class FastAttendanceView extends StackedView<FastAttendanceViewModel> {
  const FastAttendanceView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FastAttendanceViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          verticalSpaceLarge,
          DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
              title: Text("Select Roll Number"),
            ),
            selectedItem: viewModel.selectedRollNumber,
            onChanged: viewModel.setSelectedRollNumber,
            items: viewModel.rollNumbers,
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: viewModel.scanQRCode,
                    child: Text('Scan QR Code'),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Scan result: ${viewModel.scanResult}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          if (viewModel.selectedStudent != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    'Name: ${viewModel.selectedStudent!['Name'] ?? 'Loading...'}'),
                verticalSpace(18),
                Text(
                    'Father\'s Name: ${viewModel.selectedStudent!['Father\'s Name'] ?? 'Loading...'}'),
                verticalSpaceMedium,
                Text("Class: ${viewModel.selectedStudent!["GROUP"]}"),
                verticalSpaceMedium,
                Text("Oral Test: ${viewModel.selectedStudent!["Oral_Exam"]}"),
                verticalSpaceMedium,
                Text("Final Exam: ${viewModel.selectedStudent!["Final_Exam"]}"),
                verticalSpaceMedium,
                ElevatedButton(
                  onPressed: () {
                    viewModel.recordAttendance();
                  },
                  child: const Text("Mark"),
                )
              ],
            ),
        ],
      ),
    );
  }

  @override
  FastAttendanceViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FastAttendanceViewModel();
  @override
  void onViewModelReady(FastAttendanceViewModel viewModel) {
    viewModel.fetchStudentData();
    super.onViewModelReady(viewModel);
  }
}
