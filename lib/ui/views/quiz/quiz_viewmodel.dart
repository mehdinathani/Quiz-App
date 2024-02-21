import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/model/quiz_data.dart';
import 'package:quizapp/services/quiz_data_service_service.dart';
import 'package:stacked/stacked.dart';

class QuizViewModel extends BaseViewModel {
  final _quizService =
      locator<QuizDataServiceService>(); // Assuming you have a QuizService

  int studentScore = 0;

  late QuizData quizData;
  late List<Map<String, dynamic>> allQuizData;
  late int totalQuestions;
  Set<int> askedQuestions = {}; // Track the indices of asked questions

  Map<String, dynamic>? randomQuiz;

  Future<void> fetchQuizData() async {
    final quizDataFromService = await _quizService.fetchAllQuizData();
    if (quizDataFromService != null) {
      allQuizData = quizDataFromService;
      totalQuestions = allQuizData.length;
      quizData = QuizData(allQuizData);
      debugPrint(allQuizData.toString()); // Debug print quiz data
    }
    notifyListeners(); // Trigger UI update
  }

  Future<void> showRandomQuizQuestion() async {
    final unansweredQuestions = allQuizData
        .where((question) =>
            !askedQuestions.contains(allQuizData.indexOf(question)))
        .toList();
    if (unansweredQuestions.isNotEmpty) {
      final randomIndex = Random().nextInt(unansweredQuestions.length);
      randomQuiz = unansweredQuestions[randomIndex];
      debugPrint('Random Quiz Question: $randomQuiz');
      // Mark the question as asked
      askedQuestions.add(allQuizData.indexOf(randomQuiz!));
      notifyListeners(); // Trigger UI update
    } else {
      debugPrint('All quiz questions have been asked.');
    }
  }

  void checkAnswer(String userAnswer) {
    if (randomQuiz != null) {
      final correctAnswer = randomQuiz!['CorrectAnswer'];
      if (correctAnswer == userAnswer) {
        studentScore++;
        debugPrint('Correct!');
      } else {
        debugPrint('Incorrect!');
      }
      // Move to the next question
      showRandomQuizQuestion();
    }
  }
}
