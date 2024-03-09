import 'package:quizapp/app/app.bottomsheets.dart';
import 'package:quizapp/app/app.dialogs.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/services/firebase_auth_service.dart';
import 'package:quizapp/services/module_selection_service.dart';
import 'package:quizapp/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();
  final ModuleSelectionService _moduleSelectionService =
      locator<ModuleSelectionService>();
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  signOut() async {
    await _firebaseAuthService.signOut();
    _navigationService.navigateToLoginView();
  }

  navigateToStudentSelection() {
    _navigationService.navigateToStudentsSelectionView();
  }

  navigateToExamView() {
    _navigationService.navigateToExamView();
  }

  navigateToFastAttendance() {
    _navigationService.navigateToFastAttendanceView();
  }

  goToStudentSelection() {
    _navigationService.navigateToStudentsSelectionView();
  }

  setModule(module) {
    _moduleSelectionService.setSelectedModule(module);
  }
}
