// lib/providers/lesson_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../services/dictionary_service.dart';
import '../providers/user_provider.dart';
import '../utils/navigator_key.dart';

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
          description: 'Learn the basic vowels in Kannada alphabet',
          flashcards: lessonData['vowels']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['vowels'] ?? 0.0,
        ),
        'consonants': Lesson(
          id: 'consonants',
          title: 'Consonants',
          kannadaTitle: 'ವ್ಯಂಜನಗಳು',
          description: 'Master the basic consonants in Kannada',
          flashcards: lessonData['consonants']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['consonants'] ?? 0.0,
        ),
        'numbers': Lesson(
          id: 'numbers',
          title: 'Numbers',
          kannadaTitle: 'ಅಂಕಿಗಳು',
          description: 'Learn counting in Kannada',
          flashcards: lessonData['numbers']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['numbers'] ?? 0.0,
        ),
        'greetings': Lesson(
          id: 'greetings',
          title: 'Greetings',
          kannadaTitle: 'ಶುಭಾಶಯಗಳು',
          description: 'Common greetings and expressions',
          flashcards: lessonData['greetings']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['greetings'] ?? 0.0,
        ),
        'daily_phrases': Lesson(
          id: 'daily_phrases',
          title: 'Daily Phrases',
          kannadaTitle: 'ದೈನಂದಿನ ವಾಕ್ಯಗಳು',
          description: 'Essential phrases for everyday conversations',
          flashcards: lessonData['daily_phrases']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['daily_phrases'] ?? 0.0,
        ),
        'food': Lesson(
          id: 'food',
          title: 'Food & Drinks',
          kannadaTitle: 'ಆಹಾರ & ಪಾನೀಯಗಳು',
          description: 'Learn about food and drinks in Kannada',
          flashcards: lessonData['food']!
              .map((data) => Flashcard.fromMap(data))
              .toList(),
          progress: progress['food'] ?? 0.0,
        ),
      };
    } catch (e) {
      debugPrint('Error initializing lessons: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markFlashcardAsLearned(String lessonId, int flashcardIndex, [bool markAsLearned = true]) async {
    if (!_lessons.containsKey(lessonId)) return;

    final lesson = _lessons[lessonId]!;
    if (flashcardIndex >= lesson.flashcards.length) return;

    // Update flashcard learned status
    final wasLearned = lesson.flashcards[flashcardIndex].isLearned;
    lesson.flashcards[flashcardIndex].isLearned = markAsLearned;
    
    // If the status changed from not learned to learned, increment count
    if (!wasLearned && markAsLearned) {
      // Increment user's learned flashcards count
      Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false)
          .updateFlashcardsLearned(1);
    } 
    // If the status changed from learned to not learned, decrement count
    else if (wasLearned && !markAsLearned) {
      // Decrement user's learned flashcards count (but don't go below zero)
      Provider.of<UserProvider>(navigatorKey.currentContext!, listen: false)
          .updateFlashcardsLearned(-1);
    }
    
    // Update lesson progress
    lesson.progress = lesson.flashcards
            .where((flashcard) => flashcard.isLearned)
            .length /
        lesson.flashcards.length *
        100;

    await _dictionaryService.saveProgress(lessonId, lesson.progress);
    notifyListeners();
  }
  
  Future<void> toggleFlashcardLearned(String lessonId, int flashcardIndex, bool isLearned) async {
    return markFlashcardAsLearned(lessonId, flashcardIndex, isLearned);
  }
  
  // Get all learned flashcards count
  int getTotalLearnedFlashcards() {
    int count = 0;
    for (final lesson in _lessons.values) {
      count += lesson.flashcards.where((f) => f.isLearned).length;
    }
    return count;
  }
  
  // Get average progress across all lessons
  double getAverageProgress() {
    if (_lessons.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    for (final lesson in _lessons.values) {
      totalProgress += lesson.progress;
    }
    
    return totalProgress / _lessons.length;
  }
}