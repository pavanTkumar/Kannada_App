// lib/widgets/flashcard_widget.dart
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class FlashCard extends StatefulWidget {
  final String front;
  final String back;
  final VoidCallback onLearned;

  const FlashCard({
    super.key,
    required this.front,
    required this.back,
    required this.onLearned,
  });

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

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

    _animation.addListener(() {
      if (_animation.value == pi / 2) {
        setState(() {
          _showFront = !_showFront;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 200,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(_showFront ? 0 : pi),
                    child: Text(
                      _showFront ? widget.front : widget.back,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}