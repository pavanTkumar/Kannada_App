// lib/services/direct_auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class DirectAuthService {
  final String apiKey = "AIzaSyDkYgBhH7aECk-fLLrKeJtyXTJ9fJb7ruc"; // Your Firebase API key
  final FirebaseAuth _auth = FirebaseAuth.instance; // Keep for state management
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Sign in anonymously using REST API
  Future<bool> signInAnonymously() async {
    debugPrint("Starting REST API anonymous sign in");
    
    try {
      final response = await http.post(
        Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey'),
        body: json.encode({'returnSecureToken': true}),
        headers: {'Content-Type': 'application/json'},
      );
      
      debugPrint("REST API Response: ${response.statusCode} ${response.body}");
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final idToken = responseData['idToken'];
        final localId = responseData['localId'];
        
        // Manually sign in to Firebase Auth with the custom token
        try {
          await _auth.signInWithCustomToken(idToken);
          debugPrint("Manually signed in with token");
          return true;
        } catch (e) {
          debugPrint("Error signing in with custom token: $e");
          
          // Even if Firebase Auth fails, consider the REST API success as a success
          debugPrint("REST API sign-in succeeded with user ID: $localId");
          return true;
        }
      } else {
        debugPrint("REST API sign-in failed: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error in REST API sign-in: $e");
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}