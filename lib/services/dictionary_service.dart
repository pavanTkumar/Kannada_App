// lib/services/dictionary_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DictionaryService {
  static const String baseUrl = 'https://api.datamuse.com/words';
  static const String _progressKey = 'lesson_progress';

  // Get translation for a word
  Future<String> getTranslation(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?ml=$word&max=1'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0]['word'] as String;
        }
      }
      return word; // Return original word if translation fails
    } catch (e) {
      debugPrint('Translation error: $e');
      return word;
    }
  }

  // Save progress for a lesson
  Future<void> saveProgress(String lessonId, double progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressMap = await _getProgressMap();
      progressMap[lessonId] = progress;
      await prefs.setString(_progressKey, json.encode(progressMap));
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  // Get progress for a lesson
  Future<double> getProgress(String lessonId) async {
    try {
      final progressMap = await _getProgressMap();
      return progressMap[lessonId] ?? 0.0;
    } catch (e) {
      debugPrint('Error getting progress: $e');
      return 0.0;
    }
  }

  // Get all progress
  Future<Map<String, double>> getAllProgress() async {
    try {
      return await _getProgressMap();
    } catch (e) {
      debugPrint('Error getting all progress: $e');
      return {};
    }
  }

  Future<Map<String, double>> _getProgressMap() async {
    final prefs = await SharedPreferences.getInstance();
    final String? progressJson = prefs.getString(_progressKey);
    if (progressJson != null) {
      final Map<String, dynamic> decoded = json.decode(progressJson);
      return decoded.map((key, value) => MapEntry(key, value.toDouble()));
    }
    return {};
  }

  // Get lesson data
  Map<String, List<Map<String, dynamic>>> getLessonData() {
    return {
      'vowels': [
        {'kannada': 'ಅ', 'english': 'a'},
        {'kannada': 'ಆ', 'english': 'aa'},
        {'kannada': 'ಇ', 'english': 'i'},
        {'kannada': 'ಈ', 'english': 'ii'},
        {'kannada': 'ಉ', 'english': 'u'},
        {'kannada': 'ಊ', 'english': 'uu'},
        {'kannada': 'ಋ', 'english': 'ru'},
        {'kannada': 'ೠ', 'english': 'ruu'},
        {'kannada': 'ಎ', 'english': 'e'},
        {'kannada': 'ಏ', 'english': 'ee'},
        {'kannada': 'ಐ', 'english': 'ai'},
        {'kannada': 'ಒ', 'english': 'o'},
        {'kannada': 'ಓ', 'english': 'oo'},
        {'kannada': 'ಔ', 'english': 'au'},
      ],
      'consonants': [
        {'kannada': 'ಕ', 'english': 'ka'},
        {'kannada': 'ಖ', 'english': 'kha'},
        {'kannada': 'ಗ', 'english': 'ga'},
        {'kannada': 'ಘ', 'english': 'gha'},
        {'kannada': 'ಙ', 'english': 'nga'},
        {'kannada': 'ಚ', 'english': 'cha'},
        {'kannada': 'ಛ', 'english': 'chha'},
        {'kannada': 'ಜ', 'english': 'ja'},
        {'kannada': 'ಝ', 'english': 'jha'},
        {'kannada': 'ಞ', 'english': 'nya'},
        {'kannada': 'ಟ', 'english': 'ta'},
        {'kannada': 'ಠ', 'english': 'tha'},
        {'kannada': 'ಡ', 'english': 'da'},
        {'kannada': 'ಢ', 'english': 'dha'},
        {'kannada': 'ಣ', 'english': 'na'},
        {'kannada': 'ತ', 'english': 'ta'},
        {'kannada': 'ಥ', 'english': 'tha'},
        {'kannada': 'ದ', 'english': 'da'},
        {'kannada': 'ಧ', 'english': 'dha'},
        {'kannada': 'ನ', 'english': 'na'},
      ],
      'numbers': [
        {'kannada': '೧', 'english': '1 (One)'},
        {'kannada': '೨', 'english': '2 (Two)'},
        {'kannada': '೩', 'english': '3 (Three)'},
        {'kannada': '೪', 'english': '4 (Four)'},
        {'kannada': '೫', 'english': '5 (Five)'},
        {'kannada': '೬', 'english': '6 (Six)'},
        {'kannada': '೭', 'english': '7 (Seven)'},
        {'kannada': '೮', 'english': '8 (Eight)'},
        {'kannada': '೯', 'english': '9 (Nine)'},
        {'kannada': '೦', 'english': '0 (Zero)'},
        {'kannada': '೧೦', 'english': '10 (Ten)'},
        {'kannada': '೨೦', 'english': '20 (Twenty)'},
        {'kannada': '೫೦', 'english': '50 (Fifty)'},
        {'kannada': '೧೦೦', 'english': '100 (Hundred)'},
        {'kannada': '೧೦೦೦', 'english': '1000 (Thousand)'},
      ],
      'greetings': [
        {'kannada': 'ನಮಸ್ಕಾರ', 'english': 'Hello/Greetings'},
        {'kannada': 'ಶುಭ ದಿನ', 'english': 'Good day'},
        {'kannada': 'ಶುಭ ಬೆಳಗು', 'english': 'Good morning'},
        {'kannada': 'ಶುಭ ಸಂಜೆ', 'english': 'Good evening'},
        {'kannada': 'ಶುಭ ರಾತ್ರಿ', 'english': 'Good night'},
        {'kannada': 'ಹೇಗಿದ್ದೀರಿ?', 'english': 'How are you?'},
        {'kannada': 'ನಾನು ಚೆನ್ನಾಗಿದ್ದೇನೆ', 'english': 'I am fine'},
        {'kannada': 'ಧನ್ಯವಾದಗಳು', 'english': 'Thank you'},
        {'kannada': 'ಪರವಾಗಿಲ್ಲ', 'english': "You're welcome"},
        {'kannada': 'ಕ್ಷಮಿಸಿ', 'english': 'Sorry/Excuse me'},
      ],
      'daily_phrases': [
        {'kannada': 'ನನ್ನ ಹೆಸರು', 'english': 'My name is'},
        {'kannada': 'ನಿಮ್ಮ ಹೆಸರೇನು?', 'english': 'What is your name?'},
        {'kannada': 'ನನಗೆ ಕನ್ನಡ ಬರುವುದಿಲ್ಲ', 'english': 'I do not know Kannada'},
        {'kannada': 'ನಾನು ಕಲಿಯುತ್ತಿದ್ದೇನೆ', 'english': 'I am learning'},
        {'kannada': 'ದಯವಿಟ್ಟು ನಿಧಾನವಾಗಿ ಮಾತನಾಡಿ', 'english': 'Please speak slowly'},
        {'kannada': 'ನನಗೆ ಅರ್ಥವಾಗುತ್ತಿಲ್ಲ', 'english': 'I do not understand'},
        {'kannada': 'ಮತ್ತೊಮ್ಮೆ ಹೇಳಿ', 'english': 'Please say it again'},
        {'kannada': 'ಎಷ್ಟು?', 'english': 'How much?'},
        {'kannada': 'ಎಲ್ಲಿದೆ?', 'english': 'Where is it?'},
        {'kannada': 'ಸಹಾಯ ಮಾಡುವಿರಾ?', 'english': 'Can you help me?'},
      ],
      'food': [
        {'kannada': 'ಊಟ', 'english': 'Food/Meal'},
        {'kannada': 'ತಿಂಡಿ', 'english': 'Snack'},
        {'kannada': 'ನೀರು', 'english': 'Water'},
        {'kannada': 'ಹಾಲು', 'english': 'Milk'},
        {'kannada': 'ಕಾಫಿ', 'english': 'Coffee'},
        {'kannada': 'ಚಹಾ', 'english': 'Tea'},
        {'kannada': 'ಇಡ್ಲಿ', 'english': 'Idli'},
        {'kannada': 'ದೋಸೆ', 'english': 'Dosa'},
        {'kannada': 'ವಡೆ', 'english': 'Vada'},
        {'kannada': 'ಬಿಸಿಬೇಳೆಬಾತ್', 'english': 'Bisibelebath'},
        {'kannada': 'ಪುಲಾವ್', 'english': 'Pulao'},
        {'kannada': 'ಪಾಯಸ', 'english': 'Payasa (Sweet pudding)'},
      ],
    };
  }
}