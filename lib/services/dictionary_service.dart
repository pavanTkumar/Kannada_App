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

  // Get lesson data with translations
  Map<String, List<Map<String, dynamic>>> getLessonData() {
    return {
      'vowels': [
        {
          'kannada': 'ಅ', 
          'english': 'a',
          'translations': {
            'en': 'a',
            'hi': 'अ',
            'kn': 'ಅ',
            'te': 'అ'
          }
        },
        {
          'kannada': 'ಆ', 
          'english': 'aa',
          'translations': {
            'en': 'aa',
            'hi': 'आ',
            'kn': 'ಆ',
            'te': 'ఆ'
          }
        },
        {
          'kannada': 'ಇ', 
          'english': 'i',
          'translations': {
            'en': 'i',
            'hi': 'इ',
            'kn': 'ಇ',
            'te': 'ఇ'
          }
        },
        {
          'kannada': 'ಈ', 
          'english': 'ii',
          'translations': {
            'en': 'ii',
            'hi': 'ई',
            'kn': 'ಈ',
            'te': 'ఈ'
          }
        },
        {
          'kannada': 'ಉ', 
          'english': 'u',
          'translations': {
            'en': 'u',
            'hi': 'उ',
            'kn': 'ಉ',
            'te': 'ఉ'
          }
        },
        {
          'kannada': 'ಊ', 
          'english': 'uu',
          'translations': {
            'en': 'uu',
            'hi': 'ऊ',
            'kn': 'ಊ',
            'te': 'ఊ'
          }
        },
        {
          'kannada': 'ಋ', 
          'english': 'ru',
          'translations': {
            'en': 'ru',
            'hi': 'ऋ',
            'kn': 'ಋ',
            'te': 'ఋ'
          }
        },
        {
          'kannada': 'ೠ', 
          'english': 'ruu',
          'translations': {
            'en': 'ruu',
            'hi': 'ॠ',
            'kn': 'ೠ',
            'te': 'ౠ'
          }
        },
        {
          'kannada': 'ಎ', 
          'english': 'e',
          'translations': {
            'en': 'e',
            'hi': 'ए',
            'kn': 'ಎ',
            'te': 'ఎ'
          }
        },
        {
          'kannada': 'ಏ', 
          'english': 'ee',
          'translations': {
            'en': 'ee',
            'hi': 'ए',
            'kn': 'ಏ',
            'te': 'ఏ'
          }
        },
        {
          'kannada': 'ಐ', 
          'english': 'ai',
          'translations': {
            'en': 'ai',
            'hi': 'ऐ',
            'kn': 'ಐ',
            'te': 'ఐ'
          }
        },
        {
          'kannada': 'ಒ', 
          'english': 'o',
          'translations': {
            'en': 'o',
            'hi': 'ओ',
            'kn': 'ಒ',
            'te': 'ఒ'
          }
        },
        {
          'kannada': 'ಓ', 
          'english': 'oo',
          'translations': {
            'en': 'oo',
            'hi': 'ओ',
            'kn': 'ಓ',
            'te': 'ఓ'
          }
        },
        {
          'kannada': 'ಔ', 
          'english': 'au',
          'translations': {
            'en': 'au',
            'hi': 'औ',
            'kn': 'ಔ',
            'te': 'ఔ'
          }
        },
      ],
      'consonants': [
        {
          'kannada': 'ಕ', 
          'english': 'ka',
          'translations': {
            'en': 'ka',
            'hi': 'क',
            'kn': 'ಕ',
            'te': 'క'
          }
        },
        {
          'kannada': 'ಖ', 
          'english': 'kha',
          'translations': {
            'en': 'kha',
            'hi': 'ख',
            'kn': 'ಖ',
            'te': 'ఖ'
          }
        },
        {
          'kannada': 'ಗ', 
          'english': 'ga',
          'translations': {
            'en': 'ga',
            'hi': 'ग',
            'kn': 'ಗ',
            'te': 'గ'
          }
        },
        {
          'kannada': 'ಘ', 
          'english': 'gha',
          'translations': {
            'en': 'gha',
            'hi': 'घ',
            'kn': 'ಘ',
            'te': 'ఘ'
          }
        },
        {
          'kannada': 'ಙ', 
          'english': 'nga',
          'translations': {
            'en': 'nga',
            'hi': 'ङ',
            'kn': 'ಙ',
            'te': 'ఙ'
          }
        },
        {
          'kannada': 'ಚ', 
          'english': 'cha',
          'translations': {
            'en': 'cha',
            'hi': 'च',
            'kn': 'ಚ',
            'te': 'చ'
          }
        },
        {
          'kannada': 'ಛ', 
          'english': 'chha',
          'translations': {
            'en': 'chha',
            'hi': 'छ',
            'kn': 'ಛ',
            'te': 'ఛ'
          }
        },
        {
          'kannada': 'ಜ', 
          'english': 'ja',
          'translations': {
            'en': 'ja',
            'hi': 'ज',
            'kn': 'ಜ',
            'te': 'జ'
          }
        },
        {
          'kannada': 'ಝ', 
          'english': 'jha',
          'translations': {
            'en': 'jha',
            'hi': 'झ',
            'kn': 'ಝ',
            'te': 'ఝ'
          }
        },
        {
          'kannada': 'ಞ', 
          'english': 'nya',
          'translations': {
            'en': 'nya',
            'hi': 'ञ',
            'kn': 'ಞ',
            'te': 'ఞ'
          }
        },
        {
          'kannada': 'ಟ', 
          'english': 'ta',
          'translations': {
            'en': 'ta',
            'hi': 'ट',
            'kn': 'ಟ',
            'te': 'ట'
          }
        },
        {
          'kannada': 'ಠ', 
          'english': 'tha',
          'translations': {
            'en': 'tha',
            'hi': 'ठ',
            'kn': 'ಠ',
            'te': 'ఠ'
          }
        },
        {
          'kannada': 'ಡ', 
          'english': 'da',
          'translations': {
            'en': 'da',
            'hi': 'ड',
            'kn': 'ಡ',
            'te': 'డ'
          }
        },
        {
          'kannada': 'ಢ', 
          'english': 'dha',
          'translations': {
            'en': 'dha',
            'hi': 'ढ',
            'kn': 'ಢ',
            'te': 'ఢ'
          }
        },
        {
          'kannada': 'ಣ', 
          'english': 'na',
          'translations': {
            'en': 'na',
            'hi': 'ण',
            'kn': 'ಣ',
            'te': 'ణ'
          }
        },
        {
          'kannada': 'ತ', 
          'english': 'ta',
          'translations': {
            'en': 'ta',
            'hi': 'त',
            'kn': 'ತ',
            'te': 'త'
          }
        },
        {
          'kannada': 'ಥ', 
          'english': 'tha',
          'translations': {
            'en': 'tha',
            'hi': 'थ',
            'kn': 'ಥ',
            'te': 'థ'
          }
        },
        {
          'kannada': 'ದ', 
          'english': 'da',
          'translations': {
            'en': 'da',
            'hi': 'द',
            'kn': 'ದ',
            'te': 'ద'
          }
        },
        {
          'kannada': 'ಧ', 
          'english': 'dha',
          'translations': {
            'en': 'dha',
            'hi': 'ध',
            'kn': 'ಧ',
            'te': 'ధ'
          }
        },
        {
          'kannada': 'ನ', 
          'english': 'na',
          'translations': {
            'en': 'na',
            'hi': 'न',
            'kn': 'ನ',
            'te': 'న'
          }
        },
      ],
      'numbers': [
        {
          'kannada': '೧', 
          'english': '1 (One)',
          'translations': {
            'en': '1 (One)',
            'hi': '१ (एक)',
            'kn': '೧ (ಒಂದು)',
            'te': '౧ (ఒకటి)'
          }
        },
        {
          'kannada': '೨', 
          'english': '2 (Two)',
          'translations': {
            'en': '2 (Two)',
            'hi': '२ (दो)',
            'kn': '೨ (ಎರಡು)',
            'te': '౨ (రెండు)'
          }
        },
        {
          'kannada': '೩', 
          'english': '3 (Three)',
          'translations': {
            'en': '3 (Three)',
            'hi': '३ (तीन)',
            'kn': '೩ (ಮೂರು)',
            'te': '౩ (మూడు)'
          }
        },
        {
          'kannada': '೪', 
          'english': '4 (Four)',
          'translations': {
            'en': '4 (Four)',
            'hi': '४ (चार)',
            'kn': '೪ (ನಾಲ್ಕು)',
            'te': '౪ (నాలుగు)'
          }
        },
        {
          'kannada': '೫', 
          'english': '5 (Five)',
          'translations': {
            'en': '5 (Five)',
            'hi': '५ (पांच)',
            'kn': '೫ (ಐದು)',
            'te': '౫ (ఐదు)'
          }
        },
        {
          'kannada': '೬', 
          'english': '6 (Six)',
          'translations': {
            'en': '6 (Six)',
            'hi': '६ (छह)',
            'kn': '೬ (ಆರು)',
            'te': '౬ (ఆరు)'
          }
        },
        {
          'kannada': '೭', 
          'english': '7 (Seven)',
          'translations': {
            'en': '7 (Seven)',
            'hi': '७ (सात)',
            'kn': '೭ (ಏಳು)',
            'te': '౭ (ఏడు)'
          }
        },
        {
          'kannada': '೮', 
          'english': '8 (Eight)',
          'translations': {
            'en': '8 (Eight)',
            'hi': '८ (आठ)',
            'kn': '೮ (ಎಂಟು)',
            'te': '౮ (ఎనిమిది)'
          }
        },
        {
          'kannada': '೯', 
          'english': '9 (Nine)',
          'translations': {
            'en': '9 (Nine)',
            'hi': '९ (नौ)',
            'kn': '೯ (ಒಂಬತ್ತು)',
            'te': '౯ (తొమ్మిది)'
          }
        },
        {
          'kannada': '೦', 
          'english': '0 (Zero)',
          'translations': {
            'en': '0 (Zero)',
            'hi': '० (शून्य)',
            'kn': '೦ (ಸೊನ್ನೆ)',
            'te': '౦ (సున్న)'
          }
        },
        {
          'kannada': '೧೦', 
          'english': '10 (Ten)',
          'translations': {
            'en': '10 (Ten)',
            'hi': '१० (दस)',
            'kn': '೧೦ (ಹತ್ತು)',
            'te': '౧౦ (పది)'
          }
        },
        {
          'kannada': '೨೦', 
          'english': '20 (Twenty)',
          'translations': {
            'en': '20 (Twenty)',
            'hi': '२० (बीस)',
            'kn': '೨೦ (ಇಪ್ಪತ್ತು)',
            'te': '౨౦ (ఇరవై)'
          }
        },
        {
          'kannada': '೫೦', 
          'english': '50 (Fifty)',
          'translations': {
            'en': '50 (Fifty)',
            'hi': '५० (पचास)',
            'kn': '೫೦ (ಐವತ್ತು)',
            'te': '౫౦ (యాభై)'
          }
        },
        {
          'kannada': '೧೦೦', 
          'english': '100 (Hundred)',
          'translations': {
            'en': '100 (Hundred)',
            'hi': '१०० (सौ)',
            'kn': '೧೦೦ (ನೂರು)',
            'te': '౧౦౦ (వంద)'
          }
        },
        {
          'kannada': '೧೦೦೦', 
          'english': '1000 (Thousand)',
          'translations': {
            'en': '1000 (Thousand)',
            'hi': '१००० (हज़ार)',
            'kn': '೧೦೦೦ (ಸಾವಿರ)',
            'te': '౧౦౦౦ (వెయ్యి)'
          }
        },
      ],
      'greetings': [
        {
          'kannada': 'ನಮಸ್ಕಾರ', 
          'english': 'Hello/Greetings',
          'translations': {
            'en': 'Hello/Greetings',
            'hi': 'नमस्कार',
            'kn': 'ನಮಸ್ಕಾರ',
            'te': 'నమస్కారం'
          }
        },
        {
          'kannada': 'ಶುಭ ದಿನ', 
          'english': 'Good day',
          'translations': {
            'en': 'Good day',
            'hi': 'शुभ दिन',
            'kn': 'ಶುಭ ದಿನ',
            'te': 'శుభదినం'
          }
        },
        {
          'kannada': 'ಶುಭ ಬೆಳಗು', 
          'english': 'Good morning',
          'translations': {
            'en': 'Good morning',
            'hi': 'सुप्रभात',
            'kn': 'ಶುಭ ಬೆಳಗು',
            'te': 'శుభోదయం'
          }
        },
        {
          'kannada': 'ಶುಭ ಸಂಜೆ', 
          'english': 'Good evening',
          'translations': {
            'en': 'Good evening',
            'hi': 'शुभ संध्या',
            'kn': 'ಶುಭ ಸಂಜೆ',
            'te': 'శుభ సాయంత్రం'
          }
        },
        {
          'kannada': 'ಶುಭ ರಾತ್ರಿ', 
          'english': 'Good night',
          'translations': {
            'en': 'Good night',
            'hi': 'शुभ रात्रि',
            'kn': 'ಶುಭ ರಾತ್ರಿ',
            'te': 'శుభరాత్రి'
          }
        },
        {
          'kannada': 'ಹೇಗಿದ್ದೀರಿ?', 
          'english': 'How are you?',
          'translations': {
            'en': 'How are you?',
            'hi': 'आप कैसे हैं?',
            'kn': 'ಹೇಗಿದ್ದೀರಿ?',
            'te': 'మీరు ఎలా ఉన్నారు?'
          }
        },
        {
          'kannada': 'ನಾನು ಚೆನ್ನಾಗಿದ್ದೇನೆ', 
          'english': 'I am fine',
          'translations': {
            'en': 'I am fine',
            'hi': 'मैं ठीक हूँ',
            'kn': 'ನಾನು ಚೆನ್ನಾಗಿದ್ದೇನೆ',
            'te': 'నేను బాగున్నాను'
          }
        },
        {
          'kannada': 'ಧನ್ಯವಾದಗಳು', 
          'english': 'Thank you',
          'translations': {
            'en': 'Thank you',
            'hi': 'धन्यवाद',
            'kn': 'ಧನ್ಯವಾದಗಳು',
            'te': 'ధన్యవాదాలు'
          }
        },
        {
          'kannada': 'ಪರವಾಗಿಲ್ಲ', 
          'english': "You're welcome",
          'translations': {
            'en': "You're welcome",
            'hi': 'आपका स्वागत है',
            'kn': 'ಪರವಾಗಿಲ್ಲ',
            'te': 'స్వాగతం'
          }
        },
        {
          'kannada': 'ಕ್ಷಮಿಸಿ', 
          'english': 'Sorry/Excuse me',
          'translations': {
            'en': 'Sorry/Excuse me',
            'hi': 'क्षमा करें',
            'kn': 'ಕ್ಷಮಿಸಿ',
            'te': 'క్షమించండి'
          }
        },
      ],
      'daily_phrases': [
        {
          'kannada': 'ನನ್ನ ಹೆಸರು', 
          'english': 'My name is',
          'translations': {
            'en': 'My name is',
            'hi': 'मेरा नाम है',
            'kn': 'ನನ್ನ ಹೆಸರು',
            'te': 'నా పేరు'
          }
        },
        {
          'kannada': 'ನಿಮ್ಮ ಹೆಸರೇನು?', 
          'english': 'What is your name?',
          'translations': {
            'en': 'What is your name?',
            'hi': 'आपका नाम क्या है?',
            'kn': 'ನಿಮ್ಮ ಹೆಸರೇನು?',
            'te': 'మీ పేరు ఏమిటి?'
          }
        },
        {
          'kannada': 'ನನಗೆ ಕನ್ನಡ ಬರುವುದಿಲ್ಲ', 
          'english': 'I do not know Kannada',
          'translations': {
            'en': 'I do not know Kannada',
            'hi': 'मुझे कन्नड़ नहीं आती',
            'kn': 'ನನಗೆ ಕನ್ನಡ ಬರುವುದಿಲ್ಲ',
            'te': 'నాకు కన్నడ రాదు'
          }
        },
        {
          'kannada': 'ನಾನು ಕಲಿಯುತ್ತಿದ್ದೇನೆ', 
          'english': 'I am learning',
          'translations': {
            'en': 'I am learning',
            'hi': 'मैं सीख रहा हूँ',
            'kn': 'ನಾನು ಕಲಿಯುತ್ತಿದ್ದೇನೆ',
            'te': 'నేను నేర్చుకుంటున్నాను'
          }
        },
        {
          'kannada': 'ದಯವಿಟ್ಟು ನಿಧಾನವಾಗಿ ಮಾತನಾಡಿ', 
          'english': 'Please speak slowly',
          'translations': {
            'en': 'Please speak slowly',
            'hi': 'कृपया धीरे बोलें',
            'kn': 'ದಯವಿಟ್ಟು ನಿಧಾನವಾಗಿ ಮಾತನಾಡಿ',
            'te': 'దయచేసి నెమ్మదిగా మాట్లాడండి'
          }
        },
        {
          'kannada': 'ನನಗೆ ಅರ್ಥವಾಗುತ್ತಿಲ್ಲ', 
          'english': 'I do not understand',
          'translations': {
            'en': 'I do not understand',
            'hi': 'मुझे समझ नहीं आ रहा है',
            'kn': 'ನನಗೆ ಅರ್ಥವಾಗುತ್ತಿಲ್ಲ',
            'te': 'నాకు అర్థం కావడం లేదు'
          }
        },
        {
          'kannada': 'ಮತ್ತೊಮ್ಮೆ ಹೇಳಿ', 
          'english': 'Please say it again',
          'translations': {
            'en': 'Please say it again',
            'hi': 'कृपया फिर से कहें',
            'kn': 'ಮತ್ತೊಮ್ಮೆ ಹೇಳಿ',
            'te': 'దయచేసి మళ్ళీ చెప్పండి'
          }
        },
        {
          'kannada': 'ಎಷ್ಟು?', 
          'english': 'How much?',
          'translations': {
            'en': 'How much?',
            'hi': 'कितना?',
            'kn': 'ಎಷ್ಟು?',
            'te': 'ఎంత?'
          }
        },
        {
          'kannada': 'ಎಲ್ಲಿದೆ?', 
          'english': 'Where is it?',
          'translations': {
            'en': 'Where is it?',
            'hi': 'यह कहाँ है?',
            'kn': 'ಎಲ್ಲಿದೆ?',
            'te': 'ఎక్కడ ఉంది?'
          }
        },
        {
          'kannada': 'ಸಹಾಯ ಮಾಡುವಿರಾ?', 
          'english': 'Can you help me?',
          'translations': {
            'en': 'Can you help me?',
            'hi': 'क्या आप मेरी मदद कर सकते हैं?',
            'kn': 'ಸಹಾಯ ಮಾಡುವಿರಾ?',
            'te': 'మీరు నాకు సహాయం చేయగలరా?'
          }
        },
      ],
      'food': [
        {
          'kannada': 'ಊಟ', 
          'english': 'Food/Meal',
          'translations': {
            'en': 'Food/Meal',
            'hi': 'भोजन',
            'kn': 'ಊಟ',
            'te': 'ఆహారం'
          }
        },
        {
          'kannada': 'ತಿಂಡಿ', 
          'english': 'Snack',
          'translations': {
            'en': 'Snack',
            'hi': 'नाश्ता',
            'kn': 'ತಿಂಡಿ',
            'te': 'స్నాక్'
          }
        },
        {
          'kannada': 'ನೀರು', 
          'english': 'Water',
          'translations': {
            'en': 'Water',
            'hi': 'पानी',
            'kn': 'ನೀರು',
            'te': 'నీరు'
          }
        },
        {
          'kannada': 'ಹಾಲು', 
          'english': 'Milk',
          'translations': {
            'en': 'Milk',
            'hi': 'दूध',
            'kn': 'ಹಾಲು',
            'te': 'పాలు'
          }
        },
        {
          'kannada': 'ಕಾಫಿ', 
          'english': 'Coffee',
          'translations': {
            'en': 'Coffee',
            'hi': 'कॉफी',
            'kn': 'ಕಾಫಿ',
            'te': 'కాఫీ'
          }
        },
        {
          'kannada': 'ಚಹಾ', 
          'english': 'Tea',
          'translations': {
            'en': 'Tea',
            'hi': 'चाय',
            'kn': 'ಚಹಾ',
            'te': 'టీ'
          }
        },
        {
          'kannada': 'ಇಡ್ಲಿ', 
          'english': 'Idli',
          'translations': {
            'en': 'Idli',
            'hi': 'इडली',
            'kn': 'ಇಡ್ಲಿ',
            'te': 'ఇడ్లీ'
          }
        },
        {
          'kannada': 'ದೋಸೆ', 
          'english': 'Dosa',
          'translations': {
            'en': 'Dosa',
            'hi': 'डोसा',
            'kn': 'ದೋಸೆ',
            'te': 'దోశ'
          }
        },
        {
          'kannada': 'ವಡೆ', 
          'english': 'Vada',
          'translations': {
            'en': 'Vada',
            'hi': 'वड़ा',
            'kn': 'ವಡೆ',
            'te': 'వడ'
          }
        },
        {
          'kannada': 'ಬಿಸಿಬೇಳೆಬಾತ್', 
          'english': 'Bisibelebath',
          'translations': {
            'en': 'Bisibelebath',
            'hi': 'बिसिबेलेबाथ',
            'kn': 'ಬಿಸಿಬೇಳೆಬಾತ್',
            'te': 'బిసిబెలేబాత్'
          }
        },
        {
          'kannada': 'ಪುಲಾವ್', 
          'english': 'Pulao',
          'translations': {
            'en': 'Pulao',
            'hi': 'पुलाव',
            'kn': 'ಪುಲಾವ್',
            'te': 'పులావ్'
          }
        },
        {
          'kannada': 'ಪಾಯಸ', 
          'english': 'Payasa (Sweet pudding)',
          'translations': {
            'en': 'Payasa (Sweet pudding)',
            'hi': 'पायस (मीठा पुडिंग)',
            'kn': 'ಪಾಯಸ',
            'te': 'పాయసం (తీపి పుడ్డింగ్)'
          }
        },
      ],
    };
  }
}