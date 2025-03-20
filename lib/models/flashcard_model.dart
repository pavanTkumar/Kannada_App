// lib/models/flashcard_model.dart
class Flashcard {
  final String kannada;
  final String english;
  bool isLearned;

  Flashcard({
    required this.kannada,
    required this.english,
    this.isLearned = false,
  });

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      kannada: map['kannada'] as String,
      english: map['english'] as String,
      isLearned: map['isLearned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kannada': kannada,
      'english': english,
      'isLearned': isLearned,
    };
  }
}

class Lesson {
  final String id;
  final String title;
  final String kannadaTitle;
  final List<Flashcard> flashcards;
  double progress;

  Lesson({
    required this.id,
    required this.title,
    required this.kannadaTitle,
    required this.flashcards,
    this.progress = 0.0,
  });
}