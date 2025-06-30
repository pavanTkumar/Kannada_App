import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_te.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('te')
  ];

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
  String cardOf(int current, int total);
  String get learned;
  String get kannada;
  String get english;
  String get tapCardToFlip;
  String get markAsLearned;
  String get reset;
  String get howToUseFlashcards;
  String get tapCardToFlipInfo;
  String get markCardsAsLearned;
  String get practiceRegularly;
  String get gotIt;
  String get quizResults;
  String get excellentMaster;
  String get greatJobLearning;
  String get goodEffortKeepPracticing;
  String get keepTryingImprove;
  String get questionSummary;
  String get backToQuizzes;
  String get score;
  String questionNumber(int number);
  String correctAnswer(String answer);
  String questionNumberOfTotal(int current, int total);
  String get checkAnswer;
  String get nextQuestion;
  String get seeResults;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'kn', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'kn': return AppLocalizationsKn();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.'
  );
}