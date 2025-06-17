// lib/utils/language_helper.dart
import 'package:flutter/material.dart';

class LanguageHelper {
  static const Map<String, Locale> supportedLanguages = {
    'English': Locale('en'),
    'हिंदी': Locale('hi'),
    'ಕನ್ನಡ': Locale('kn'),
    'తెలుగు': Locale('te'),
  };

  static const List<String> languageNames = [
    'English',
    'हिंदी', 
    'ಕನ್ನಡ',
    'తెలుగు',
  ];

  static Locale getLocaleFromLanguageName(String languageName) {
    return supportedLanguages[languageName] ?? const Locale('en');
  }

  static String getLanguageNameFromLocale(Locale locale) {
    return supportedLanguages.entries
        .firstWhere(
          (entry) => entry.value == locale,
          orElse: () => const MapEntry('English', Locale('en')),
        )
        .key;
  }

  static String getLanguageDisplayName(String languageName, Locale currentLocale) {
    switch (currentLocale.languageCode) {
      case 'hi':
        switch (languageName) {
          case 'English':
            return 'अंग्रेजी';
          case 'हिंदी':
            return 'हिंदी';
          case 'ಕನ್ನಡ':
            return 'कन्नड़';
          case 'తెలుగు':
            return 'तेलुगु';
          default:
            return languageName;
        }
      case 'kn':
        switch (languageName) {
          case 'English':
            return 'ಇಂಗ್ಲಿಷ್';
          case 'हिंदी':
            return 'ಹಿಂದಿ';
          case 'ಕನ್ನಡ':
            return 'ಕನ್ನಡ';
          case 'తెలుగు':
            return 'ತೆಲುಗು';
          default:
            return languageName;
        }
      case 'te':
        switch (languageName) {
          case 'English':
            return 'ఇంగ్లిష్';
          case 'हिंदी':
            return 'హిందీ';
          case 'ಕನ್ನಡ':
            return 'కన్నడ';
          case 'తెలుగు':
            return 'తెలుగు';
          default:
            return languageName;
        }
      default:
        return languageName;
    }
  }
}