// lib/models/user_preferences.dart
import 'achievement_model.dart';

class UserPreferences {
  final String name;
  final String preferredLanguage;
  final bool isDarkMode;
  final Map<String, double> quizScores;
  final List<Achievement> achievements;
  final int totalFlashcardsLearned;
  final int streakDays;
  final DateTime lastActiveDate;
  final String learningGoal;
  final int dailyGoalMinutes;
  final bool notificationsEnabled;
  final Map<String, dynamic> completedLessons;

  UserPreferences({
    required this.name,
    required this.preferredLanguage,
    this.isDarkMode = false,
    this.quizScores = const {},
    this.achievements = const [],
    this.totalFlashcardsLearned = 0,
    this.streakDays = 0,
    DateTime? lastActiveDate,
    this.learningGoal = 'Learn basics',
    this.dailyGoalMinutes = 10,
    this.notificationsEnabled = true,
    this.completedLessons = const {},
  }) : lastActiveDate = lastActiveDate ?? DateTime.now();

  UserPreferences copyWith({
    String? name,
    String? preferredLanguage,
    bool? isDarkMode,
    Map<String, double>? quizScores,
    List<Achievement>? achievements,
    int? totalFlashcardsLearned,
    int? streakDays,
    DateTime? lastActiveDate,
    String? learningGoal,
    int? dailyGoalMinutes,
    bool? notificationsEnabled,
    Map<String, dynamic>? completedLessons,
  }) {
    return UserPreferences(
      name: name ?? this.name,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      quizScores: quizScores ?? this.quizScores,
      achievements: achievements ?? this.achievements,
      totalFlashcardsLearned: totalFlashcardsLearned ?? this.totalFlashcardsLearned,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      learningGoal: learningGoal ?? this.learningGoal,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preferredLanguage': preferredLanguage,
      'isDarkMode': isDarkMode,
      'quizScores': quizScores,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'totalFlashcardsLearned': totalFlashcardsLearned,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate.toIso8601String(),
      'learningGoal': learningGoal,
      'dailyGoalMinutes': dailyGoalMinutes,
      'notificationsEnabled': notificationsEnabled,
      'completedLessons': completedLessons,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      name: json['name'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
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
      learningGoal: json['learningGoal'] as String? ?? 'Learn basics',
      dailyGoalMinutes: json['dailyGoalMinutes'] as int? ?? 10,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      completedLessons: json['completedLessons'] as Map<String, dynamic>? ?? {},
    );
  }
}