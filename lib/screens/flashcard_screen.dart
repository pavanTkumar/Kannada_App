// lib/screens/flashcard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/flashcard_model.dart';
import '../providers/lesson_provider.dart';
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
  late bool _isCurrentCardLearned;

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

    _isCurrentCardLearned = widget.lesson.flashcards[_currentIndex].isLearned;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.isAnimating) return;
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  void _nextCard() {
    if (_currentIndex < widget.lesson.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showFront = true;
        _isCurrentCardLearned = widget.lesson.flashcards[_currentIndex].isLearned;
      });
      _controller.reset();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showFront = true;
        _isCurrentCardLearned = widget.lesson.flashcards[_currentIndex].isLearned;
      });
      _controller.reset();
    }
  }

  void _toggleLearned() {
    final lessonProvider = context.read<LessonProvider>();
    
    if (_isCurrentCardLearned) {
      // Card is already marked as learned, unmark it
      lessonProvider.markFlashcardAsLearned(
        widget.lesson.id,
        _currentIndex,
        false, // Unmark
      );
    } else {
      // Card is not learned, mark it as learned
      lessonProvider.markFlashcardAsLearned(
        widget.lesson.id,
        _currentIndex,
        true, // Mark as learned
      );
    }
    
    setState(() {
      _isCurrentCardLearned = !_isCurrentCardLearned;
    });
  }
  
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use Flashcards'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ListTile(
              leading: Icon(Icons.touch_app),
              title: Text('Tap card to flip'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Mark cards as learned'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.repeat),
              title: Text('Practice regularly'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFlashcard = widget.lesson.flashcards[_currentIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.grey.shade50,
            child: Column(
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
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.lesson.flashcards.where((f) => f.isLearned).length} learned',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / widget.lesson.flashcards.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
          
          // Flashcard content
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_animation.value),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: currentFlashcard.isLearned ? Colors.green : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                currentFlashcard.isLearned 
                                    ? Colors.green.shade50 
                                    : AppColors.primary.withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (currentFlashcard.isLearned)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.green.shade300,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Learned',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Text(
                                _showFront ? 'Kannada' : 'English',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(_showFront ? 0 : pi),
                                  child: Text(
                                    _showFront ? currentFlashcard.kannada : currentFlashcard.english,
                                    style: TextStyle(
                                      fontSize: _showFront ? 48 : 36,
                                      fontWeight: FontWeight.bold,
                                      color: _showFront 
                                          ? AppColors.primary 
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Tap card to flip',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
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
          
          // Control buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _currentIndex > 0 ? _previousCard : null,
                  color: _currentIndex > 0 ? AppColors.primary : Colors.grey.shade300,
                  iconSize: 28,
                ),
                ElevatedButton(
                  onPressed: _toggleLearned,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCurrentCardLearned ? Colors.green : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isCurrentCardLearned ? Icons.refresh : Icons.check,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isCurrentCardLearned ? 'Reset' : 'Mark as Learned',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _currentIndex < widget.lesson.flashcards.length - 1
                      ? _nextCard
                      : null,
                  color: _currentIndex < widget.lesson.flashcards.length - 1 
                      ? AppColors.primary 
                      : Colors.grey.shade300,
                  iconSize: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}