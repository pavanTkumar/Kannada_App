// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'constants/app_colors.dart';
import 'providers/lesson_provider.dart';
import 'providers/user_provider.dart';
import 'providers/quiz_provider.dart';
import 'utils/navigator_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final userProvider = UserProvider();
  await userProvider.loadPreferences();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Learn Kannada',
          debugShowCheckedModeBanner: false,
          
          // Internationalization
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: userProvider.currentLocale,
          
          themeMode: userProvider.preferences?.isDarkMode ?? false 
            ? ThemeMode.dark 
            : ThemeMode.light,
          theme: ThemeData(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: Colors.grey[900],
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.primary,
              surface: Colors.grey[800]!,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            cardTheme: CardTheme(
              color: Colors.grey[800],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}