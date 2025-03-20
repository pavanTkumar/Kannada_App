// lib/screens/flashcard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/flashcard_model.dart';
import '../providers/lesson_provider.dart';
import '../providers/user_provider.dart';
import '../constants/app_colors.dart';
import 'dart:math' show pi;

class FlashcardScreen extends StatefulWidget {
  final Lesson lesson;

  const FlashcardScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;
  int _currentIndex = 0;
  bool _isCompleted = false;
  bool _isAnimating = false;

  // New properties for enhanced UI
  final PageController _pageController = PageController();
  double _progressPercent = 0.0;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: pi / 2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -pi / 2, end: 0.0),
        weight: 50,
      ),
    ]).animate(_controller);
    
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
      } else if (status == AnimationStatus.dismissed) {
        _isAnimating = false;
      }
    });
    
    // Calculate initial progress
    _updateProgress();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final totalCards = widget.lesson.flashcards.length;
    final learnedCards = widget.lesson.flashcards.where((card) => card.isLearned).length;
    setState(() {
      _progressPercent = totalCards > 0 ? learnedCards / totalCards : 0;
    });
  }

  void _flipCard() {
    if (_isAnimating) return;
    
    _isAnimating = true;
    setState(() {
      _showFront = !_showFront;
    });
    
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _nextCard() {
    if (_currentIndex < widget.lesson.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showFront = true;
      });
      _controller.reset();
      
      // Animate to next page
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        _isCompleted = true;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showFront = true;
      });
      _controller.reset();
      
      // Animate to previous page
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void _markAsLearned() {
    final flashcard = widget.lesson.flashcards[_currentIndex];
    if (!flashcard.isLearned) {
      context.read<LessonProvider>().markFlashcardAsLearned(
        widget.lesson.id,
        _currentIndex,
      );
      
      // Update progress
      _updateProgress();
      
      // Show success animation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Card marked as learned!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _resetLesson() {
    setState(() {
      _currentIndex = 0;
      _showFront = true;
      _isCompleted = false;
    });
    _controller.reset();
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _resetLesson,
            tooltip: 'Reset Lesson',
          ),
        ],
      ),
      body: _isCompleted 
          ? _buildCompletionScreen() 
          : _buildFlashcardScreen(),
    );
  }
  
  Widget _buildCompletionScreen() {
    final totalCards = widget.lesson.flashcards.length;
    final learnedCards = widget.lesson.flashcards.where((card) => card.isLearned).length;
    
    return AnimationConfiguration.synchronized(
      child: SlideAnimation(
        duration: const Duration(milliseconds: 500),
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Lesson Complete!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You have learned $learnedCards out of $totalCards flashcards',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _resetLesson,
                    icon: const Icon(Icons.replay),
                    label: const Text('Review Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to Lessons'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardScreen() {
    return Column(
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.primary.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card ${_currentIndex + 1} of ${widget.lesson.flashcards.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${(_progressPercent * 100).toInt()}% Learned',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: _progressPercent,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
        
        // Flashcard
        Expanded(
          child: GestureDetector(
            onTap: _flipCard,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // Swiped right
                _previousCard();
              } else if (details.primaryVelocity! < 0) {
                // Swiped left
                _nextCard();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_animation.value);
                  
                  final isBack = _animation.value >= pi / 2;
                  
                  return Transform(
                    alignment: Alignment.center,
                    transform: transform,
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: widget.lesson.flashcards[_currentIndex].isLearned
                              ? Colors.green
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              isBack ? Colors.blue[50]! : AppColors.primary.withOpacity(0.1),
                              isBack ? Colors.blue[100]! : AppColors.primary.withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isBack) ...[
                              const Text(
                                'ENGLISH',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.lesson.flashcards[_currentIndex].english,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ] else ...[
                              const Text(
                                'KANNADA',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.lesson.flashcards[_currentIndex].kannada,
                                style: const TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 40),
                            Icon(
                              Icons.touch_app,
                              color: Colors.grey[400],
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to flip',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        // Controls
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: _currentIndex > 0 ? _previousCard : null,
                color: _currentIndex > 0 ? AppColors.primary : Colors.grey[300],
                tooltip: 'Previous Card',
                iconSize: 28,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _markAsLearned();
                },
                icon: Icon(
                  widget.lesson.flashcards[_currentIndex].isLearned
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                ),
                label: Text(
                  widget.lesson.flashcards[_currentIndex].isLearned
                      ? 'Learned'
                      : 'Mark as Learned',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.lesson.flashcards[_currentIndex].isLearned
                      ? Colors.green
                      : AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                onPressed: _currentIndex < widget.lesson.flashcards.length - 1
                    ? _nextCard
                    : null,
                color: _currentIndex < widget.lesson.flashcards.length - 1
                    ? AppColors.primary
                    : Colors.grey[300],
                tooltip: 'Next Card',
                iconSize: 28,
              ),
            ],
          ),
        ),
      ],
    );
  }
}