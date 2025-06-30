// lib/screens/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../providers/lesson_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<LessonProvider>(
      builder: (context, lessonProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.yourProgress,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: lessonProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : lessonProvider.lessons.isEmpty
                        ? _buildEmptyProgress(isDarkMode)
                        : ListView.builder(
                            itemCount: lessonProvider.lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = lessonProvider.lessons.values.elementAt(index);
                              final localizedTitle = _getLocalizedLessonTitle(lesson.id, l10n);
                              return _buildProgressCard(
                                context,
                                localizedTitle, 
                                lesson.progress, 
                                l10n,
                                isDarkMode,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyProgress(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 80,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No progress data available yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start learning to see your progress here',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
            ),
          ),
        ],
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

  Widget _buildProgressCard(
    BuildContext context, 
    String title, 
    double progress, 
    AppLocalizations l10n,
    bool isDarkMode,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getProgressColor(progress).withValues(alpha: isDarkMode ? 40 : 26),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${progress.toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getProgressColor(progress),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progress > 0 
                ? '${progress.toInt()}% ${l10n.complete}' 
                : l10n.notStarted,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 50) return Colors.orange;
    return AppColors.primary;
  }
}