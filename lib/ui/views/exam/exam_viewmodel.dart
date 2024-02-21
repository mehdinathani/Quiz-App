import 'package:flutter/material.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/model/quiz_data.dart';
import 'package:quizapp/services/quiz_data_service_service.dart';
import 'package:stacked/stacked.dart';

class ExamViewModel extends BaseViewModel {
  final _quizService = locator<QuizDataServiceService>();

  late QuizData quizData;

  Future<void> fetchQuizData() async {
    setBusy(true);
    final quizDataFromService = await _quizService.fetchAllQuizData();
    if (quizDataFromService != null) {
      quizData = QuizData(quizDataFromService);
    }
    setBusy(false);
  }

  void showQuestionDialog(BuildContext context, Map<String, dynamic> question) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question: ${question['Question']}'),
              Text('Total Marks: ${question['TotalPoint']}'),
              const SizedBox(height: 10),
              if (question['QuestionType'] == 'MCQs') ..._buildMCQButtons(),
              if (question['QuestionType'] == 'TrueFalse')
                ..._buildTrueFalseButtons(),
              if (question['QuestionType'] == 'Descriptive')
                _buildDescriptiveField(context),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildMCQButtons() {
    return [
      ElevatedButton(
        onPressed: () {
          // Handle MCQs option A
        },
        child: const Text('A'),
      ),
      ElevatedButton(
        onPressed: () {
          // Handle MCQs option B
        },
        child: const Text('B'),
      ),
      ElevatedButton(
        onPressed: () {
          // Handle MCQs option C
        },
        child: const Text('C'),
      ),
      ElevatedButton(
        onPressed: () {
          // Handle MCQs option D
        },
        child: const Text('D'),
      ),
    ];
  }

  List<Widget> _buildTrueFalseButtons() {
    return [
      ElevatedButton(
        onPressed: () {
          // Handle TrueFalse option True
        },
        child: Text('True'),
      ),
      ElevatedButton(
        onPressed: () {
          // Handle TrueFalse option False
        },
        child: Text('False'),
      ),
    ];
  }

  Widget _buildDescriptiveField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(labelText: 'Enter Marks'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle Cancel
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle OK
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      ],
    );
  }
}
