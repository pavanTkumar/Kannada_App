// lib/models/user_preferences.dart
import 'package:flutter/material.dart';
import 'achievement_model.dart';

class UserPreferences {
  final String name;
  final String preferredLanguage;
  final Locale locale;
  final bool isDarkMode;
  final Map<String, double> quizScores;
  final List<Achievement> achievements;
  final int totalFlashcardsLearned;
  final int streakDays;
  final DateTime lastActiveDate;

  UserPreferences({
    required this.name,
    required this.preferredLanguage,
    Locale? locale,
    this.isDarkMode = false,
    this.quizScores = const {},
    this.achievements = const [],
    this.totalFlashcardsLearned = 0,
    this.streakDays = 0,
    DateTime? lastActiveDate,
  }) : locale = locale ?? const Locale('en'),
       lastActiveDate = lastActiveDate ?? DateTime.now();

  UserPreferences copyWith({
    String? name,
    String? preferredLanguage,
    Locale? locale,
    bool? isDarkMode,
    Map<String, double>? quizScores,
    List<Achievement>? achievements,
    int? totalFlashcardsLearned,
    int? streakDays,
    DateTime? lastActiveDate,
  }) {
    return UserPreferences(
      name: name ?? this.name,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      locale: locale ?? this.locale,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      quizScores: quizScores ?? this.quizScores,
      achievements: achievements ?? this.achievements,
      totalFlashcardsLearned: totalFlashcardsLearned ?? this.totalFlashcardsLearned,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preferredLanguage': preferredLanguage,
      'locale': '${locale.languageCode}_${locale.countryCode ?? ''}',
      'isDarkMode': isDarkMode,
      'quizScores': quizScores,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'totalFlashcardsLearned': totalFlashcardsLearned,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    Locale locale = const Locale('en');
    if (json['locale'] != null) {
      final localeString = json['locale'] as String;
      final parts = localeString.split('_');
      if (parts.length >= 1) {
        locale = Locale(parts[0], parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null);
      }
    }
    
    return UserPreferences(
      name: json['name'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      locale: locale,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      quizScores: json['quizScores'] != null
          ? Map<String, double>.from(json['quizScores'])
          : {},
      achievements: json['achievements'] != null
          ? (json['achievements'] as List)
              .map((a) => Achievement.fromJson(a))
              .toList()
          : [],
      totalFlashcardsLearned: json['totalFlashcardsLearned'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'])
          : DateTime.now(),
    );
  }
}