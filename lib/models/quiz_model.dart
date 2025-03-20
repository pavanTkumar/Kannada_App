// lib/models/quiz_model.dart
class QuizQuestion {
  final String question;
  final String kannada;
  final List<String> options;
  final int correctAnswerIndex;
  bool isAnswered;
  bool isCorrect;

  QuizQuestion({
    required this.question,
    required this.kannada,
    required this.options,
    required this.correctAnswerIndex,
    this.isAnswered = false,
    this.isCorrect = false,
  });
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  int correctAnswers;
  bool isCompleted;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    this.correctAnswers = 0,
    this.isCompleted = false,
  });

  double get score {
    if (questions.isEmpty) return 0.0;
    return (correctAnswers / questions.length) * 100;
  }
}