import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/model/students_data.dart';
import 'package:quizapp/services/students_data_service_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StudentsSelectionViewModel extends BaseViewModel {
  final _studentsDataService = locator<StudentsDataServiceService>();
  final NavigationService _navigationService = locator<NavigationService>();

  late StudentsData studentsData;

  List<String> rollNumbers = []; // Populate this list with roll numbers
  String? selectedRollNumber;
  Map<String, String>? selectedStudent;

  Future<void> fetchStudentData() async {
    final data = await _studentsDataService.fetchAllStudentsData();
    if (data != null) {
      studentsData = StudentsData(data);
      rollNumbers =
          studentsData.students.map((student) => student['Roll No']!).toList();
    }
    notifyListeners(); // Trigger UI update
  }

  Future<void> setSelectedRollNumber(String? rollNumber) async {
    selectedRollNumber = rollNumber;
    selectedStudent = null;
    if (rollNumber != null && studentsData.students.isNotEmpty) {
      selectedStudent = studentsData.students.firstWhere(
        (student) => student['Roll No'] == rollNumber,
      );
      notifyListeners(); // Trigger UI update
    }
  }

  navigateToHome() {
    _navigationService.navigateToHomeView();
  }

  goToQuizPage() {
    _navigationService.navigateToQuizView();
  }
}
