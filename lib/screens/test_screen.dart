// lib/screens/test_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
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
    // Initialize in post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialized = true;
        context.read<QuizProvider>().loadQuizzes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final quizzes = quizProvider.quizzes;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Your Knowledge',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take quizzes to test your Kannada learning progress',
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
                      return _buildQuizCard(context, quiz);
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

  Widget _buildQuizCard(BuildContext context, Quiz quiz) {
    String statusText = "Not started";
    Color statusColor = Colors.grey;
    
    if (quiz.isCompleted) {
      statusText = "${quiz.score.toInt()}% Score";
      if (quiz.score >= 80) {
        statusColor = Colors.green;
      } else if (quiz.score >= 60) {
        statusColor = Colors.orange;
      } else {
        statusColor = Colors.red;
      }
    }

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
                      quiz.title,
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
                      color: statusColor.withOpacity(0.1),
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
                quiz.description,
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
                      color: AppColors.primary.withOpacity(0.1),
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
                    '${quiz.questions.length} questions',
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
}