import 'package:flutter/material.dart';

class QuizData extends ChangeNotifier {
  final List<Map<String, dynamic>> quizzes;

  QuizData(this.quizzes);

  void updateEarnedPoints(String questionId, int earnedPoints) {
    final quizIndex =
        quizzes.indexWhere((quiz) => quiz['QuestionNumber'] == questionId);
    if (quizIndex != -1) {
      quizzes[quizIndex]['EarnedPoints'] = earnedPoints.toString();
      notifyListeners();
    }
  }

  num calculateTotalScore() {
    num totalScore = 0;
    for (var quiz in quizzes) {
      totalScore += num.tryParse(quiz['EarnedPoints']) ?? 0;
    }
    return totalScore;
  }
}
