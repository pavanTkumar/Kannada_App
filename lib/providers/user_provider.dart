// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_preferences.dart';
import '../models/achievement_model.dart';

class UserProvider with ChangeNotifier {
  static const String _prefsKey = 'user_preferences';
  UserPreferences? _preferences;
  
  UserPreferences? get preferences => _preferences;
  bool get isInitialized => _preferences != null;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? prefsJson = prefs.getString(_prefsKey);
    if (prefsJson != null) {
      try {
        _preferences = UserPreferences.fromJson(json.decode(prefsJson));
        
        // Check if it's a new day to update streak
        final lastActive = _preferences!.lastActiveDate;
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final lastDay = DateTime(lastActive.year, lastActive.month, lastActive.day);
        
        if (today.isAfter(lastDay)) {
          if (today.difference(lastDay).inDays == 1) {
            // Consecutive day, increase streak
            await updateStreakDays(_preferences!.streakDays + 1);
          } else if (today.difference(lastDay).inDays > 1) {
            // Streak broken
            await updateStreakDays(1);
          }
          // Update last active date to today
          _preferences = _preferences!.copyWith(lastActiveDate: now);
          await savePreferences(_preferences!);
        }
      } catch (e) {
        debugPrint('Error parsing preferences: $e');
      }
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

  Future<void> updateQuizScore(String quizId, double score) async {
    if (_preferences != null) {
      final updatedScores = Map<String, double>.from(_preferences!.quizScores);
      updatedScores[quizId] = score;
      await savePreferences(_preferences!.copyWith(quizScores: updatedScores));
      
      // Check for achievements after updating score
      checkForAchievements();
    }
  }

  Future<void> addAchievement(Achievement achievement) async {
    if (_preferences != null) {
      // Check if achievement already exists
      if (_preferences!.achievements.any((a) => a.id == achievement.id)) {
        return;
      }
      
      final updatedAchievements = List<Achievement>.from(_preferences!.achievements);
      updatedAchievements.add(achievement);
      await savePreferences(_preferences!.copyWith(achievements: updatedAchievements));
    }
  }

  Future<void> updateFlashcardsLearned(int count) async {
    if (_preferences != null) {
      // Don't allow total to go below zero
      int newTotal = _preferences!.totalFlashcardsLearned + count;
      if (newTotal < 0) newTotal = 0;
      
      await savePreferences(_preferences!.copyWith(
        totalFlashcardsLearned: newTotal
      ));
      
      // Check for achievements
      checkForAchievements();
    }
  }

  Future<void> updateStreakDays(int streakDays) async {
    if (_preferences != null) {
      await savePreferences(_preferences!.copyWith(streakDays: streakDays));
      
      // Check for streak achievements
      checkForAchievements();
    }
  }

  void checkForAchievements() async {
    if (_preferences == null) return;
    
    // Flashcard achievements
    if (_preferences!.totalFlashcardsLearned >= 10) {
      await addAchievement(Achievement(
        id: 'flashcards_10',
        title: 'Beginner Learner',
        description: 'Learned 10 flashcards',
        iconName: 'school',
        dateEarned: DateTime.now(),
      ));
    }
    
    if (_preferences!.totalFlashcardsLearned >= 50) {
      await addAchievement(Achievement(
        id: 'flashcards_50',
        title: 'Intermediate Learner',
        description: 'Learned 50 flashcards',
        iconName: 'school',
        dateEarned: DateTime.now(),
      ));
    }
    
    if (_preferences!.totalFlashcardsLearned >= 100) {
      await addAchievement(Achievement(
        id: 'flashcards_100',
        title: 'Advanced Learner',
        description: 'Learned 100 flashcards',
        iconName: 'emoji_events',
        dateEarned: DateTime.now(),
      ));
    }
    
    // Streak achievements
    if (_preferences!.streakDays >= 3) {
      await addAchievement(Achievement(
        id: 'streak_3',
        title: 'Consistent Learner',
        description: 'Maintained a 3-day learning streak',
        iconName: 'local_fire_department',
        dateEarned: DateTime.now(),
      ));
    }
    
    if (_preferences!.streakDays >= 7) {
      await addAchievement(Achievement(
        id: 'streak_7',
        title: 'Weekly Warrior',
        description: 'Maintained a 7-day learning streak',
        iconName: 'local_fire_department',
        dateEarned: DateTime.now(),
      ));
    }
    
    if (_preferences!.streakDays >= 30) {
      await addAchievement(Achievement(
        id: 'streak_30',
        title: 'Kannada Enthusiast',
        description: 'Maintained a 30-day learning streak',
        iconName: 'workspace_premium',
        dateEarned: DateTime.now(),
      ));
    }
    
    // Quiz achievements based on scores
    if (_preferences!.quizScores.isNotEmpty) {
      // Check for perfect score achievement
      bool hasPerfectScore = _preferences!.quizScores.values.any((score) => score >= 100);
      if (hasPerfectScore) {
        await addAchievement(Achievement(
          id: 'quiz_perfect',
          title: 'Perfect Score',
          description: 'Achieved a perfect 100% on a quiz',
          iconName: 'emoji_events',
          dateEarned: DateTime.now(),
        ));
      }
      
      // Achievement for completing multiple quizzes
      if (_preferences!.quizScores.length >= 3) {
        await addAchievement(Achievement(
          id: 'quiz_3',
          title: 'Quiz Enthusiast',
          description: 'Completed 3 different quizzes',
          iconName: 'quiz',
          dateEarned: DateTime.now(),
        ));
      }
      
      // Achievement for good average score
      double avgScore = _calculateAverageQuizScore();
      if (avgScore >= 80 && _preferences!.quizScores.length >= 2) {
        await addAchievement(Achievement(
          id: 'quiz_master',
          title: 'Quiz Master',
          description: 'Maintained an average score of 80% or higher across multiple quizzes',
          iconName: 'psychology',
          dateEarned: DateTime.now(),
        ));
      }
    }
  }
  
  double _calculateAverageQuizScore() {
    if (_preferences == null || _preferences!.quizScores.isEmpty) {
      return 0.0;
    }
    
    double total = 0.0;
    for (final score in _preferences!.quizScores.values) {
      total += score;
    }
    
    return total / _preferences!.quizScores.length;
  }
}