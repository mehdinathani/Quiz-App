import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/services/module_selection_service.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
import 'package:quizapp/ui/config.dart';

class QuizDataServiceService {
  static const _credentials = Config.credentials;
  final _gsheets = GSheets(_credentials);
  var currentExamSheet = Config.classOneSheet;
  final ModuleSelectionService _moduleSelectionService =
      locator<ModuleSelectionService>();

  Future<List<Map<String, String>>?> fetchAllQuizData() async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(getExamSheetName(
        currentStudentGroup, _moduleSelectionService.getSelectedModule()));
    final quizData = await sheet?.values.map.allRows();
    return quizData;
  }

  Future<void> markQuestionAsAsked(int rowIndex) async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(getExamSheetName(
        currentStudentGroup, _moduleSelectionService.getSelectedModule()));
    await sheet?.values.insertRow(rowIndex, ['TRUE'], fromColumn: 10);
  }

  Future<void> updateEarnedPoints(String questionId, int earnedPoints) async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(Config.classOneSheet);
    await sheet?.values.insertValueByKeys(earnedPoints,
        columnKey: "EarnedPoints", rowKey: questionId);
  }

  Future<void> resetEarnedPoints() async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(
        getResultSheetName(_moduleSelectionService.getSelectedModule()));
    final quizData = await sheet?.values.map.allRows();

    if (quizData != null) {
      for (var question in quizData) {
        final rowKey = question["QuestionNumber"];

        // Update the "EarnedPoints" column value to 0
        await sheet?.values.insertValueByKeys(
          0, // Value to insert (0 in this case)
          columnKey: "EarnedPoints", // Column key for "EarnedPoints" column
          rowKey: rowKey!, // Row key
          eager: false, // Don't eagerly update
        );
      }
    }
  }

  String getResultSheetName(CurrentModuleType module) {
    if (module == CurrentModuleType.oral) {
      return Config.stundentOralResult;
    } else {
      return Config.stundentExamResult;
    }
  }

  String getExamSheetName(String group, CurrentModuleType module) {
    switch (group) {
      case "junior":
        return module == CurrentModuleType.oral
            ? Config.classOneOral
            : Config.classOneSheet;
      case "middle":
        return module == CurrentModuleType.oral
            ? Config.classtwoOral
            : Config.classTwoSheet;
      case "senior":
        return module == CurrentModuleType.oral
            ? Config.classthreeOral
            : Config.classthreeSheet;
      case "higher":
        return module == CurrentModuleType.oral
            ? Config.classfourOral
            : Config.classfourSheet;
      default:
        return Config.classOneSheet;
    }
  }
}
