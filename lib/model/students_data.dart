import 'package:flutter/material.dart';

class StudentsData extends ChangeNotifier {
  final List<Map<String, String>> students;

  StudentsData(this.students);
}
