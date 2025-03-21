// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import '../constants/app_colors.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswerChecked = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _initializeQuestion();
  }

  void _initializeQuestion() {
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    if (currentQuestion.isAnswered) {
      // If the question is already answered, show the result
      setState(() {
        _selectedAnswerIndex = currentQuestion.correctAnswerIndex;
        _isAnswerChecked = true;
        _isCorrect = currentQuestion.isCorrect;
      });
    } else {
      setState(() {
        _selectedAnswerIndex = null;
        _isAnswerChecked = false;
        _isCorrect = false;
      });
    }
  }

  void _checkAnswer() {
    if (_selectedAnswerIndex == null || _isAnswerChecked) return;

    final correctIndex = widget.quiz.questions[_currentQuestionIndex].correctAnswerIndex;
    final isCorrect = _selectedAnswerIndex == correctIndex;

    Provider.of<QuizProvider>(context, listen: false).answerQuestion(
      widget.quiz.id,
      _currentQuestionIndex,
      _selectedAnswerIndex!,
    );

    setState(() {
      _isAnswerChecked = true;
      _isCorrect = isCorrect;
    });

    // Update user quiz score if the quiz is completed
    if (_currentQuestionIndex == widget.quiz.questions.length - 1 || 
        widget.quiz.questions.every((q) => q.isAnswered)) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateQuizScore(widget.quiz.id, widget.quiz.score);
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _initializeQuestion();
      });
    } else {
      // Navigate to results page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(quiz: widget.quiz),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Kannada character
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          question.kannada,
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Options
                    ...List.generate(
                      question.options.length,
                      (index) => _buildOptionCard(
                        option: question.options[index],
                        index: index,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Action button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _isAnswerChecked ? _nextQuestion : _checkAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isAnswerChecked
                      ? _currentQuestionIndex < widget.quiz.questions.length - 1
                          ? 'Next Question'
                          : 'See Results'
                      : 'Check Answer',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({required String option, required int index}) {
    bool isSelected = _selectedAnswerIndex == index;
    bool isCorrectAnswer = index == widget.quiz.questions[_currentQuestionIndex].correctAnswerIndex;
    
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black;
    
    if (_isAnswerChecked) {
      if (isCorrectAnswer) {
        cardColor = Colors.green[50]!;
        borderColor = Colors.green;
        textColor = Colors.green[700]!;
      } else if (isSelected && !isCorrectAnswer) {
        cardColor = Colors.red[50]!;
        borderColor = Colors.red;
        textColor = Colors.red[700]!;
      }
    } else if (isSelected) {
      cardColor = AppColors.primary.withOpacity(0.1);
      borderColor = AppColors.primary;
      textColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: _isAnswerChecked ? null : () {
        setState(() {
          _selectedAnswerIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? borderColor : Colors.grey[200],
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: isSelected || (isCorrectAnswer && _isAnswerChecked)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            if (_isAnswerChecked && isCorrectAnswer)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            else if (_isAnswerChecked && isSelected && !isCorrectAnswer)
              const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}