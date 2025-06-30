import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_model.dart';
import 'quiz_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialized = true;
        context.read<QuizProvider>().loadQuizzes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final quizzes = quizProvider.quizzes;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.testYourKnowledge,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.quizzesToTestProgress,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = quizzes[index];
                      return _buildQuizCard(context, quiz, l10n);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizCard(BuildContext context, Quiz quiz, AppLocalizations l10n) {
    String statusText = l10n.notStarted;
    Color statusColor = Colors.grey;
    
    if (quiz.isCompleted) {
      statusText = l10n.scorePercent(quiz.score.toInt());
      if (quiz.score >= 80) {
        statusColor = Colors.green;
      } else if (quiz.score >= 60) {
        statusColor = Colors.orange;
      } else {
        statusColor = Colors.red;
      }
    }

    final localizedTitle = _getLocalizedQuizTitle(quiz.id, l10n);
    final localizedDescription = _getLocalizedQuizDescription(quiz.id, l10n);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(quiz: quiz),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      localizedTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                localizedDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.quiz,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${quiz.questions.length} ${l10n.questions}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
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

  String _getLocalizedQuizTitle(String quizId, AppLocalizations l10n) {
    switch (quizId) {
      case 'basic_vowels':
        return '${l10n.vowels} ${l10n.test}';
      case 'basic_consonants':
        return '${l10n.consonants} ${l10n.test}';
      case 'basic_numbers':
        return '${l10n.numbers} ${l10n.test}';
      case 'mixed_basic':
        return 'Mixed ${l10n.kannadaBasics} ${l10n.test}';
      default:
        return quizId;
    }
  }

  String _getLocalizedQuizDescription(String quizId, AppLocalizations l10n) {
    switch (quizId) {
      case 'basic_vowels':
        return l10n.vowelsDescription;
      case 'basic_consonants':
        return l10n.consonantsDescription;
      case 'basic_numbers':
        return l10n.numbersDescription;
      case 'mixed_basic':
        return 'Test your mixed knowledge of ${l10n.kannadaBasics.toLowerCase()}';
      default:
        return 'Test your knowledge';
    }
  }
}