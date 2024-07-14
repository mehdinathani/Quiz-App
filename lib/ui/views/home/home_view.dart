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
      appBar: AppBar(
        title: const Text("Swift Manager Pro"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                viewModel.signOut();
              },
            )
          ],
        ),
      ),
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
                  child: const Text("Swift Quiz")),
              ElevatedButton(
                  onPressed: () {
                    viewModel.setModule(CurrentModuleType.exam);
                    viewModel.goToStudentSelection();
                    // viewModel.navigateToExamView();
                  },
                  child: const Text("Swift Exam")),
              ElevatedButton(
                  onPressed: () {
                    viewModel.setModule(CurrentModuleType.oral);
                    viewModel.goToStudentSelection();
                    // viewModel.navigateToExamView();
                  },
                  child: const Text("Swift Oral")),
              ElevatedButton(
                  onPressed: () {
                    viewModel.navigateToFastAttendance();
                  },
                  child: const Text("Swift Attendance")),
              ElevatedButton(
                  onPressed: () {
                    viewModel.navigateToQRAttendance();
                  },
                  child: const Text("Attendance with QR"))
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
