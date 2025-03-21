// lib/providers/quiz_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_model.dart';

class QuizProvider with ChangeNotifier {
  static const String _quizDataKey = 'quiz_data';
  static const String _quizProgressKey = 'quiz_progress';
  
  List<Quiz> _quizzes = [];
  bool _isLoading = false;
  
  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;
  
  Future<void> loadQuizzes() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Load quiz data
      _quizzes = _getQuizData();
      
      // Load progress
      final prefs = await SharedPreferences.getInstance();
      final String? progressJson = prefs.getString(_quizProgressKey);
      
      if (progressJson != null) {
        final Map<String, dynamic> progress = json.decode(progressJson);
        
        // Apply progress to quizzes
        for (final quiz in _quizzes) {
          if (progress.containsKey(quiz.id)) {
            final Map<String, dynamic> quizProgress = progress[quiz.id];
            quiz.correctAnswers = quizProgress['correctAnswers'] ?? 0;
            quiz.isCompleted = quizProgress['isCompleted'] ?? false;
            
            // Apply progress to individual questions
            if (quizProgress.containsKey('questions')) {
              final List<dynamic> questionProgress = quizProgress['questions'];
              
              for (int i = 0; i < quiz.questions.length && i < questionProgress.length; i++) {
                quiz.questions[i].isAnswered = questionProgress[i]['isAnswered'] ?? false;
                quiz.questions[i].isCorrect = questionProgress[i]['isCorrect'] ?? false;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading quizzes: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> saveQuizProgress(Quiz quiz) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? progressJson = prefs.getString(_quizProgressKey);
      
      Map<String, dynamic> progress = {};
      if (progressJson != null) {
        progress = json.decode(progressJson);
      }
      
      // Save quiz progress
      progress[quiz.id] = {
        'correctAnswers': quiz.correctAnswers,
        'isCompleted': quiz.isCompleted,
        'questions': quiz.questions.map((q) => {
          'isAnswered': q.isAnswered,
          'isCorrect': q.isCorrect,
        }).toList(),
      };
      
      await prefs.setString(_quizProgressKey, json.encode(progress));
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving quiz progress: $e');
    }
  }
  
  Future<void> answerQuestion(String quizId, int questionIndex, int answerIndex) async {
    final quizIndex = _quizzes.indexWhere((q) => q.id == quizId);
    if (quizIndex == -1) return;
    
    final quiz = _quizzes[quizIndex];
    if (questionIndex >= quiz.questions.length) return;
    
    final question = quiz.questions[questionIndex];
    if (question.isAnswered) return;
    
    // Mark question as answered
    question.isAnswered = true;
    question.isCorrect = (answerIndex == question.correctAnswerIndex);
    
    // Update quiz stats
    if (question.isCorrect) {
      quiz.correctAnswers++;
    }
    
    // Check if quiz is completed
    final allAnswered = quiz.questions.every((q) => q.isAnswered);
    if (allAnswered) {
      quiz.isCompleted = true;
    }
    
    await saveQuizProgress(quiz);
  }
  
  List<Quiz> _getQuizData() {
    return [
      Quiz(
        id: 'basic_vowels',
        title: 'Vowels Quiz',
        description: 'Test your knowledge of Kannada vowels',
        questions: [
          QuizQuestion(
            question: 'What is the Kannada vowel for "a"?',
            kannada: 'ಅ',
            options: ['ಅ', 'ಆ', 'ಇ', 'ಈ'],
            correctAnswerIndex: 0,
          ),
          QuizQuestion(
            question: 'Select the Kannada vowel "i"',
            kannada: 'ಇ',
            options: ['ಅ', 'ಆ', 'ಇ', 'ಈ'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Which of these represents "u" in Kannada?',
            kannada: 'ಉ',
            options: ['ಉ', 'ಊ', 'ಋ', 'ೠ'],
            correctAnswerIndex: 0,
          ),
          QuizQuestion(
            question: 'Identify the Kannada vowel "e"',
            kannada: 'ಎ',
            options: ['ಎ', 'ಏ', 'ಐ', 'ಒ'],
            correctAnswerIndex: 0,
          ),
          QuizQuestion(
            question: 'Which vowel represents "ai" in Kannada?',
            kannada: 'ಐ',
            options: ['ಎ', 'ಏ', 'ಐ', 'ಒ'],
            correctAnswerIndex: 2,
          ),
        ],
      ),
      Quiz(
        id: 'basic_consonants',
        title: 'Consonants Quiz',
        description: 'Test your knowledge of Kannada consonants',
        questions: [
          QuizQuestion(
            question: 'What is the Kannada consonant for "ka"?',
            kannada: 'ಕ',
            options: ['ಕ', 'ಖ', 'ಗ', 'ಘ'],
            correctAnswerIndex: 0,
          ),
          QuizQuestion(
            question: 'Select the Kannada consonant "ga"',
            kannada: 'ಗ',
            options: ['ಕ', 'ಖ', 'ಗ', 'ಘ'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Which of these represents "cha" in Kannada?',
            kannada: 'ಚ',
            options: ['ಚ', 'ಛ', 'ಜ', 'ಝ'],
            correctAnswerIndex: 0,
          ),
          QuizQuestion(
            question: 'Identify the Kannada consonant "ja"',
            kannada: 'ಜ',
            options: ['ಚ', 'ಛ', 'ಜ', 'ಝ'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Which consonant represents "nya" in Kannada?',
            kannada: 'ಞ',
            options: ['ಙ', 'ಞ', 'ಣ', 'ನ'],
            correctAnswerIndex: 1,
          ),
        ],
      ),
      Quiz(
        id: 'basic_numbers',
        title: 'Numbers Quiz',
        description: 'Test your knowledge of Kannada numbers',
        questions: [
          QuizQuestion(
            question: 'What is the Kannada number for 1?',
            kannada: '೧',
            options: ['೧', '೨', '೩', '೪'],
            correctAnswerIndex: 0,
          ),
          QuizQuestion(
            question: 'Select the Kannada number for 3',
            kannada: '೩',
            options: ['೧', '೨', '೩', '೪'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Which of these represents 5 in Kannada?',
            kannada: '೫',
            options: ['೩', '೪', '೫', '೬'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Identify the Kannada number for 7',
            kannada: '೭',
            options: ['೫', '೬', '೭', '೮'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Which number represents 0 in Kannada?',
            kannada: '೦',
            options: ['೮', '೯', '೦', '೧'],
            correctAnswerIndex: 2,
          ),
        ],
      ),
      Quiz(
        id: 'mixed_basic',
        title: 'Mixed Basics Quiz',
        description: 'Test your mixed knowledge of Kannada basics',
        questions: [
          QuizQuestion(
            question: 'Match the Kannada character ಅ with its sound',
            kannada: 'ಅ',
            options: ['a', 'aa', 'i', 'u'],
            correctAnswerIndex: 0,
          ),
          QuizQuestion(
            question: 'Which number is this: ೫',
            kannada: '೫',
            options: ['3', '4', '5', '6'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Match the Kannada character ಕ with its sound',
            kannada: 'ಕ',
            options: ['ta', 'pa', 'ka', 'sa'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Which vowel is this: ಐ',
            kannada: 'ಐ',
            options: ['e', 'ee', 'ai', 'o'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Match the Kannada number ೮ with its value',
            kannada: '೮',
            options: ['6', '7', '8', '9'],
            correctAnswerIndex: 2,
          ),
        ],
      ),
    ];
  }
}