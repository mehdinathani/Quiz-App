import 'package:flutter/material.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/model/quiz_data.dart';
import 'package:quizapp/services/quiz_data_service_service.dart';
import 'package:quizapp/services/students_data_service_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ExamViewModel extends BaseViewModel {
  final _quizService = locator<QuizDataServiceService>();
  final StudentsDataServiceService _studentsDataService =
      locator<StudentsDataServiceService>();
  num studentScore = 0;
  TextEditingController userTextController = TextEditingController();
  final NavigationService _navigationService = NavigationService();

  late QuizData quizData;
  Map<String, String>? currentStudentData;

  Future<void> fetchQuizData() async {
    setBusy(true);
    currentStudentData = _studentsDataService.currentStudentData;
    // await _quizService
    //     .resetEarnedPoints(); // Reset earned points for new student

    final quizDataFromService = await _quizService.fetchAllQuizData();
    if (quizDataFromService != null) {
      quizData = QuizData(quizDataFromService);
    }
    setBusy(false);
  }

  void updateEarnedPoints(String questionId, int earnedPoints) async {
    // await _quizService.updateEarnedPoints(questionId, earnedPoints);
    quizData.updateEarnedPoints(questionId, earnedPoints);
    // studentScore += earnedPoints;
    calculateTotalScore();
    notifyListeners();
  }

  void calculateTotalScore() {
    studentScore = quizData.calculateTotalScore();
    notifyListeners(); // Notify listeners of the ViewModel
  }

  Future<void> onSubmitButtonPressed() async {
    // Get the required data
    final rollNumber = currentStudentData!['Roll No'];
    final name = currentStudentData!['Name'];
    final fathersName = currentStudentData!["Father's Name"];
    final group = currentStudentData!["GROUP"];

    // Parse EarnedPoints to integers
    final earnedPointsPerQuestion = quizData.quizzes
        .map((quiz) => int.parse(quiz['EarnedPoints']))
        .toList();

    final totalScore =
        studentScore; // Assuming studentScore is already calculated
    final invigilatorName = 'Your invigilator name'; // Get this from somewhere

    // Submit the exam result
    await _studentsDataService.submitExamResult(
      rollNumber!,
      name!,
      fathersName!,
      group!,
      earnedPointsPerQuestion,
      totalScore,
      invigilatorName,
    );
    navigateToStudentSelection();
    // Perform any additional actions after submitting, if needed
  }

  navigateToStudentSelection() {
    _navigationService.navigateToStudentsSelectionView();
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
              if (question['QuestionType'] == 'MCQs')
                ..._buildMCQButtons(question, context),
              if (question['QuestionType'] == 'TrueFalse')
                ..._buildTrueFalseButtons(question, context),
              if (question['QuestionType'] == 'Descriptive')
                _buildDescriptiveField(question, context),
            ],
          ),
        );
      },
    );
  }

  void checkAnswer(
      Map<String, dynamic> question, String userAnswer, BuildContext context) {
    final questionType = question['QuestionType'];
    final correctAnswer = question['CorrectAnswer'];

    if (questionType == 'Descriptive') {
      final int? totalPoints = int.tryParse(question['TotalPoint']);
      if (totalPoints != null) {
        try {
          final int userMarks = int.parse(userAnswer);
          if (userMarks >= 0 && userMarks <= totalPoints) {
            updateEarnedPoints(question['QuestionNumber'], userMarks);
            debugPrint('Marks added: $userMarks');
          } else {
            debugPrint('Invalid marks entered.');
          }
        } catch (e) {
          debugPrint('Error parsing marks: $e');
        }
      } else {
        debugPrint('TotalPoint value not found.');
      }
    } else {
      if (correctAnswer == userAnswer) {
        final int? totalPoints = int.tryParse(question['TotalPoint']);
        debugPrint(totalPoints.toString());
        updateEarnedPoints(
            question['QuestionNumber'], int.tryParse(question['TotalPoint'])!);

        // if (totalPoints != null) {
        //   studentScore += totalPoints;
        // }
        debugPrint('Correct!');
      } else {
        debugPrint('Incorrect!');
      }
    }
    // / Close the dialog
    Navigator.pop(context);
    rebuildUi();
  }

  List<Widget> _buildMCQButtons(
      Map<String, dynamic> question, BuildContext context) {
    return [
      ElevatedButton(
        onPressed: () {
          checkAnswer(question, "A", context);
        },
        child: Text('A: ${question['A']}'),
      ),
      ElevatedButton(
        onPressed: () {
          checkAnswer(question, "B", context);
        },
        child: Text('B: ${question['B']}'),
      ),
      ElevatedButton(
        onPressed: () {
          checkAnswer(question, "C", context);
        },
        child: Text('C: ${question['C']}'),
      ),
      ElevatedButton(
        onPressed: () {
          checkAnswer(question, "D", context);
        },
        child: Text('D: ${question['D']}'),
      ),
    ];
  }

  List<Widget> _buildTrueFalseButtons(
      Map<String, dynamic> question, BuildContext context) {
    return [
      ElevatedButton(
        onPressed: () {
          checkAnswer(question, "true", context);
        },
        child: const Text('True'),
      ),
      ElevatedButton(
        onPressed: () {
          checkAnswer(question, "false", context);
        },
        child: const Text('False'),
      ),
    ];
  }

  Widget _buildDescriptiveField(
      Map<String, dynamic> question, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: userTextController,
          decoration: const InputDecoration(labelText: 'Enter Marks'),
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
                checkAnswer(question, userTextController.text, context);
                userTextController.clear();
              },
              child: Text('OK.'),
            ),
          ],
        ),
      ],
    );
  }
}
