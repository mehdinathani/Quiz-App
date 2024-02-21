import 'package:flutter/material.dart';

class QuizData extends ChangeNotifier {
  final List<Map<String, dynamic>> quizzes;

  QuizData(this.quizzes);
}
