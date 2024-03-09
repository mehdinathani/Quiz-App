import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:quizapp/services/students_data_service_service.dart';
import 'package:quizapp/services/quiz_data_service_service.dart';
import 'package:quizapp/services/module_selection_service.dart';
import 'package:quizapp/services/firebase_auth_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<StudentsDataServiceService>(
      onMissingStub: OnMissingStub.returnDefault),
  MockSpec<QuizDataServiceService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ModuleSelectionService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<FirebaseAuthService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterStudentsDataServiceService();
  getAndRegisterQuizDataServiceService();
  getAndRegisterModuleSelectionService();
  getAndRegisterFirebaseAuthService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockStudentsDataServiceService getAndRegisterStudentsDataServiceService() {
  _removeRegistrationIfExists<StudentsDataServiceService>();
  final service = MockStudentsDataServiceService();
  locator.registerSingleton<StudentsDataServiceService>(service);
  return service;
}

MockQuizDataServiceService getAndRegisterQuizDataServiceService() {
  _removeRegistrationIfExists<QuizDataServiceService>();
  final service = MockQuizDataServiceService();
  locator.registerSingleton<QuizDataServiceService>(service);
  return service;
}

MockModuleSelectionService getAndRegisterModuleSelectionService() {
  _removeRegistrationIfExists<ModuleSelectionService>();
  final service = MockModuleSelectionService();
  locator.registerSingleton<ModuleSelectionService>(service);
  return service;
}

MockFirebaseAuthService getAndRegisterFirebaseAuthService() {
  _removeRegistrationIfExists<FirebaseAuthService>();
  final service = MockFirebaseAuthService();
  locator.registerSingleton<FirebaseAuthService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
