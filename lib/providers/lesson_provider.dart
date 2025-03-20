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
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  Map<String, Lesson> get lessons => _lessons;

  Future<void> initializeLessons() async {
    if (_isInitialized || _isLoading) return;
    
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
        // Adding two new lessons - Fixed type error with proper casting
        'travel': Lesson(
          id: 'travel',
          title: 'Travel Phrases',
          kannadaTitle: 'ಪ್ರಯಾಣದ ವಾಕ್ಯಗಳು',
          description: 'Essential phrases for traveling in Karnataka',
          flashcards: (lessonData['travel'] ?? [
            {'kannada': 'ಬಸ್ ನಿಲ್ದಾಣ ಎಲ್ಲಿದೆ?', 'english': 'Where is the bus station?'},
            {'kannada': 'ರೈಲು ನಿಲ್ದಾಣಕ್ಕೆ ಹೋಗುವ ದಾರಿ', 'english': 'Way to the railway station'},
            {'kannada': 'ಎಷ್ಟು ದೂರ?', 'english': 'How far is it?'},
            {'kannada': 'ಟಿಕೆಟ್ ಎಷ್ಟು?', 'english': 'How much is the ticket?'},
            {'kannada': 'ಮುಂದಿನ ಬಸ್ ಯಾವಾಗ?', 'english': 'When is the next bus?'},
            {'kannada': 'ಹೋಟೆಲ್ ನಿಲ್ದಾಣ', 'english': 'Hotel accommodation'},
            {'kannada': 'ಇದು ಎಷ್ಟು?', 'english': 'How much is this?'},
            {'kannada': 'ನನಗೆ ಸಹಾಯ ಮಾಡುವಿರಾ?', 'english': 'Can you help me?'},
            {'kannada': 'ಇದು ಎಲ್ಲಿದೆ?', 'english': 'Where is this place?'},
            {'kannada': 'ತುರ್ತು ಸಹಾಯ', 'english': 'Emergency help'},
          ])
              .map<Flashcard>((data) => Flashcard.fromMap(data as Map<String, dynamic>))
              .toList(),
          progress: progress['travel'] ?? 0.0,
        ),
        'shopping': Lesson(
          id: 'shopping',
          title: 'Shopping Terms',
          kannadaTitle: 'ಶಾಪಿಂಗ್ ಪದಗಳು',
          description: 'Learn useful words for shopping in Kannada',
          flashcards: (lessonData['shopping'] ?? [
            {'kannada': 'ಬೆಲೆ', 'english': 'Price'},
            {'kannada': 'ಅಂಗಡಿ', 'english': 'Shop'},
            {'kannada': 'ಮಾರುಕಟ್ಟೆ', 'english': 'Market'},
            {'kannada': 'ಹಣ', 'english': 'Money'},
            {'kannada': 'ರಶೀದಿ', 'english': 'Receipt'},
            {'kannada': 'ಕಡಿಮೆ ಬೆಲೆ', 'english': 'Discount'},
            {'kannada': 'ದುಬಾರಿ', 'english': 'Expensive'},
            {'kannada': 'ಅಗ್ಗ', 'english': 'Cheap'},
            {'kannada': 'ನಾಣ್ಯಗಳು', 'english': 'Coins'},
            {'kannada': 'ನೋಟುಗಳು', 'english': 'Notes/Bills'},
          ])
              .map<Flashcard>((data) => Flashcard.fromMap(data as Map<String, dynamic>))
              .toList(),
          progress: progress['shopping'] ?? 0.0,
        ),
      };
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing lessons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProgress() async {
    if (!_isInitialized) {
      await initializeLessons();
      return;
    }
    
    try {
      final progress = await _dictionaryService.getAllProgress();
      
      // Update progress for each lesson
      for (final lessonId in _lessons.keys) {
        if (progress.containsKey(lessonId)) {
          _lessons[lessonId]!.progress = progress[lessonId]!;
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing lesson progress: $e');
    }
  }

  Future<void> markFlashcardAsLearned(String lessonId, int flashcardIndex) async {
    if (!_lessons.containsKey(lessonId)) return;

    final lesson = _lessons[lessonId]!;
    if (flashcardIndex >= lesson.flashcards.length) return;

    // Check if already learned
    if (!lesson.flashcards[flashcardIndex].isLearned) {
      lesson.flashcards[flashcardIndex].isLearned = true;
      
      // Increment user's learned flashcards count
      final context = navigatorKey.currentContext;
      if (context != null) {
        Provider.of<UserProvider>(context, listen: false)
            .updateFlashcardsLearned(1);
      }
    }
    
    lesson.progress = lesson.flashcards
            .where((flashcard) => flashcard.isLearned)
            .length /
        lesson.flashcards.length *
        100;

    await _dictionaryService.saveProgress(lessonId, lesson.progress);
    notifyListeners();
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