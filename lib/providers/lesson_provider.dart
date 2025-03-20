// lib/providers/lesson_provider.dart
import 'package:flutter/foundation.dart';
import '../models/flashcard_model.dart';
import '../services/dictionary_service.dart';

class LessonProvider with ChangeNotifier {
  final DictionaryService _dictionaryService = DictionaryService();
  Map<String, Lesson> _lessons = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Map<String, Lesson> get lessons => _lessons;

  Future<void> initializeLessons() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get lesson data
      final lessonData = _dictionaryService.getLessonData();
      final progress = await _dictionaryService.getAllProgress();

      _lessons = {
        'vowels': Lesson(
          id: 'vowels',
          title: 'Vowels',
          kannadaTitle: 'ಸ್ವರಗಳು',
          flashcards: lessonData['vowels']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['vowels'] ?? 0.0,
        ),
        'consonants': Lesson(
          id: 'consonants',
          title: 'Consonants',
          kannadaTitle: 'ವ್ಯಂಜನಗಳು',
          flashcards: lessonData['consonants']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['consonants'] ?? 0.0,
        ),
        'numbers': Lesson(
          id: 'numbers',
          title: 'Numbers',
          kannadaTitle: 'ಅಂಕಿಗಳು',
          flashcards: lessonData['numbers']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['numbers'] ?? 0.0,
        ),
      };
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markFlashcardAsLearned(String lessonId, int flashcardIndex) async {
    if (!_lessons.containsKey(lessonId)) return;

    final lesson = _lessons[lessonId]!;
    if (flashcardIndex >= lesson.flashcards.length) return;

    lesson.flashcards[flashcardIndex].isLearned = true;
    lesson.progress = lesson.flashcards
            .where((flashcard) => flashcard.isLearned)
            .length /
        lesson.flashcards.length *
        100;

    await _dictionaryService.saveProgress(lessonId, lesson.progress);
    notifyListeners();
  }
}