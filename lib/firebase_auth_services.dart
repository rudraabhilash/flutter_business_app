import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create user with email and password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign up error: $e'); // Print error details for debugging
      rethrow; // Rethrow to handle it in the UI layer
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign in error: $e'); // Print error details for debugging
      rethrow; // Rethrow to handle it in the UI layer
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign out error: $e'); // Print error details for debugging
      rethrow; // Rethrow to handle it in the UI layer
    }
  }

  // Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Check if the user is signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password reset error: $e'); // Print error details for debugging
      rethrow; // Rethrow to handle it in the UI layer
    }
  }
}
