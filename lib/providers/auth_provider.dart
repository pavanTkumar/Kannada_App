// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider() {
    // Initialize the user
    _user = _authService.currentUser;
    
    // Listen for auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Temporary method for development
  void simulateLogin() {
    _isLoading = false;
    // Set authenticated without Firebase
    notifyListeners();
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signInWithGoogle();
      _isLoading = false;
      if (result == null) {
        _error = "Google Sign In failed";
        notifyListeners();
        return false;
      }
      
      // For development only
      simulateLogin();
      
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      debugPrint('Error in signInWithGoogle: $e');
      notifyListeners();
      return false;
    }
  }

  // Sign in as guest
  Future<bool> signInAnonymously() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For development to bypass Firebase authentication issues
      simulateLogin();
      return true;
      
      // Uncomment this when Firebase auth is working
      /*
      final result = await _authService.signInAnonymously();
      _isLoading = false;
      if (result == null) {
        _error = "Anonymous Sign In failed";
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
      */
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      debugPrint('Error in signInAnonymously: $e');
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signOut();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error in signOut: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}