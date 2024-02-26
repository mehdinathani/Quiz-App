import 'package:flutter/material.dart';
import 'package:quizapp/services/module_selection_service.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    viewModel.setModule(CurrentModuleType.quiz);
                    viewModel.navigateToStudentSelection();
                  },
                  child: const Text("Quiz")),
              ElevatedButton(
                  onPressed: () {
                    viewModel.setModule(CurrentModuleType.exam);
                    viewModel.goToStudentSelection();
                    // viewModel.navigateToExamView();
                  },
                  child: const Text("Exam View")),
              ElevatedButton(
                  onPressed: () {
                    viewModel.navigateToFastAttendance();
                  },
                  child: const Text("Fast Attendance"))
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
