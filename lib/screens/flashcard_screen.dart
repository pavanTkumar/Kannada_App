// lib/screens/flashcard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Removed unused import
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
      });
      _controller.reset();
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showFront = true;
      });
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Card ${_currentIndex + 1} of ${widget.lesson.flashcards.length}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_animation.value),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              _showFront
                                ? widget.lesson.flashcards[_currentIndex].kannada
                                : widget.lesson.flashcards[_currentIndex].english,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _currentIndex > 0 ? _previousCard : null,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<LessonProvider>().markFlashcardAsLearned(
                      widget.lesson.id,
                      _currentIndex,
                    );
                  },
                  child: const Text('Mark as Learned'),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _currentIndex < widget.lesson.flashcards.length - 1
                      ? _nextCard
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}