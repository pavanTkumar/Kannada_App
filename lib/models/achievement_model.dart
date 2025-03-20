// lib/models/achievement_model.dart
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime dateEarned;
  
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.dateEarned,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'dateEarned': dateEarned.toIso8601String(),
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['iconName'],
      dateEarned: DateTime.parse(json['dateEarned']),
    );
  }
}