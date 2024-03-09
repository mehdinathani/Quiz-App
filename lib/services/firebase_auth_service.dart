import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Returns the current authenticated user, if any
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Returns a stream that emits the current user when their sign-in state changes
  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  // Attempts to sign in the user with the provided email address and password
  Future<void> signInWithEmail(String emailAddress, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // If login successful, print a success message
      debugPrint("Login Successful. User: ${credential.user}");
    } on FirebaseAuthException catch (e) {
      // Handle different authentication exceptions
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else {
        debugPrint('Error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
