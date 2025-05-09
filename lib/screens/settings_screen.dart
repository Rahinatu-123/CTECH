import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth.dart';
// import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final NotificationService _notificationService = NotificationService();
  // bool _notificationsEnabled = true;
  bool _isLoading = false;

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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            _buildSettingsCard(
              context,
              [
                _buildSettingsItem(
                  context,
                  'Edit Profile',
                  Icons.person,
                  () => Navigator.pushNamed(context, '/profile'),
                  screenSize,
                  isSmallScreen,
                ),
                _buildDivider(screenSize),
                _buildSettingsItem(
                  context,
                  'Change Password',
                  Icons.lock,
                  () => Navigator.pushNamed(context, '/reset-password'),
                  screenSize,
                  isSmallScreen,
                ),
                _buildDivider(screenSize),
                _buildSettingsItem(
                  context,
                  'Notification Preferences',
                  Icons.notifications,
                  () {
                    // Navigate to notification settings
                  },
                  screenSize,
                  isSmallScreen,
                ),
              ],
              screenSize,
            ),

            // App Settings
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Text(
                'App Settings',
                style: TextStyle(
                  fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            _buildSettingsCard(
              context,
              [
                _buildSettingsItem(
                  context,
                  'Language',
                  Icons.language,
                  () {
                    // Show language selection dialog
                  },
                  screenSize,
                  isSmallScreen,
                  trailing: Text(
                    'English',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                _buildDivider(screenSize),
                _buildSettingsItem(
                  context,
                  'Theme',
                  Icons.palette,
                  () {
                    // Show theme selection dialog
                  },
                  screenSize,
                  isSmallScreen,
                  trailing: Text(
                    'System Default',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                _buildDivider(screenSize),
                _buildSettingsItem(
                  context,
                  'Data Usage',
                  Icons.data_usage,
                  () {
                    // Navigate to data usage settings
                  },
                  screenSize,
                  isSmallScreen,
                ),
              ],
              screenSize,
            ),

            // Support
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Text(
                'Support',
                style: TextStyle(
                  fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            _buildSettingsCard(
              context,
              [
                _buildSettingsItem(
                  context,
                  'Help Center',
                  Icons.help,
                  () {
                    // Navigate to help center
                  },
                  screenSize,
                  isSmallScreen,
                ),
                _buildDivider(screenSize),
                _buildSettingsItem(
                  context,
                  'Contact Support',
                  Icons.support,
                  () {
                    // Navigate to contact support
                  },
                  screenSize,
                  isSmallScreen,
                ),
                _buildDivider(screenSize),
                _buildSettingsItem(
                  context,
                  'About',
                  Icons.info,
                  () {
                    // Show about dialog
                  },
                  screenSize,
                  isSmallScreen,
                ),
              ],
              screenSize,
            ),

            // Logout Button
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final authService = context.read<AuthService>();
                      await authService.signOut();
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.015,
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    List<Widget> children,
    Size screenSize,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.01,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    Size screenSize,
    bool isSmallScreen, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right,
        size: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(Size screenSize) {
    return Divider(
      height: screenSize.height * 0.001,
      thickness: screenSize.height * 0.001,
    );
  }
}
