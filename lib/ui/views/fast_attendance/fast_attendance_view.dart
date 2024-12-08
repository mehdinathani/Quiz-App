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
      appBar: AppBar(
        title: const Text("Swift Attendance"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  verticalSpaceLarge,
                  DropdownSearch<String>(
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration()),
                    popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      showSelectedItems: true,
                      title: Text("Select Roll Number"),
                    ),
                    selectedItem: viewModel.selectedRollNumber,
                    onChanged: viewModel.setSelectedRollNumber,
                    items: viewModel.rollNumbers,
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: viewModel.scanQRCode,
                            child: const Text('Scan QR Code'),
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
                  verticalSpaceMedium,
                  if (viewModel.selectedStudent != null)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: viewModel.updateBgColor(),
                          border: Border.all(
                            color: Colors.black,
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          verticalSpaceSmall,
                          Text(
                              'Name: ${viewModel.selectedStudent!['Name'] ?? 'Loading...'}'),
                          verticalSpaceSmall,
                          Text(
                              'Father\'s Name: ${viewModel.selectedStudent!['Father\'s Name'] ?? 'Loading...'}'),
                          verticalSpaceSmall,
                          Text("Class: ${viewModel.selectedStudent!["GROUP"]}"),
                          verticalSpaceSmall,
                          Text(
                              "Oral Test: ${viewModel.selectedStudent!["Oral_Exam"]}"),
                          verticalSpaceSmall,
                          Text(
                              "Final Exam: ${viewModel.selectedStudent!["Final_Exam"]}"),
                          verticalSpaceSmall,
                          ElevatedButton(
                            onPressed: () {
                              viewModel.recordAttendance();
                              viewModel.selectedStudent = null;
                            },
                            child: const Text("Mark"),
                          ),
                          verticalSpaceSmall,
                        ],
                      ),
                    ),
                ],
              ),
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
