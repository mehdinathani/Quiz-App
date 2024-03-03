import 'package:gsheets/gsheets.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
import 'package:quizapp/ui/config.dart';

class QuizDataServiceService {
  static const _credentials = Config.credentials;
  final _gsheets = GSheets(_credentials);
  var currentExamSheet = Config.classOneSheet;

  Future<List<Map<String, String>>?> fetchAllQuizData() async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(getExamSheetName(currentStudentGroup));
    final quizData = await sheet?.values.map.allRows();
    return quizData;
  }

  Future<void> markQuestionAsAsked(int rowIndex) async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(Config.classOneSheet);
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
    final sheet = ss.worksheetByTitle(Config.classOneSheet);
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

  getExamSheetName(group) {
    switch (group) {
      case "junior":
        currentExamSheet = Config.classOneSheet;
        break;

      case "middle":
        currentExamSheet = Config.classTwoSheet;
        break;
      case "senior":
        currentExamSheet = Config.classthreeSheet;
        break;
      case "higher":
        currentExamSheet = Config.classfourSheet;
        break;
      default:
        currentExamSheet = Config.classOneSheet;
        break;
    }
    return currentExamSheet;
  }
}
