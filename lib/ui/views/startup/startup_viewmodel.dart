import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/services/firebase_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();

  // Method to run startup logic
  Future<void> runStartupLogic() async {
    // Delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 3));

    // Check if the user is already authenticated
    User? user = _firebaseAuthService.getCurrentUser();

    if (user != null) {
      // User is already logged in, navigate to HomeView
      _navigationService.replaceWith(Routes.homeView);
    } else {
      // User is not logged in, navigate to LoginView
      _navigationService.replaceWith(Routes.loginView);
    }
  }
}
