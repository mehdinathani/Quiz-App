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
      backgroundColor: viewModel.updateBgColor(),
      appBar: AppBar(
        title: const Text('Exam View'),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.quizData.quizzes.isEmpty
              ? const Center(child: Text('No questions available.'))
              : viewModel.isExamDone
                  ? AlertDialog(
                      title: const Text('Exam Already Done'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'The exam of the current student is already done.'),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  viewModel.navigateToStudentSelection();
                                },
                                child: const Text('No'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  viewModel.showAdminPasswordDialog(context);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
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
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 20,
                            ),
                            itemCount: viewModel.quizData.quizzes.length,
                            itemBuilder: (context, index) {
                              final question =
                                  viewModel.quizData.quizzes[index];
                              return ListTile(
                                tileColor: Colors.white.withOpacity(0.5),
                                title: Text('Question ${index + 1}'),
                                subtitle: Text(question['Question']),
                                trailing: Text(
                                    "${question['EarnedPoints']} / ${question['TotalPoint']}"),
                                onTap: () {
                                  viewModel.showQuestionDialog(
                                      context, question);
                                },
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.onSubmitButtonPressed();
                          },
                          child: const Text('Submit'),
                        ),
                        verticalSpaceLarge,
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
