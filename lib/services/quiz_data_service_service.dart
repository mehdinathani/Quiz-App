import 'package:gsheets/gsheets.dart';
import 'package:quizapp/ui/config.dart';

class QuizDataServiceService {
  final _gsheets = GSheets(Config.credentialsPath);

  Future<List<Map<String, String>>?> fetchAllQuizData() async {
    final ss = await _gsheets.spreadsheet(Config.questionSpreadsheet);
    final sheet = ss.worksheetByTitle(Config.classOneSheet);
    final quizData = await sheet?.values.map.allRows();
    return quizData;
  }
}
