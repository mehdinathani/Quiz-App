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
    for (var student in students!) {
      if (student['Roll No'] == rollNumber) {
        student['Marks'] =
            marks.toString(); // Assuming marks is a column in your sheet
        await sheet?.values.map.appendRow(student);

        break;
      }
    }
  }

  // Update current student data when a new student is selected
  void updateCurrentStudentData(Map<String, String>? studentData) {
    currentStudentData = studentData;
  }
}
