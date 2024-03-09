import 'package:flutter/material.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/services/firebase_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;
    await _firebaseAuthService.signInWithEmail(email, password);
    // Perform login operation with email and password
    // You can handle validation, authentication, etc. here
    debugPrint('Email: $email, Password: $password');

    // Check if user is authenticated after login
    if (_firebaseAuthService.getCurrentUser() != null) {
      _navigationService.navigateToHomeView();
      emailController.clear();
      passwordController.clear();
      // If user is authenticated, navigate to home view or perform any other actions
      // Notify the view to rebuild after successful login
      notifyListeners();
    }
  }
}
