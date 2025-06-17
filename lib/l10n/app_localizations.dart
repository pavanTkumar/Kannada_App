// lib/l10n/app_localizations.dart
import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('te'),
  ];

  // App strings
  String get appName;
  String get appSubtitle;
  String get home;
  String get progress;
  String get test;
  String get profile;
  String get welcomeTitle;
  String get welcomeSubtitle;
  String get whatShouldWeCallYou;
  String get personalizeExperience;
  String get yourName;
  String get nameHint;
  String get nameValidation;
  String get nameMinLength;
  String get choosePreferredLanguage;
  String get translationsInLanguage;
  String almostThere(String name);
  String get reviewPreferences;
  String get name;
  String get language;
  String get darkMode;
  String get enableDarkTheme;
  String get changeSettingsAnytime;
  String get getStarted;
  String get next;
  String get back;
  String get previous;
  String get kannadaBasics;
  String get practicalPhrases;
  String get yourLearningProgress;
  String get keepGoingGreat;
  String get cardsLearned;
  String get avgProgress;
  String get quizzesDone;
  String get yourProgress;
  String get testYourKnowledge;
  String get quizzesToTestProgress;
  String get notStarted;
  String scorePercent(int score);
  String get questions;
  String get learningStatistics;
  String get flashcardsLearned;
  String get quizzesCompleted;
  String get averageQuizScore;
  String get achievements;
  String get noAchievementsYet;
  String get keepLearningEarnAchievements;
  String get personalInformation;
  String get preferredLanguage;
  String get appInformation;
  String get version;
  String get on;
  String get off;
  String dayStreak(int days);
  String get vowels;
  String get consonants;
  String get numbers;
  String get greetings;
  String get dailyPhrases;
  String get foodDrinks;
  String get vowelsKannada;
  String get consonantsKannada;
  String get numbersKannada;
  String get greetingsKannada;
  String get dailyPhrasesKannada;
  String get foodDrinksKannada;
  String get vowelsDescription;
  String get consonantsDescription;
  String get numbersDescription;
  String get greetingsDescription;
  String get dailyPhrasesDescription;
  String get foodDrinksDescription;
  String get complete;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'kn', 'te'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'hi':
        return AppLocalizationsHi();
      case 'kn':
        return AppLocalizationsKn();
      case 'te':
        return AppLocalizationsTe();
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

// English Implementation
class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appName => 'Learn Kannada';
  @override
  String get appSubtitle => 'ಕನ್ನಡ ಕಲಿ';
  @override
  String get home => 'Home';
  @override
  String get progress => 'Progress';
  @override
  String get test => 'Test';
  @override
  String get profile => 'Profile';
  @override
  String get welcomeTitle => 'Welcome to Learn Kannada!';
  @override
  String get welcomeSubtitle => 'Let\'s set up your learning profile';
  @override
  String get whatShouldWeCallYou => 'What should we call you?';
  @override
  String get personalizeExperience => 'We\'ll use this to personalize your experience';
  @override
  String get yourName => 'Your Name';
  @override
  String get nameHint => 'E.g., John, Ravi, Priya...';
  @override
  String get nameValidation => 'Please enter your name';
  @override
  String get nameMinLength => 'Name must be at least 2 characters';
  @override
  String get choosePreferredLanguage => 'Choose your preferred language';
  @override
  String get translationsInLanguage => 'We\'ll show translations in this language';
  @override
  String almostThere(String name) => 'Almost there, $name!';
  @override
  String get reviewPreferences => 'Review your preferences and start learning';
  @override
  String get name => 'Name';
  @override
  String get language => 'Language';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get enableDarkTheme => 'Enable dark theme';
  @override
  String get changeSettingsAnytime => 'You can change these settings anytime from your profile';
  @override
  String get getStarted => 'Get Started';
  @override
  String get next => 'Next';
  @override
  String get back => 'Back';
  @override
  String get previous => 'Previous';
  @override
  String get kannadaBasics => 'Kannada Basics';
  @override
  String get practicalPhrases => 'Practical Phrases';
  @override
  String get yourLearningProgress => 'Your Learning Progress';
  @override
  String get keepGoingGreat => 'Keep going! You\'re doing great';
  @override
  String get cardsLearned => 'Cards Learned';
  @override
  String get avgProgress => 'Avg. Progress';
  @override
  String get quizzesDone => 'Quizzes Done';
  @override
  String get yourProgress => 'Your Progress';
  @override
  String get testYourKnowledge => 'Test Your Knowledge';
  @override
  String get quizzesToTestProgress => 'Take quizzes to test your Kannada learning progress';
  @override
  String get notStarted => 'Not started';
  @override
  String scorePercent(int score) => '$score% Score';
  @override
  String get questions => 'questions';
  @override
  String get learningStatistics => 'Learning Statistics';
  @override
  String get flashcardsLearned => 'Flashcards Learned';
  @override
  String get quizzesCompleted => 'Quizzes Completed';
  @override
  String get averageQuizScore => 'Average Quiz Score';
  @override
  String get achievements => 'Achievements';
  @override
  String get noAchievementsYet => 'No achievements yet';
  @override
  String get keepLearningEarnAchievements => 'Keep learning to earn achievements!';
  @override
  String get personalInformation => 'Personal Information';
  @override
  String get preferredLanguage => 'Preferred Language';
  @override
  String get appInformation => 'App Information';
  @override
  String get version => 'Version';
  @override
  String get on => 'On';
  @override
  String get off => 'Off';
  @override
  String dayStreak(int days) => '$days Day Streak';
  @override
  String get vowels => 'Vowels';
  @override
  String get consonants => 'Consonants';
  @override
  String get numbers => 'Numbers';
  @override
  String get greetings => 'Greetings';
  @override
  String get dailyPhrases => 'Daily Phrases';
  @override
  String get foodDrinks => 'Food & Drinks';
  @override
  String get vowelsKannada => 'ಸ್ವರಗಳು';
  @override
  String get consonantsKannada => 'ವ್ಯಂಜನಗಳು';
  @override
  String get numbersKannada => 'ಅಂಕಿಗಳು';
  @override
  String get greetingsKannada => 'ಶುಭಾಶಯಗಳು';
  @override
  String get dailyPhrasesKannada => 'ದೈನಂದಿನ ವಾಕ್ಯಗಳು';
  @override
  String get foodDrinksKannada => 'ಆಹಾರ & ಪಾನೀಯಗಳು';
  @override
  String get vowelsDescription => 'Learn the basic vowels in Kannada alphabet';
  @override
  String get consonantsDescription => 'Master the basic consonants in Kannada';
  @override
  String get numbersDescription => 'Learn counting in Kannada';
  @override
  String get greetingsDescription => 'Common greetings and expressions';
  @override
  String get dailyPhrasesDescription => 'Essential phrases for everyday conversations';
  @override
  String get foodDrinksDescription => 'Learn about food and drinks in Kannada';
  @override
  String get complete => 'Complete';
}

// Hindi Implementation
class AppLocalizationsHi extends AppLocalizations {
  @override
  String get appName => 'कन्नड़ सीखें';
  @override
  String get appSubtitle => 'ಕನ್ನಡ ಕಲಿ';
  @override
  String get home => 'होम';
  @override
  String get progress => 'प्रगति';
  @override
  String get test => 'परीक्षा';
  @override
  String get profile => 'प्रोफ़ाइल';
  @override
  String get welcomeTitle => 'कन्नड़ सीखने में आपका स्वागत है!';
  @override
  String get welcomeSubtitle => 'आइए अपनी सीखने की प्रोफ़ाइल सेट करें';
  @override
  String get whatShouldWeCallYou => 'हमें आपको क्या कहना चाहिए?';
  @override
  String get personalizeExperience => 'हम इसका उपयोग आपके अनुभव को व्यक्तिगत बनाने के लिए करेंगे';
  @override
  String get yourName => 'आपका नाम';
  @override
  String get nameHint => 'जैसे: राम, सीता, अमित...';
  @override
  String get nameValidation => 'कृपया अपना नाम दर्ज करें';
  @override
  String get nameMinLength => 'नाम कम से कम 2 अक्षर का होना चाहिए';
  @override
  String get choosePreferredLanguage => 'अपनी पसंदीदा भाषा चुनें';
  @override
  String get translationsInLanguage => 'हम इस भाषा में अनुवाद दिखाएंगे';
  @override
  String almostThere(String name) => 'लगभग पूरा हो गया, $name!';
  @override
  String get reviewPreferences => 'अपनी प्राथमिकताओं की समीक्षा करें और सीखना शुरू करें';
  @override
  String get name => 'नाम';
  @override
  String get language => 'भाषा';
  @override
  String get darkMode => 'डार्क मोड';
  @override
  String get enableDarkTheme => 'डार्क थीम सक्षम करें';
  @override
  String get changeSettingsAnytime => 'आप इन सेटिंग्स को अपनी प्रोफ़ाइल से कभी भी बदल सकते हैं';
  @override
  String get getStarted => 'शुरू करें';
  @override
  String get next => 'अगला';
  @override
  String get back => 'वापस';
  @override
  String get previous => 'पिछला';
  @override
  String get kannadaBasics => 'कन्नड़ मूल बातें';
  @override
  String get practicalPhrases => 'व्यावहारिक वाक्य';
  @override
  String get yourLearningProgress => 'आपकी सीखने की प्रगति';
  @override
  String get keepGoingGreat => 'जारी रखें! आप बहुत अच्छा कर रहे हैं';
  @override
  String get cardsLearned => 'कार्ड सीखे गए';
  @override
  String get avgProgress => 'औसत प्रगति';
  @override
  String get quizzesDone => 'क्विज़ पूरे किए';
  @override
  String get yourProgress => 'आपकी प्रगति';
  @override
  String get testYourKnowledge => 'अपने ज्ञान का परीक्षण करें';
  @override
  String get quizzesToTestProgress => 'अपनी कन्नड़ सीखने की प्रगति का परीक्षण करने के लिए क्विज़ लें';
  @override
  String get notStarted => 'शुरू नहीं हुआ';
  @override
  String scorePercent(int score) => '$score% स्कोर';
  @override
  String get questions => 'प्रश्न';
  @override
  String get learningStatistics => 'सीखने के आंकड़े';
  @override
  String get flashcardsLearned => 'फ्लैशकार्ड सीखे गए';
  @override
  String get quizzesCompleted => 'क्विज़ पूर्ण किए गए';
  @override
  String get averageQuizScore => 'औसत क्विज़ स्कोर';
  @override
  String get achievements => 'उपलब्धियां';
  @override
  String get noAchievementsYet => 'अभी तक कोई उपलब्धि नहीं';
  @override
  String get keepLearningEarnAchievements => 'उपलब्धियां अर्जित करने के लिए सीखते रहें!';
  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';
  @override
  String get preferredLanguage => 'पसंदीदा भाषा';
  @override
  String get appInformation => 'ऐप जानकारी';
  @override
  String get version => 'संस्करण';
  @override
  String get on => 'चालू';
  @override
  String get off => 'बंद';
  @override
  String dayStreak(int days) => '$days दिन की लकीर';
  @override
  String get vowels => 'स्वर';
  @override
  String get consonants => 'व्यंजन';
  @override
  String get numbers => 'संख्याएं';
  @override
  String get greetings => 'अभिवादन';
  @override
  String get dailyPhrases => 'दैनिक वाक्य';
  @override
  String get foodDrinks => 'भोजन और पेय';
  @override
  String get vowelsKannada => 'ಸ್ವರಗಳು';
  @override
  String get consonantsKannada => 'ವ್ಯಂಜನಗಳು';
  @override
  String get numbersKannada => 'ಅಂಕಿಗಳು';
  @override
  String get greetingsKannada => 'ಶುಭಾಶಯಗಳು';
  @override
  String get dailyPhrasesKannada => 'ದೈನಂದಿನ ವಾಕ್ಯಗಳು';
  @override
  String get foodDrinksKannada => 'ಆಹಾರ & ಪಾನೀಯಗಳು';
  @override
  String get vowelsDescription => 'कन्नड़ वर्णमाला में मूल स्वर सीखें';
  @override
  String get consonantsDescription => 'कन्नड़ में मूल व्यंजन में महारत हासिल करें';
  @override
  String get numbersDescription => 'कन्नड़ में गिनती सीखें';
  @override
  String get greetingsDescription => 'सामान्य अभिवादन और अभिव्यक्तियां';
  @override
  String get dailyPhrasesDescription => 'रोजमर्रा की बातचीत के लिए आवश्यक वाक्य';
  @override
  String get foodDrinksDescription => 'कन्नड़ में भोजन और पेय के बारे में सीखें';
  @override
  String get complete => 'पूर्ण';
}

// Kannada Implementation
class AppLocalizationsKn extends AppLocalizations {
  @override
  String get appName => 'ಕನ್ನಡ ಕಲಿ';
  @override
  String get appSubtitle => 'ಕನ್ನಡ ಕಲಿ';
  @override
  String get home => 'ಮುಖ್ಯ';
  @override
  String get progress => 'ಪ್ರಗತಿ';
  @override
  String get test => 'ಪರೀಕ್ಷೆ';
  @override
  String get profile => 'ಪ್ರೊಫೈಲ್';
  @override
  String get welcomeTitle => 'ಕನ್ನಡ ಕಲಿಕೆಗೆ ಸ್ವಾಗತ!';
  @override
  String get welcomeSubtitle => 'ನಿಮ್ಮ ಕಲಿಕೆಯ ಪ್ರೊಫೈಲ್ ಅನ್ನು ಹೊಂದಿಸೋಣ';
  @override
  String get whatShouldWeCallYou => 'ನಾವು ನಿಮ್ಮನ್ನು ಏನು ಎಂದು ಕರೆಯಬೇಕು?';
  @override
  String get personalizeExperience => 'ನಿಮ್ಮ ಅನುಭವವನ್ನು ವೈಯಕ್ತಿಕಗೊಳಿಸಲು ನಾವು ಇದನ್ನು ಬಳಸುತ್ತೇವೆ';
  @override
  String get yourName => 'ನಿಮ್ಮ ಹೆಸರು';
  @override
  String get nameHint => 'ಉದಾ: ರಾಮ, ಸೀತಾ, ಅಮಿತ್...';
  @override
  String get nameValidation => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹೆಸರನ್ನು ನಮೂದಿಸಿ';
  @override
  String get nameMinLength => 'ಹೆಸರು ಕನಿಷ್ಠ 2 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು';
  @override
  String get choosePreferredLanguage => 'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆ ಮಾಡಿ';
  @override
  String get translationsInLanguage => 'ನಾವು ಈ ಭಾಷೆಯಲ್ಲಿ ಅನುವಾದಗಳನ್ನು ತೋರಿಸುತ್ತೇವೆ';
  @override
  String almostThere(String name) => 'ಸುಮಾರು ಮುಗಿಯಿತು, $name!';
  @override
  String get reviewPreferences => 'ನಿಮ್ಮ ಆದ್ಯತೆಗಳನ್ನು ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಕಲಿಕೆಯನ್ನು ಪ್ರಾರಂಭಿಸಿ';
  @override
  String get name => 'ಹೆಸರು';
  @override
  String get language => 'ಭಾಷೆ';
  @override
  String get darkMode => 'ಡಾರ್ಕ್ ಮೋಡ್';
  @override
  String get enableDarkTheme => 'ಡಾರ್ಕ್ ಥೀಮ್ ಸಕ್ರಿಯಗೊಳಿಸಿ';
  @override
  String get changeSettingsAnytime => 'ನೀವು ಈ ಸೆಟ್ಟಿಂಗ್ಗಳನ್ನು ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ನಿಂದ ಯಾವಾಗ ಬೇಕಾದರೂ ಬದಲಾಯಿಸಬಹುದು';
  @override
  String get getStarted => 'ಪ್ರಾರಂಭಿಸಿ';
  @override
  String get next => 'ಮುಂದೆ';
  @override
  String get back => 'ಹಿಂದೆ';
  @override
  String get previous => 'ಹಿಂದಿನ';
  @override
  String get kannadaBasics => 'ಕನ್ನಡ ಮೂಲತತ್ವಗಳು';
  @override
  String get practicalPhrases => 'ಪ್ರಾಯೋಗಿಕ ವಾಕ್ಯಗಳು';
  @override
  String get yourLearningProgress => 'ನಿಮ್ಮ ಕಲಿಕೆಯ ಪ್ರಗತಿ';
  @override
  String get keepGoingGreat => 'ಮುಂದುವರಿಸಿ! ನೀವು ಚೆನ್ನಾಗಿ ಮಾಡುತ್ತಿದ್ದೀರಿ';
  @override
  String get cardsLearned => 'ಕಾರ್ಡ್ಗಳು ಕಲಿತು';
  @override
  String get avgProgress => 'ಸರಾಸರಿ ಪ್ರಗತಿ';
  @override
  String get quizzesDone => 'ಪ್ರಶ್ನೋತ್ತರಗಳು ಪೂರ್ಣ';
  @override
  String get yourProgress => 'ನಿಮ್ಮ ಪ್ರಗತಿ';
  @override
  String get testYourKnowledge => 'ನಿಮ್ಮ ಜ್ಞಾನವನ್ನು ಪರೀಕ್ಷಿಸಿ';
  @override
  String get quizzesToTestProgress => 'ನಿಮ್ಮ ಕನ್ನಡ ಕಲಿಕೆಯ ಪ್ರಗತಿಯನ್ನು ಪರೀಕ್ಷಿಸಲು ಪ್ರಶ್ನೋತ್ತರಗಳನ್ನು ತೆಗೆದುಕೊಳ್ಳಿ';
  @override
  String get notStarted => 'ಪ್ರಾರಂಭವಾಗಿಲ್ಲ';
  @override
  String scorePercent(int score) => '$score% ಅಂಕ';
  @override
  String get questions => 'ಪ್ರಶ್ನೆಗಳು';
  @override
  String get learningStatistics => 'ಕಲಿಕೆಯ ಅಂಕಿಅಂಶಗಳು';
  @override
  String get flashcardsLearned => 'ಫ್ಲಾಶ್ಕಾರ್ಡ್ಗಳು ಕಲಿತು';
  @override
  String get quizzesCompleted => 'ಪ್ರಶ್ನೋತ್ತರಗಳು ಪೂರ್ಣಗೊಂಡಿವೆ';
  @override
  String get averageQuizScore => 'ಸರಾಸರಿ ಪ್ರಶ್ನೋತ್ತರ ಅಂಕ';
  @override
  String get achievements => 'ಸಾಧನೆಗಳು';
  @override
  String get noAchievementsYet => 'ಇನ್ನೂ ಯಾವುದೇ ಸಾಧನೆಗಳಿಲ್ಲ';
  @override
  String get keepLearningEarnAchievements => 'ಸಾಧನೆಗಳನ್ನು ಗಳಿಸಲು ಕಲಿಯುತ್ತಲೇ ಇರಿ!';
  @override
  String get personalInformation => 'ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ';
  @override
  String get preferredLanguage => 'ಆದ್ಯತೆಯ ಭಾಷೆ';
  @override
  String get appInformation => 'ಅಪ್ಲಿಕೇಶನ್ ಮಾಹಿತಿ';
  @override
  String get version => 'ಆವೃತ್ತಿ';
  @override
  String get on => 'ಆನ್';
  @override
  String get off => 'ಆಫ್';
  @override
  String dayStreak(int days) => '$days ದಿನಗಳ ಸರಣಿ';
  @override
  String get vowels => 'ಸ್ವರಗಳು';
  @override
  String get consonants => 'ವ್ಯಂಜನಗಳು';
  @override
  String get numbers => 'ಸಂಖ್ಯೆಗಳು';
  @override
  String get greetings => 'ಶುಭಾಶಯಗಳು';
  @override
  String get dailyPhrases => 'ದೈನಂದಿನ ವಾಕ್ಯಗಳು';
  @override
  String get foodDrinks => 'ಆಹಾರ ಮತ್ತು ಪಾನೀಯಗಳು';
  @override
  String get vowelsKannada => 'ಸ್ವರಗಳು';
  @override
  String get consonantsKannada => 'ವ್ಯಂಜನಗಳು';
  @override
  String get numbersKannada => 'ಅಂಕಿಗಳು';
  @override
  String get greetingsKannada => 'ಶುಭಾಶಯಗಳು';
  @override
  String get dailyPhrasesKannada => 'ದೈನಂದಿನ ವಾಕ್ಯಗಳು';
  @override
  String get foodDrinksKannada => 'ಆಹಾರ & ಪಾನೀಯಗಳು';
  @override
  String get vowelsDescription => 'ಕನ್ನಡ ವರ್ಣಮಾಲೆಯಲ್ಲಿ ಮೂಲ ಸ್ವರಗಳನ್ನು ಕಲಿಯಿರಿ';
  @override
  String get consonantsDescription => 'ಕನ್ನಡದಲ್ಲಿ ಮೂಲ ವ್ಯಂಜನಗಳನ್ನು ಕರಗತ ಮಾಡಿಕೊಳ್ಳಿ';
  @override
  String get numbersDescription => 'ಕನ್ನಡದಲ್ಲಿ ಎಣಿಕೆ ಕಲಿಯಿರಿ';
  @override
  String get greetingsDescription => 'ಸಾಮಾನ್ಯ ಶುಭಾಶಯಗಳು ಮತ್ತು ಅಭಿವ್ಯಕ್ತಿಗಳು';
  @override
  String get dailyPhrasesDescription => 'ದೈನಂದಿನ ಸಂಭಾಷಣೆಗಳಿಗೆ ಅಗತ್ಯವಾದ ವಾಕ್ಯಗಳು';
  @override
  String get foodDrinksDescription => 'ಕನ್ನಡದಲ್ಲಿ ಆಹಾರ ಮತ್ತು ಪಾನೀಯಗಳ ಬಗ್ಗೆ ಕಲಿಯಿರಿ';
  @override
  String get complete => 'ಪೂರ್ಣ';
}

// Telugu Implementation
class AppLocalizationsTe extends AppLocalizations {
  @override
  String get appName => 'కన్నడ నేర్చుకోండి';
  @override
  String get appSubtitle => 'ಕನ್ನಡ ಕಲಿ';
  @override
  String get home => 'హోమ్';
  @override
  String get progress => 'పురోగతి';
  @override
  String get test => 'పరీక్ష';
  @override
  String get profile => 'ప్రొఫైల్';
  @override
  String get welcomeTitle => 'కన్నడ నేర్చుకోవడానికి స్వాగతం!';
  @override
  String get welcomeSubtitle => 'మీ అభ్యాస ప్రొఫైల్‌ను సెటప్ చేద్దాం';
  @override
  String get whatShouldWeCallYou => 'మేము మిమ్మల్ని ఏం అని పిలవాలి?';
  @override
  String get personalizeExperience => 'మీ అనుభవాన్ని వ్యక్తిగతీకరించడానికి మేము దీన్ని ఉపయోగిస్తాము';
  @override
  String get yourName => 'మీ పేరు';
  @override
  String get nameHint => 'ఉదా: రామ్, సీత, అమిత్...';
  @override
  String get nameValidation => 'దయచేసి మీ పేరు నమోదు చేయండి';
  @override
  String get nameMinLength => 'పేరు కనీసం 2 అక్షరాలు ఉండాలి';
  @override
  String get choosePreferredLanguage => 'మీ ఇష్టపడే భాషను ఎంచుకోండి';
  @override
  String get translationsInLanguage => 'మేము ఈ భాషలో అనువాదాలను చూపుతాము';
  @override
  String almostThere(String name) => 'దాదాపు పూర్తయింది, $name!';
  @override
  String get reviewPreferences => 'మీ ప్రాధాన్యతలను సమీక్షించండి మరియు నేర్చుకోవడం ప్రారంభించండి';
  @override
  String get name => 'పేరు';
  @override
  String get language => 'భాష';
  @override
  String get darkMode => 'డార్క్ మోడ్';
  @override
  String get enableDarkTheme => 'డార్క్ థీమ్‌ను ప్రారంభించండి';
  @override
  String get changeSettingsAnytime => 'మీరు ఈ సెట్టింగ్‌లను మీ ప్రొఫైల్ నుండి ఎప్పుడైనా మార్చవచ్చు';
  @override
  String get getStarted => 'ప్రారంభించండి';
  @override
  String get next => 'తదుపరి';
  @override
  String get back => 'వెనుకకు';
  @override
  String get previous => 'మునుపటి';
  @override
  String get kannadaBasics => 'కన్నడ ప్రాథమికాలు';
  @override
  String get practicalPhrases => 'ఆచరణీయ వాక్యాలు';
  @override
  String get yourLearningProgress => 'మీ అభ్యాస పురోగతి';
  @override
  String get keepGoingGreat => 'కొనసాగించండి! మీరు బాగా చేస్తున్నారు';
  @override
  String get cardsLearned => 'కార్డులు నేర్చుకున్నారు';
  @override
  String get avgProgress => 'సగటు పురోగతి';
  @override
  String get quizzesDone => 'క్విజ్‌లు పూర్తి చేశారు';
  @override
  String get yourProgress => 'మీ పురోగతి';
  @override
  String get testYourKnowledge => 'మీ జ్ఞానాన్ని పరీక్షించండి';
  @override
  String get quizzesToTestProgress => 'మీ కన్నడ అభ్యాస పురోగతిని పరీక్షించడానికి క్విజ్‌లు తీసుకోండి';
  @override
  String get notStarted => 'ప్రారంభించలేదు';
  @override
  String scorePercent(int score) => '$score% స్కోర్';
  @override
  String get questions => 'ప్రశ్నలు';
  @override
  String get learningStatistics => 'అభ్యాస గణాంకాలు';
  @override
  String get flashcardsLearned => 'ఫ్లాష్‌కార్డులు నేర్చుకున్నారు';
  @override
  String get quizzesCompleted => 'క్విజ్‌లు పూర్తయ్యాయి';
  @override
  String get averageQuizScore => 'సగటు క్విజ్ స్కోర్';
  @override
  String get achievements => 'విజయాలు';
  @override
  String get noAchievementsYet => 'ఇంకా విజయాలు లేవు';
  @override
  String get keepLearningEarnAchievements => 'విజయాలు సాధించడానికి నేర్చుకుంటూ ఉండండి!';
  @override
  String get personalInformation => 'వ్యక్తిగత సమాచారం';
  @override
  String get preferredLanguage => 'ఇష్టపడే భాష';
  @override
  String get appInformation => 'యాప్ సమాచారం';
  @override
  String get version => 'వెర్షన్';
  @override
  String get on => 'ఆన్';
  @override
  String get off => 'ఆఫ్';
  @override
  String dayStreak(int days) => '$days రోజుల మాల';
  @override
  String get vowels => 'అచ్చులు';
  @override
  String get consonants => 'హల్లులు';
  @override
  String get numbers => 'సంఖ్యలు';
  @override
  String get greetings => 'శుభాకాంక్షలు';
  @override
  String get dailyPhrases => 'రోజువారీ వాక్యాలు';
  @override
  String get foodDrinks => 'ఆహారం మరియు పానీయాలు';
  @override
  String get vowelsKannada => 'ಸ್ವರಗಳು';
  @override
  String get consonantsKannada => 'ವ್ಯಂಜನಗಳು';
  @override
  String get numbersKannada => 'ಅಂಕಿಗಳು';
  @override
  String get greetingsKannada => 'ಶುಭಾಶಯಗಳು';
  @override
  String get dailyPhrasesKannada => 'ದೈನಂದಿನ ವಾಕ್ಯಗಳು';
  @override
  String get foodDrinksKannada => 'ಆಹಾರ & ಪಾನೀಯಗಳು';
  @override
  String get vowelsDescription => 'కన్నడ వర్ణమాలలో ప్రాథమిక అచ్చులను నేర్చుకోండి';
  @override
  String get consonantsDescription => 'కన్నడలో ప్రాథమిక హల్లులను నైపుణ్యం పొందండి';
  @override
  String get numbersDescription => 'కన్నడలో లెక్కింపు నేర్చుకోండి';
  @override
  String get greetingsDescription => 'సాధారణ శుభాకాంక్షలు మరియు వ్యక్తీకరణలు';
  @override
  String get dailyPhrasesDescription => 'రోజువారీ సంభాషణలకు అవసరమైన వాక్యాలు';
  @override
  String get foodDrinksDescription => 'కన్నడలో ఆహారం మరియు పానీయాల గురించి నేర్చుకోండి';
  @override
  String get complete => 'పూర్తి';
}