import 'package:gsheets/gsheets.dart';
import 'package:quizapp/ui/config.dart';

class StudentsDataServiceService {
  static const _credentials = Config.credentials;
  final _gsheets = GSheets(_credentials);
  String currentStudentRollNumber = "";
  Map<String, String>? currentStudentData;

  Future<List<Map<String, String>>?> fetchAllStudentsData() async {
    final ss = await _gsheets.spreadsheet(Config.studentsDataSpreadSheet);
    final sheet = ss.worksheetByTitle(Config.studentsDataSheet);
    final students = await sheet?.values.map.allRows();
    return students;
  }

  Future<void> updateMarks(String rollNumber, int marks) async {
    final ss = await _gsheets.spreadsheet(Config.studentsDataSpreadSheet);
    final sheet = ss.worksheetByTitle(Config.studentsDataSheet);
    final students = await sheet?.values.map.allRows();
    sheet?.values
        .insertValueByKeys(marks, columnKey: "Marks", rowKey: rollNumber);
    // for (var student in students!) {
    //   if (student['Roll No'] == rollNumber) {
    //     student['Marks'] =
    //         marks.toString(); // Assuming marks is a column in your sheet
    //     await sheet?.values.map.appendRow(student);

    //     break;
    //   }
    // }
  }

  // Update current student data when a new student is selected
  void updateCurrentStudentData(Map<String, String>? studentData) {
    currentStudentData = studentData;
  }

  Future<void> submitExamResult(
    String rollNumber,
    String name,
    String fathersName,
    String group,
    List<int> earnedPointsPerQuestion,
    num totalScore,
    String invigilatorName,
  ) async {
    final ss = await _gsheets.spreadsheet(Config.studentsDataSpreadSheet);
    final sheet = ss.worksheetByTitle(Config.stundentExamResult);

    // Check if the roll number already exists
    final data = await sheet?.values.allRows();
    final existingRowIndex =
        data!.indexWhere((row) => row.contains(rollNumber));

    if (existingRowIndex != -1) {
      // If the row exists, update the row with the new score
      final updatedRow = [
        rollNumber,
        name,
        fathersName,
        group,
        totalScore.toString(),
        ...earnedPointsPerQuestion
            .map((earnedPoints) => earnedPoints.toString()),
        invigilatorName,
      ];
      await sheet?.values.insertRow(existingRowIndex + 1, updatedRow);
    } else {
      // If the row does not exist, add a new row
      final newRow = [
        rollNumber,
        name,
        fathersName,
        group,
        totalScore.toString(),
        ...earnedPointsPerQuestion
            .map((earnedPoints) => earnedPoints.toString()),
        invigilatorName,
      ];
      await sheet?.values.appendRow(newRow);
    }
  }

  Future<Map<String, String>> getStudentExamData(String rollNumber) async {
    final ss = await _gsheets.spreadsheet(Config.studentsDataSpreadSheet);
    final sheet = ss.worksheetByTitle(Config.stundentExamResult);

    // Fetch the row corresponding to the given roll number
    final rowData = await sheet?.values.map.rowByKey(rollNumber);

    if (rowData == null) {
      // Roll number not found, handle the error
      throw Exception('Roll number not found');
    }

    // Assuming the headers are in the first row
    final headers = await sheet?.values.row(1);

    if (headers == null) {
      // Headers not found, handle the error
      throw Exception('Headers not found');
    }

    // Create a map of headers and their corresponding values
    final examData = rowData;

    return examData;
  }
}
