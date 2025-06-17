// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../providers/lesson_provider.dart';
import '../providers/user_provider.dart';
import '../models/flashcard_model.dart';
import '../models/user_preferences.dart';
import 'flashcard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.preferences;

    return Consumer<LessonProvider>(
      builder: (context, lessonProvider, child) {
        if (lessonProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Organize lessons into categories
        final basicLessons = [
          lessonProvider.lessons['vowels'],
          lessonProvider.lessons['consonants'],
          lessonProvider.lessons['numbers'],
        ].whereType<Lesson>().toList();

        final phraseLessons = [
          lessonProvider.lessons['greetings'],
          lessonProvider.lessons['daily_phrases'],
          lessonProvider.lessons['food'],
        ].whereType<Lesson>().toList();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.appSubtitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.appName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        if (user != null)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withAlpha(26),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    Text(
                                      '${user.streakDays}',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // User progress card
                    if (user != null && lessonProvider.lessons.isNotEmpty)
                      _buildProgressCard(context, lessonProvider, user, l10n),
                      
                    const SizedBox(height: 24),
                    
                    // Alphabet & Numbers section
                    Text(
                      l10n.kannadaBasics,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...basicLessons.map((lesson) => 
                      _buildLessonCard(
                        context,
                        lesson,
                        l10n,
                        () => _navigateToLesson(context, lesson),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Phrases section
                    Text(
                      l10n.practicalPhrases,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...phraseLessons.map((lesson) => 
                      _buildLessonCard(
                        context,
                        lesson,
                        l10n,
                        () => _navigateToLesson(context, lesson),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressCard(BuildContext context, LessonProvider lessonProvider, UserPreferences user, AppLocalizations l10n) {
    final avgProgress = lessonProvider.getAverageProgress();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourLearningProgress,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.keepGoingGreat,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  '${user.totalFlashcardsLearned}',
                  l10n.cardsLearned,
                  Icons.school,
                ),
                _buildStatItem(
                  '${avgProgress.toInt()}%',
                  l10n.avgProgress,
                  Icons.trending_up,
                ),
                _buildStatItem(
                  '${user.quizScores.length}',
                  l10n.quizzesDone,
                  Icons.quiz,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context,
    Lesson lesson,
    AppLocalizations l10n,
    VoidCallback onTap,
  ) {
    // Get localized lesson titles and descriptions
    String localizedTitle = _getLocalizedLessonTitle(lesson.id, l10n);
    String localizedKannadaTitle = _getLocalizedKannadaTitle(lesson.id, l10n);
    String localizedDescription = _getLocalizedLessonDescription(lesson.id, l10n);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizedKannadaTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizedTitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${lesson.flashcards.length}",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (localizedDescription.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  localizedDescription,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: lesson.progress / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${lesson.progress.toInt()}% ${l10n.complete}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedLessonTitle(String lessonId, AppLocalizations l10n) {
    switch (lessonId) {
      case 'vowels':
        return l10n.vowels;
      case 'consonants':
        return l10n.consonants;
      case 'numbers':
        return l10n.numbers;
      case 'greetings':
        return l10n.greetings;
      case 'daily_phrases':
        return l10n.dailyPhrases;
      case 'food':
        return l10n.foodDrinks;
      default:
        return lessonId;
    }
  }

  String _getLocalizedKannadaTitle(String lessonId, AppLocalizations l10n) {
    switch (lessonId) {
      case 'vowels':
        return l10n.vowelsKannada;
      case 'consonants':
        return l10n.consonantsKannada;
      case 'numbers':
        return l10n.numbersKannada;
      case 'greetings':
        return l10n.greetingsKannada;
      case 'daily_phrases':
        return l10n.dailyPhrasesKannada;
      case 'food':
        return l10n.foodDrinksKannada;
      default:
        return lessonId;
    }
  }

  String _getLocalizedLessonDescription(String lessonId, AppLocalizations l10n) {
    switch (lessonId) {
      case 'vowels':
        return l10n.vowelsDescription;
      case 'consonants':
        return l10n.consonantsDescription;
      case 'numbers':
        return l10n.numbersDescription;
      case 'greetings':
        return l10n.greetingsDescription;
      case 'daily_phrases':
        return l10n.dailyPhrasesDescription;
      case 'food':
        return l10n.foodDrinksDescription;
      default:
        return '';
    }
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  void _navigateToLesson(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardScreen(lesson: lesson),
      ),
    );
  }
}