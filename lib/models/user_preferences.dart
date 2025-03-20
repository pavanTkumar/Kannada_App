// lib/models/user_preferences.dart
class UserPreferences {
  final String name;
  final String preferredLanguage;
  final bool isDarkMode;

  UserPreferences({
    required this.name,
    required this.preferredLanguage,
    this.isDarkMode = false,
  });

  UserPreferences copyWith({
    String? name,
    String? preferredLanguage,
    bool? isDarkMode,
  }) {
    return UserPreferences(
      name: name ?? this.name,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preferredLanguage': preferredLanguage,
      'isDarkMode': isDarkMode,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      name: json['name'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
    );
  }
}