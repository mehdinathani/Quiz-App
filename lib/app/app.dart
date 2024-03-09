import 'package:quizapp/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:quizapp/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:quizapp/ui/views/home/home_view.dart';
import 'package:quizapp/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:quizapp/ui/views/students_selection/students_selection_view.dart';
import 'package:quizapp/services/students_data_service_service.dart';
import 'package:quizapp/services/quiz_data_service_service.dart';
import 'package:quizapp/ui/views/quiz/quiz_view.dart';
import 'package:quizapp/ui/views/exam/exam_view.dart';
import 'package:quizapp/ui/views/fast_attendance/fast_attendance_view.dart';
import 'package:quizapp/services/module_selection_service.dart';
import 'package:quizapp/services/firebase_auth_service.dart';
import 'package:quizapp/ui/views/login/login_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: StudentsSelectionView),
    MaterialRoute(page: QuizView),
    MaterialRoute(page: ExamView),
    MaterialRoute(page: FastAttendanceView),
    MaterialRoute(page: LoginView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: StudentsDataServiceService),
    LazySingleton(classType: QuizDataServiceService),
    LazySingleton(classType: ModuleSelectionService),
    LazySingleton(classType: FirebaseAuthService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
