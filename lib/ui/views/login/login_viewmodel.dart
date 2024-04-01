import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quizapp/app/app.locator.dart';
import 'package:quizapp/app/app.router.dart';
import 'package:quizapp/services/firebase_auth_service.dart';
import 'package:quizapp/ui/common/ui_helpers.dart';
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

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      await _firebaseAuthService.signInWithEmail(email, password);
      // Check if user is authenticated after login
      if (_firebaseAuthService.getCurrentUser() != null) {
        _navigationService.navigateToHomeView();
        emailController.clear();
        passwordController.clear();
        // Notify the view to rebuild after successful login
        currentUserEmail = _firebaseAuthService.getCurrentUser()!.email!;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Login failed: ${_firebaseAuthService.loginMessage} '),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
      // Display error message as a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${_firebaseAuthService.loginMessage} '),
        ),
      );
    }
  }
}
