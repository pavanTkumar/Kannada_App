// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String _userName = '';
  String _error = '';
  
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get error => _error;
  
  // Clear any existing error
  void clearError() {
    _error = '';
    notifyListeners();
  }
  
  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      // Simulate Google sign-in process
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock successful sign-in
      _isAuthenticated = true;
      _userName = 'Google User';
      
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _userName);
      await prefs.setBool('is_authenticated', true);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to sign in with Google: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Sign in anonymously (guest)
  Future<bool> signInAnonymously() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      // Simulate anonymous sign-in process
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock successful sign-in
      _isAuthenticated = true;
      _userName = 'Guest User';
      
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _userName);
      await prefs.setBool('is_authenticated', true);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to sign in as guest: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Simple guest login with name
  Future<bool> loginAsGuest(String name) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      // Validate name
      if (name.trim().isEmpty) {
        _error = 'Please enter your name';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Save user name in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setBool('is_authenticated', true);
      
      _userName = name;
      _isAuthenticated = true;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Login failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Check if user is already logged in
  Future<bool> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('user_name');
      final isAuth = prefs.getBool('is_authenticated') ?? false;
      
      if (storedName != null && storedName.isNotEmpty && isAuth) {
        _userName = storedName;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();
      
      // Clear saved data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_name');
      await prefs.remove('is_authenticated');
      
      _isAuthenticated = false;
      _userName = '';
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Sign out failed: ${e.toString()}';
      notifyListeners();
    }
  }
}