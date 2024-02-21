import 'package:flutter/material.dart';
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
            children: [
              ElevatedButton(
                  onPressed: () {
                    viewModel.navigateToStudentSelection();
                  },
                  child: const Text("Quiz"))
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
