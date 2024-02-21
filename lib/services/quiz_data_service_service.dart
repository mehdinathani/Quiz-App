import 'package:gsheets/gsheets.dart';
import 'package:quizapp/ui/config.dart';

class QuizDataServiceService {
  static const _credentials = Config.credentials;
  final _gsheets = GSheets(_credentials);

  Future<List<Map<String, String>>?> fetchAllQuizData() async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(Config.classOneSheet);
    final quizData = await sheet?.values.map.allRows();
    return quizData;
  }

  Future<void> markQuestionAsAsked(int rowIndex) async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(Config.classOneSheet);
    await sheet?.values.insertRow(rowIndex, ['TRUE'], fromColumn: 10);
  }
}
