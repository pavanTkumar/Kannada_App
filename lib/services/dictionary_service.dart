// lib/services/dictionary_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DictionaryService {
  static const String baseUrl = 'https://api.datamuse.com/words';
  static const String _progressKey = 'lesson_progress';
  static const String _lastSyncKey = 'last_sync_date';

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
      
      // Update last sync date
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
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
  
  // Get last sync date
  Future<DateTime?> getLastSyncDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString(_lastSyncKey);
      if (dateString != null) {
        return DateTime.parse(dateString);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting last sync date: $e');
      return null;
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

  // Get lesson data - comprehensive lists for all categories
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
        {'kannada': 'ಅಂ', 'english': 'am (anusvara)'},
        {'kannada': 'ಅಃ', 'english': 'ah (visarga)'},
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
        {'kannada': 'ಪ', 'english': 'pa'},
        {'kannada': 'ಫ', 'english': 'pha'},
        {'kannada': 'ಬ', 'english': 'ba'},
        {'kannada': 'ಭ', 'english': 'bha'},
        {'kannada': 'ಮ', 'english': 'ma'},
        {'kannada': 'ಯ', 'english': 'ya'},
        {'kannada': 'ರ', 'english': 'ra'},
        {'kannada': 'ಲ', 'english': 'la'},
        {'kannada': 'ವ', 'english': 'va'},
        {'kannada': 'ಶ', 'english': 'sha'},
        {'kannada': 'ಷ', 'english': 'sha'},
        {'kannada': 'ಸ', 'english': 'sa'},
        {'kannada': 'ಹ', 'english': 'ha'},
        {'kannada': 'ಳ', 'english': 'La'},
      ],
      'numbers': [
        {'kannada': '೦', 'english': '0 (Zero)'},
        {'kannada': '೧', 'english': '1 (One)'},
        {'kannada': '೨', 'english': '2 (Two)'},
        {'kannada': '೩', 'english': '3 (Three)'},
        {'kannada': '೪', 'english': '4 (Four)'},
        {'kannada': '೫', 'english': '5 (Five)'},
        {'kannada': '೬', 'english': '6 (Six)'},
        {'kannada': '೭', 'english': '7 (Seven)'},
        {'kannada': '೮', 'english': '8 (Eight)'},
        {'kannada': '೯', 'english': '9 (Nine)'},
        {'kannada': '೧೦', 'english': '10 (Ten)'},
        {'kannada': '೨೦', 'english': '20 (Twenty)'},
        {'kannada': '೫೦', 'english': '50 (Fifty)'},
        {'kannada': '೧೦೦', 'english': '100 (Hundred)'},
        {'kannada': '೧೦೦೦', 'english': '1000 (Thousand)'},
        {'kannada': 'ಒಂದು', 'english': 'One (word form)'},
        {'kannada': 'ಎರಡು', 'english': 'Two (word form)'},
        {'kannada': 'ಮೂರು', 'english': 'Three (word form)'},
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
        {'kannada': 'ಹೌದು', 'english': 'Yes'},
        {'kannada': 'ಇಲ್ಲ', 'english': 'No'},
        {'kannada': 'ದಯವಿಟ್ಟು', 'english': 'Please'},
        {'kannada': 'ಮತ್ತೆ ಸಿಗೋಣ', 'english': 'See you again'},
        {'kannada': 'ಶುಭವಾಗಲಿ', 'english': 'Best wishes'},
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
        {'kannada': 'ನನಗೆ ನೀರು ಬೇಕು', 'english': 'I need water'},
        {'kannada': 'ನನಗೆ ಹಸಿವಾಗಿದೆ', 'english': 'I am hungry'},
        {'kannada': 'ಎಲ್ಲಿಗೆ ಹೋಗುತ್ತಿದ್ದೀರಿ?', 'english': 'Where are you going?'},
        {'kannada': 'ನಾನು ಇಲ್ಲಿ ಹೊಸಬ', 'english': 'I am new here'},
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
        {'kannada': 'ಚಿತ್ರಾನ್ನ', 'english': 'Chitranna (Lemon Rice)'},
        {'kannada': 'ರಾಗಿ ಮುದ್ದೆ', 'english': 'Ragi Mudde'},
        {'kannada': 'ಹುಲಿ ಅನ್ನ', 'english': 'Sambar Rice'},
        {'kannada': 'ಮೆನಸಿನಕಾಯಿ ಬಜ್ಜಿ', 'english': 'Chili Bajji'},
        {'kannada': 'ತುಪ್ಪ', 'english': 'Ghee'},
        {'kannada': 'ಸಿಹಿ', 'english': 'Sweet'},
        {'kannada': 'ಖಾರ', 'english': 'Spicy'},
        {'kannada': 'ಹುಳಿ', 'english': 'Sour'},
      ],
      'travel': [
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
        {'kannada': 'ವಿಮಾನ ನಿಲ್ದಾಣ', 'english': 'Airport'},
        {'kannada': 'ಟಾಕ್ಸಿ/ಆಟೋ', 'english': 'Taxi/Auto-rickshaw'},
        {'kannada': 'ಎಡಕ್ಕೆ ತಿರುಗಿ', 'english': 'Turn left'},
        {'kannada': 'ಬಲಕ್ಕೆ ತಿರುಗಿ', 'english': 'Turn right'},
        {'kannada': 'ನೇರವಾಗಿ ಹೋಗಿ', 'english': 'Go straight'},
      ],
      'shopping': [
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
        {'kannada': 'ಖರೀದಿಸು', 'english': 'Buy'},
        {'kannada': 'ಮಾರಾಟ', 'english': 'Sale'},
        {'kannada': 'ಬಟ್ಟೆ ಅಂಗಡಿ', 'english': 'Clothing store'},
        {'kannada': 'ಕಿರಾಣಿ ಅಂಗಡಿ', 'english': 'Grocery store'},
        {'kannada': 'ಮಾಲ್', 'english': 'Mall'},
      ],
      'emotions': [
        {'kannada': 'ಸಂತೋಷ', 'english': 'Happiness'},
        {'kannada': 'ದುಃಖ', 'english': 'Sadness'},
        {'kannada': 'ಕೋಪ', 'english': 'Anger'},
        {'kannada': 'ಭಯ', 'english': 'Fear'},
        {'kannada': 'ಆಶ್ಚರ್ಯ', 'english': 'Surprise'},
        {'kannada': 'ಪ್ರೀತಿ', 'english': 'Love'},
        {'kannada': 'ನಗು', 'english': 'Laughter'},
        {'kannada': 'ಕಣ್ಣೀರು', 'english': 'Tears'},
        {'kannada': 'ನೋವು', 'english': 'Pain'},
        {'kannada': 'ಆನಂದ', 'english': 'Joy'},
        {'kannada': 'ಭಯಗ್ರಸ್ತ', 'english': 'Scared'},
        {'kannada': 'ಚಿಂತೆ', 'english': 'Worry'},
      ],
      'time': [
        {'kannada': 'ಸಮಯ', 'english': 'Time'},
        {'kannada': 'ಗಂಟೆ', 'english': 'Hour'},
        {'kannada': 'ನಿಮಿಷ', 'english': 'Minute'},
        {'kannada': 'ಸೆಕೆಂಡ್', 'english': 'Second'},
        {'kannada': 'ಇವತ್ತು', 'english': 'Today'},
        {'kannada': 'ನಾಳೆ', 'english': 'Tomorrow'},
        {'kannada': 'ನಿನ್ನೆ', 'english': 'Yesterday'},
        {'kannada': 'ವಾರ', 'english': 'Week'},
        {'kannada': 'ತಿಂಗಳು', 'english': 'Month'},
        {'kannada': 'ವರ್ಷ', 'english': 'Year'},
        {'kannada': 'ಬೆಳಗ್ಗೆ', 'english': 'Morning'},
        {'kannada': 'ಮಧ್ಯಾಹ್ನ', 'english': 'Afternoon'},
        {'kannada': 'ಸಂಜೆ', 'english': 'Evening'},
        {'kannada': 'ರಾತ್ರಿ', 'english': 'Night'},
      ]
    };
  }
}