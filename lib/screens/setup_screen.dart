// lib/screens/setup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../models/user_preferences.dart';
import '../providers/user_provider.dart';
import '../utils/language_helper.dart';
import 'main_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedLanguage = 'English';
  bool _isDarkMode = false;
  int _currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final locale = LanguageHelper.getLocaleFromLanguageName(_selectedLanguage);
      final preferences = UserPreferences(
        name: _nameController.text,
        preferredLanguage: _selectedLanguage,
        locale: locale,
        isDarkMode: _isDarkMode,
      );

      await context.read<UserProvider>().savePreferences(preferences);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
      );
    }
  }

  void _nextStep() {
    if (_currentStep == 0 && _nameController.text.isEmpty) {
      _formKey.currentState!.validate();
      return;
    }
    
    setState(() {
      _currentStep += 1;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep -= 1;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "ಕ",
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.welcomeTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.welcomeSubtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Step Indicator
                Row(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: i <= _currentStep ? AppColors.primary : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Step Content
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _buildCurrentStep(l10n),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: _previousStep,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back),
                            const SizedBox(width: 4),
                            Text(_currentStep == 2 ? l10n.previous : l10n.back),
                          ],
                        ),
                      )
                    else
                      const SizedBox(width: 100),
                    
                    ElevatedButton(
                      onPressed: _currentStep == 2 ? _submitForm : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(_currentStep == 2 ? l10n.getStarted : l10n.next),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildNameStep(l10n);
      case 1:
        return _buildLanguageStep(l10n);
      case 2:
        return _buildFinalStep(l10n);
      default:
        return const SizedBox.shrink();
    }
  }
  
  Widget _buildNameStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.whatShouldWeCallYou,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.personalizeExperience,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.yourName,
            hintText: l10n.nameHint,
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.nameValidation;
            }
            if (value.length < 2) {
              return l10n.nameMinLength;
            }
            return null;
          },
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }
  
  Widget _buildLanguageStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.choosePreferredLanguage,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.translationsInLanguage,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        
        // Language selection cards
        ...LanguageHelper.languageNames.map(
          (language) => _buildLanguageCard(language),
        ),
      ],
    );
  }
  
  Widget _buildLanguageCard(String language) {
    final isSelected = language == _selectedLanguage;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: isSelected ? 2 : 1,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLanguage = language;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFinalStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.almostThere(_nameController.text),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.reviewPreferences,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        
        // Summary card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                icon: Icons.person,
                title: l10n.name,
                value: _nameController.text,
              ),
              const Divider(),
              _buildSummaryRow(
                icon: Icons.language,
                title: l10n.language,
                value: _selectedLanguage,
              ),
              const Divider(),
              SwitchListTile(
                title: Text(l10n.darkMode),
                subtitle: Text(l10n.enableDarkTheme),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
                secondary: Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary.withOpacity(0.1),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.changeSettingsAnytime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSummaryRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}