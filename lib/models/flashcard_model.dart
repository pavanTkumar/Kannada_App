// lib/models/flashcard_model.dart
class Flashcard {
  final String kannada;
  final String english;
  final Map<String, String> translations;
  bool isLearned;

  Flashcard({
    required this.kannada,
    required this.english,
    this.translations = const {},
    this.isLearned = false,
  });

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      kannada: map['kannada'] as String,
      english: map['english'] as String,
      translations: map['translations'] != null 
          ? Map<String, String>.from(map['translations'] as Map)
          : {'en': map['english'] as String},
      isLearned: map['isLearned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kannada': kannada,
      'english': english,
      'translations': translations,
      'isLearned': isLearned,
    };
  }
  
  // Get translation based on language code
  String getTranslation(String languageCode) {
    // If language is English or translation not available, return English
    if (languageCode == 'en' || !translations.containsKey(languageCode)) {
      return english;
    }
    return translations[languageCode]!;
  }
}

class Lesson {
  final String id;
  final String title;
  final String kannadaTitle;
  final String description;
  final List<Flashcard> flashcards;
  double progress;

  Lesson({
    required this.id,
    required this.title,
    required this.kannadaTitle,
    this.description = '',
    required this.flashcards,
    this.progress = 0.0,
  });
}