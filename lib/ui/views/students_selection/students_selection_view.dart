import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
            actions: [
              IconButton(
                  onPressed: () {
                    viewModel.navigateToHome();
                  },
                  icon: const Icon(Icons.swipe_left_sharp))
            ],
            centerTitle: true,
            title: const Text("Student Selection"),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.scanQRCode();
                  },
                  child: const Text('Scan QR Code'),
                ),
                viewModel.isBusy
                    ? const CircularProgressIndicator()
                    : DropdownButton<String>(
                        hint: const Text('Select Roll Number'),
                        value: viewModel.selectedRollNumber,
                        onChanged: viewModel.setSelectedRollNumber,
                        items: viewModel.rollNumbers
                            .map((rollNumber) => DropdownMenuItem(
                                  value: rollNumber,
                                  child: Text(rollNumber),
                                ))
                            .toList(),
                      ),
                const SizedBox(height: 20),
                if (viewModel.selectedStudent != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Name: ${viewModel.selectedStudent!['Name'] ?? 'Loading...'}'),
                      Text(
                          'Father\'s Name: ${viewModel.selectedStudent!['Father\'s Name'] ?? 'Loading...'}'),
                      ElevatedButton(
                        onPressed: () {
                          viewModel.goToQuizPage();
                        },
                        child: const Text("Start"),
                      )
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
