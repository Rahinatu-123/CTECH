import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth;
  User? _user;

  AuthService(this._auth) {
    _auth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
      debugPrint('Auth state changed: ${firebaseUser?.uid}');
      _user = firebaseUser != null ? User.fromFirebaseUser(firebaseUser) : null;
      
      // Update SharedPreferences login status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', firebaseUser != null);
      
      notifyListeners();
    });
  }

  // Get auth state changes
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _user;

  // Check if user is logged in
  bool get isLoggedIn => _user != null;

  // Sign up with email and password
  Future<firebase_auth.UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Attempting to sign up with email: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Sign up successful for user: ${credential.user?.uid}');
      return credential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Sign up error: ${e.code} - ${e.message}');
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      }
      throw e.message ?? 'An error occurred during sign up';
    }
  }

  // Sign in with email and password
  Future<firebase_auth.UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Attempting to sign in with email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Sign in successful for user: ${credential.user?.uid}');
      _user = credential.user != null ? User.fromFirebaseUser(credential.user!) : null;
      notifyListeners();
      return credential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Sign in error: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      }
      throw e.message ?? 'An error occurred during sign in';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await _auth.signOut();
    } catch (e) {
      throw 'An error occurred during sign out';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred while resetting password';
    }
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) await user.updateDisplayName(displayName);
        if (photoURL != null) await user.updatePhotoURL(photoURL);
        
        // Reload user to get updated data
        await user.reload();
        final updatedUser = _auth.currentUser;
        if (updatedUser != null) {
          _user = User.fromFirebaseUser(updatedUser);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Update profile error: $e');
      throw 'Failed to update profile';
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        _user = null;
        notifyListeners();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Delete account error: ${e.code} - ${e.message}');
      throw e.message ?? 'An error occurred while deleting account';
    }
  }
}
