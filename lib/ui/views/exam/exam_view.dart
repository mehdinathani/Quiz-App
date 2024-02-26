import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'exam_viewmodel.dart';

class ExamView extends StackedView<ExamViewModel> {
  const ExamView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ExamViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam View'),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.quizData.quizzes.isEmpty
              ? const Center(child: Text('No questions available.'))
              : Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${viewModel.currentStudentData!['Name']!}",
                              style: studentHeader,
                            ),
                            horizontalSpaceLarge,
                            Text(
                              "Father Name: ${viewModel.currentStudentData!["Father's Name"]!}",
                              style: studentHeader,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Class: ${viewModel.currentStudentData!["GROUP"]!}",
                              style: studentHeader,
                            ),
                            horizontalSpaceLarge,
                            Text(
                              "Marks: ${viewModel.studentScore.toString()}",
                              style: studentHeader,
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.quizData.quizzes.length,
                        itemBuilder: (context, index) {
                          final question = viewModel.quizData.quizzes[index];
                          return ListTile(
                            title: Text('Question ${index + 1}'),
                            subtitle: Text(question['Question']),
                            trailing: Text(
                                "${question['EarnedPoints']} / ${question['TotalPoint']}"),
                            onTap: () {
                              viewModel.showQuestionDialog(context, question);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  ExamViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ExamViewModel();
  @override
  void onViewModelReady(ExamViewModel viewModel) {
    viewModel.fetchQuizData();
    super.onViewModelReady(viewModel);
  }
}
