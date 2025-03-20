// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../models/achievement_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.preferences;
        if (user == null) return const Center(child: CircularProgressIndicator());

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Display email if user is logged in with an account
                        if (authProvider.user != null && !authProvider.user!.isAnonymous && authProvider.user!.email != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              authProvider.user!.email!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${user.streakDays} Day Streak',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Learning Stats Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Learning Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatTile(
                            icon: Icons.school,
                            title: 'Flashcards Learned',
                            value: user.totalFlashcardsLearned.toString(),
                          ),
                          const Divider(),
                          _buildStatTile(
                            icon: Icons.quiz,
                            title: 'Quizzes Completed',
                            value: user.quizScores.length.toString(),
                          ),
                          if (user.quizScores.isNotEmpty) ...[
                            const Divider(),
                            _buildStatTile(
                              icon: Icons.emoji_events,
                              title: 'Average Quiz Score',
                              value: '${_calculateAverageQuizScore(user.quizScores)}%',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Achievements Section
                  const Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  user.achievements.isEmpty
                      ? _buildEmptyAchievements()
                      : _buildAchievementsList(user.achievements),
                  
                  const SizedBox(height: 24),
                  
                  // Personal Information Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.language),
                            title: const Text('Preferred Language'),
                            subtitle: Text(user.preferredLanguage),
                          ),
                          SwitchListTile(
                            title: const Text('Dark Mode'),
                            subtitle: Text(user.isDarkMode ? 'On' : 'Off'),
                            value: user.isDarkMode,
                            onChanged: (bool value) {
                              userProvider.updateDarkMode(value);
                            },
                            secondary: const Icon(Icons.dark_mode),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // Add to your profile_screen.dart, right before the last Card (App Information)
const SizedBox(height: 24),

// Account Actions Card
Card(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Show reset confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Reset Progress'),
                content: const Text('Are you sure you want to reset all your learning progress? This action cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Reset progress logic here
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset Progress'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[100],
            foregroundColor: Colors.amber[900],
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () async {
            await Provider.of<AuthProvider>(context, listen: false).signOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[100],
            foregroundColor: Colors.blue[900],
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            // Show delete account confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Account'),
                content: const Text('Are you sure you want to delete your account? All your data will be permanently lost. This action cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Delete account logic here
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.delete_forever),
          label: const Text('Delete Account'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[100],
            foregroundColor: Colors.red[900],
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    ),
  ),
),
                  // App Information Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'App Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text('Version'),
                            subtitle: Text('1.0.0'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Sign Out Button
                  if (authProvider.user != null) 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await authProvider.signOut();
                            if (context.mounted) {
                              // Navigate back to login screen
                              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red[800],
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign Out'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAchievements() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No achievements yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep learning to earn achievements!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(List<Achievement> achievements) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    IconData iconData;
    switch (achievement.iconName) {
      case 'school':
        iconData = Icons.school;
        break;
      case 'emoji_events':
        iconData = Icons.emoji_events;
        break;
      case 'local_fire_department':
        iconData = Icons.local_fire_department;
        break;
      case 'quiz':
        iconData = Icons.quiz;
        break;
      case 'workspace_premium':
        iconData = Icons.workspace_premium;
        break;
      default:
        iconData = Icons.emoji_events;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 36,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  int _calculateAverageQuizScore(Map<String, double> quizScores) {
    if (quizScores.isEmpty) return 0;
    
    double totalScore = 0;
    for (final score in quizScores.values) {
      totalScore += score;
    }
    
    return (totalScore / quizScores.length).round();
  }
}