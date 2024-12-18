import 'package:flutter/material.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import the package

import 'students_selection_viewmodel.dart';

class StudentsSelectionView extends StatelessWidget {
  const StudentsSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StudentsSelectionViewModel>.reactive(
      viewModelBuilder: () => StudentsSelectionViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchStudentData(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Student Selection"),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Select Roll Number from the below List."),
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
                        // DropdownButtonFormField<String>(
                        //   hint: const Text('Select Roll Number'),
                        //   value: viewModel.selectedRollNumber,
                        //   onChanged: viewModel.setSelectedRollNumber,
                        //   items: viewModel.rollNumbers
                        //       .map((rollNumber) => DropdownMenuItem(
                        //             value: rollNumber,
                        //             child: Text(rollNumber),
                        //           ))
                        //       .toList(),
                        // ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        const Text("Scan the Bar Code."),
                        verticalSpaceSmall,
                        ElevatedButton(
                          onPressed: () async {
                            await viewModel.scanQRCode();
                          },
                          child: const Icon(Icons.qr_code),
                        ),
                        verticalSpaceLarge,
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
                              Text(
                                  "Class: ${viewModel.selectedStudent!["GROUP"]}"),
                              verticalSpaceMedium,
                              Text(
                                  "Oral Test: ${viewModel.selectedStudent!["Oral_Exam"]}"),
                              verticalSpaceMedium,
                              Text(
                                  "Final Exam: ${viewModel.selectedStudent!["Final_Exam"]}"),
                              verticalSpaceMedium,
                              ElevatedButton(
                                onPressed: () {
                                  viewModel.goToModule();
                                },
                                child: const Text("Start"),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
