// lib/screens/quiz_result_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../constants/app_colors.dart';
import '../providers/user_provider.dart';
import '../models/achievement_model.dart';

class QuizResultScreen extends StatelessWidget {
  final Quiz quiz;

  const QuizResultScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final score = quiz.score;
    String message;
    Color messageColor;

    if (score >= 90) {
      message = 'Excellent! You\'re a Kannada master!';
      messageColor = Colors.green;
    } else if (score >= 70) {
      message = 'Great job! You\'re learning well!';
      messageColor = Colors.green[700]!;
    } else if (score >= 50) {
      message = 'Good effort! Keep practicing!';
      messageColor = Colors.orange;
    } else {
      message = 'Keep trying! You\'ll improve with practice!';
      messageColor = Colors.red;
    }

    // Check for achievements
    _checkForQuizAchievements(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildScoreCircle(score),
                      const SizedBox(height: 24),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: messageColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Question Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        quiz.questions.length,
                        (index) => _buildQuestionSummary(quiz.questions[index], index),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back to Quizzes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(double score) {
    Color scoreColor;
    if (score >= 80) {
      scoreColor = Colors.green;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: scoreColor,
              width: 8,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              '${score.toInt()}%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
            Text(
              'Score',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionSummary(QuizQuestion question, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: question.isCorrect ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: question.isCorrect ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: question.isCorrect ? Colors.green : Colors.red,
                ),
                child: Icon(
                  question.isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Question ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Correct answer: ${question.options[question.correctAnswerIndex]}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  void _checkForQuizAchievements(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userPrefs = userProvider.preferences;
    
    if (userPrefs == null) return;
    
    // Count completed quizzes
    int completedQuizzes = 0;
    for (final entry in userPrefs.quizScores.entries) {
      if (entry.value > 0) {
        completedQuizzes++;
      }
    }
    
    // First quiz completed
    if (completedQuizzes == 1) {
      userProvider.addAchievement(Achievement(
        id: 'quiz_first',
        title: 'Quiz Beginner',
        description: 'Completed your first quiz',
        iconName: 'quiz',
        dateEarned: DateTime.now(),
      ));
    }
    
    // 5 quizzes completed
    if (completedQuizzes >= 5) {
      userProvider.addAchievement(Achievement(
        id: 'quiz_5',
        title: 'Quiz Enthusiast',
        description: 'Completed 5 quizzes',
        iconName: 'quiz',
        dateEarned: DateTime.now(),
      ));
    }
    
    // Perfect score (100%)
    if (quiz.score == 100) {
      userProvider.addAchievement(Achievement(
        id: 'quiz_perfect',
        title: 'Perfect Score',
        description: 'Achieved a perfect 100% on a quiz',
        iconName: 'emoji_events',
        dateEarned: DateTime.now(),
      ));
    }
  }
}