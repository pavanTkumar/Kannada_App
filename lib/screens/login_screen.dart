// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import 'main_screen.dart';
import 'setup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Handle error display if present
    if (authProvider.error != null && authProvider.error!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                authProvider.clearError();
              },
            ),
          ),
        );
        authProvider.clearError(); // Clear after showing
      });
    }
    
    // Check if authentication successful
    if (authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.isInitialized) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SetupScreen()),
          );
        }
      });
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'ಕನ್ನಡ ಕಲಿ',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Learn Kannada',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'Sign in to start learning',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _GoogleSignInButton(),
              const SizedBox(height: 16),
              _GuestSignInButton(),
              const SizedBox(height: 48),
              const Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatefulWidget {
  const _GoogleSignInButton();

  @override
  State<_GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<_GoogleSignInButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return ElevatedButton.icon(
      onPressed: _isLoading || authProvider.isLoading
        ? null
        : () async {
            setState(() {
              _isLoading = true;
            });
            
            try {
              await authProvider.signInWithGoogle();
            } finally {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
      icon: _isLoading
        ? Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(2.0),
            child: const CircularProgressIndicator(
              color: Colors.black54,
              strokeWidth: 3,
            ),
          )
        : const Icon(Icons.g_mobiledata),
      label: Text(_isLoading ? 'Signing in...' : 'Continue with Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}

class _GuestSignInButton extends StatefulWidget {
  const _GuestSignInButton();

  @override
  State<_GuestSignInButton> createState() => _GuestSignInButtonState();
}

class _GuestSignInButtonState extends State<_GuestSignInButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return OutlinedButton.icon(
      onPressed: _isLoading || authProvider.isLoading
        ? null
        : () async {
            setState(() {
              _isLoading = true;
            });
            
            try {
              final success = await authProvider.signInAnonymously();
              
              // Force navigation regardless of Firebase Auth state
              if (success && mounted) {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                if (userProvider.isInitialized) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SetupScreen()),
                  );
                }
              }
            } finally {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
      icon: _isLoading
        ? Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(2.0),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : const Icon(Icons.person_outline),
      label: Text(_isLoading ? 'Signing in...' : 'Continue as Guest'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}