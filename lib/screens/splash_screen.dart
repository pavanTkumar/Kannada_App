// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'main_screen.dart';
import 'setup_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    ));

    _controller.forward().then((_) {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          userProvider.isInitialized ? const MainNavigationScreen() : const SetupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App icon with shadow
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "ಕ",
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Learn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Kannada',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ಕನ್ನಡ ಕಲಿ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}