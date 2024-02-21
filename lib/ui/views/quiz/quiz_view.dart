import 'package:flutter/material.dart';
import 'package:quizapp/ui/views/quiz/quiz_viewmodel.dart';
import 'package:stacked/stacked.dart';

class QuizView extends StackedView<QuizViewModel> {
  const QuizView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    QuizViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: !viewModel.quizEnd
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [Text(viewModel.currentStudentData!['Name']!)],
                  ),
                  Text(viewModel.studentScore.toString()),
                  if (viewModel.randomQuiz != null) ...[
                    Text(
                      'Question: ${viewModel.randomQuiz!['Question']}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    // Conditional rendering based on question type
                    if (viewModel.randomQuiz!['QuestionType'] == 'MCQs')
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => viewModel.checkAnswer('A'),
                            child: Text('A: ${viewModel.randomQuiz!['A']}'),
                          ),
                          ElevatedButton(
                            onPressed: () => viewModel.checkAnswer('B'),
                            child: Text('B: ${viewModel.randomQuiz!['B']}'),
                          ),
                          ElevatedButton(
                            onPressed: () => viewModel.checkAnswer('C'),
                            child: Text('C: ${viewModel.randomQuiz!['C']}'),
                          ),
                          ElevatedButton(
                            onPressed: () => viewModel.checkAnswer('D'),
                            child: Text('D: ${viewModel.randomQuiz!['D']}'),
                          ),
                        ],
                      ),
                    if (viewModel.randomQuiz!['QuestionType'] == 'TrueFalse')
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => viewModel.checkAnswer('true'),
                            child: const Text('True'),
                          ),
                          ElevatedButton(
                            onPressed: () => viewModel.checkAnswer('false'),
                            child: const Text('False'),
                          ),
                        ],
                      ),
                    if (viewModel.randomQuiz!['QuestionType'] == 'Descriptive')
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Enter your answer',
                        ),
                        onSubmitted: (value) => viewModel.checkAnswer(value),
                      ),
                  ],
                  viewModel.isBusy
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: viewModel.showRandomQuizQuestion,
                          child: const Text('Next Question'),
                        ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Finished."),
                  Text(
                    viewModel.studentScore.toString(),
                  ),
                  const Text("Move to Next"),
                  ElevatedButton(
                    onPressed: viewModel.goToStudentSelection,
                    child: const Text("Select Next Student"),
                  )
                ],
              ),
      ),
    );
  }

  @override
  QuizViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      QuizViewModel();
  @override
  void onViewModelReady(QuizViewModel viewModel) {
    viewModel.fetchQuizData();
    super.onViewModelReady(viewModel);
  }
}
