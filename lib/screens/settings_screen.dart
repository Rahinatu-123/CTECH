import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
// import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final NotificationService _notificationService = NotificationService();
  // bool _notificationsEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _loadNotificationSettings();
    _isLoading = false; // fallback since loading notifications is disabled
  }

  // Future<void> _loadNotificationSettings() async {
  //   final enabled = await _notificationService.isNotificationsEnabled();
  //   if (mounted) {
  //     setState(() {
  //       _notificationsEnabled = enabled;
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _toggleNotifications(bool value) async {
  //   setState(() {
  //     _notificationsEnabled = value;
  //   });
  //   await _notificationService.setNotificationsEnabled(value);
    
  //   if (value) {
  //     // Show a test notification when enabling
  //     await _notificationService.showNotification(
  //       title: 'Notifications Enabled',
  //       body: 'You will now receive updates about tech careers and learning opportunities.',
  //     );
  //   }
  // }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement account deletion
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  'Appearance',
                  [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: Text(
                        themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                  ],
                ),
                const Divider(),
                // Notification section commented out
                // _buildSection(
                //   'Notifications',
                //   [
                //     SwitchListTile(
                //       title: const Text('Push Notifications'),
                //       subtitle: Text(
                //         _notificationsEnabled
                //             ? 'You will receive notifications'
                //             : 'Notifications are disabled',
                //         style: const TextStyle(fontSize: 14),
                //       ),
                //       value: _notificationsEnabled,
                //       onChanged: _toggleNotifications,
                //     ),
                //     if (_notificationsEnabled) ...[
                //       ListTile(
                //         title: const Text('Test Quiz Reminder'),
                //         subtitle: const Text('Send a test quiz reminder notification'),
                //         trailing: const Icon(Icons.notifications),
                //         onTap: () => _notificationService.showQuizReminder(),
                //       ),
                //       ListTile(
                //         title: const Text('Test Career Update'),
                //         subtitle: const Text('Send a test career update notification'),
                //         trailing: const Icon(Icons.work),
                //         onTap: () => _notificationService.showCareerUpdate(),
                //       ),
                //       ListTile(
                //         title: const Text('Test Tech Word'),
                //         subtitle: const Text('Send a test tech word notification'),
                //         trailing: const Icon(Icons.book),
                //         onTap: () => _notificationService.showTechWordOfTheDay(),
                //       ),
                //     ],
                //   ],
                // ),
                // const Divider(),
                _buildSection(
                  'Account',
                  [
                    ListTile(
                      title: const Text('Delete Account'),
                      subtitle: const Text(
                        'Permanently delete your account and all data',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.warning, color: Colors.red),
                      onTap: () => _showDeleteAccountDialog(context),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
