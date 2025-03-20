// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint("Starting Google Sign In flow");
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint("Google Sign In was cancelled by user");
        return null;
      }

      debugPrint("Google Sign In successful for: ${googleUser.email}");

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      debugPrint("Signing in to Firebase with Google credential");
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint("Firebase auth completed successfully: ${userCredential.user?.uid}");
      return userCredential;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign in anonymously - this is the function having issues
  Future<UserCredential?> signInAnonymously() async {
    try {
      debugPrint("Starting anonymous sign in with Firebase Auth version: ${_auth.app.options.apiKey}");
      // Add a delay to see if it helps with the race condition
      await Future.delayed(Duration(milliseconds: 500));
      
      final result = await _auth.signInAnonymously();
      debugPrint("Anonymous sign in completed successfully: ${result.user?.uid}");
      return result;
    } catch (e) {
      debugPrint('Error signing in anonymously: $e');
      // More detailed error logging
      if (e is FirebaseAuthException) {
        debugPrint('Firebase Auth Error Code: ${e.code}');
        debugPrint('Firebase Auth Error Message: ${e.message}');
        
        // Try to diagnose specific issues
        if (e.code == 'admin-restricted-operation') {
          debugPrint('CRITICAL: Anonymous sign-in is disabled in Firebase console. Enable it at Firebase console > Authentication > Sign-in method > Anonymous');
        } else if (e.code == 'operation-not-allowed') {
          debugPrint('CRITICAL: Operation not allowed - check Firebase console settings');
        }
      }
      
      // Try an alternative approach for anonymous auth
      try {
        debugPrint("Trying alternative anonymous sign in approach");
        final authResult = await FirebaseAuth.instance.signInAnonymously();
        debugPrint("Alternative anonymous sign in successful: ${authResult.user?.uid}");
        return authResult;
      } catch (altError) {
        debugPrint("Alternative approach also failed: $altError");
        return null;
      }
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      debugPrint("Signing out");
      await _googleSignIn.signOut();
      await _auth.signOut();
      debugPrint("Sign out completed");
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
}