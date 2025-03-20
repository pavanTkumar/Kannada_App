// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_preferences.dart';

class UserProvider with ChangeNotifier {
  static const String _prefsKey = 'user_preferences';
  UserPreferences? _preferences;
  
  UserPreferences? get preferences => _preferences;
  bool get isInitialized => _preferences != null;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? prefsJson = prefs.getString(_prefsKey);
    if (prefsJson != null) {
      _preferences = UserPreferences.fromJson(json.decode(prefsJson));
      notifyListeners();
    }
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, json.encode(preferences.toJson()));
    _preferences = preferences;
    notifyListeners();
  }

  Future<void> updateDarkMode(bool isDarkMode) async {
    if (_preferences != null) {
      await savePreferences(_preferences!.copyWith(isDarkMode: isDarkMode));
    }
  }
}