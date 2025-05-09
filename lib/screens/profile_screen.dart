import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/custom_button.dart';
import '../services/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  String? _imageUrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    if (user != null) {
      final names = user.displayName?.split(' ') ?? ['', ''];
      _firstNameController = TextEditingController(text: names[0]);
      _lastNameController = TextEditingController(text: names.length > 1 ? names[1] : '');
      _emailController = TextEditingController(text: user.email);
      _imageUrl = user.photoURL;
    } else {
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _emailController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _toggleEdit() async {
    if (_isEditing) {
      if (_formKey.currentState?.validate() ?? false) {
        try {
          final authService = context.read<AuthService>();
          final firstName = _firstNameController.text.trim();
          final lastName = _lastNameController.text.trim();
          final displayName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
          
          await authService.updateProfile(
            displayName: displayName,
            photoURL: _imageUrl,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          setState(() => _isEditing = false);
        } catch (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      }
    } else {
      setState(() => _isEditing = true);
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      
      // Show dialog for choosing between camera and gallery
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source == null) return;

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 600,
      );

      if (image == null) return;

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${context.read<AuthService>().currentUser?.uid ?? 'unknown'}.jpg');

      final File imageFile = File(image.path);
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update profile with new image URL
      setState(() {
        _imageUrl = downloadUrl;
      });

      // Update user profile in Firebase Auth
      await context.read<AuthService>().updateProfile(
        photoURL: downloadUrl,
      );

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile picture: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: screenSize.width * 0.1,
                        backgroundImage: _imageUrl != null
                            ? NetworkImage(_imageUrl!)
                            : null,
                        child: _imageUrl == null
                            ? Icon(
                                Icons.person,
                                size: screenSize.width * 0.1,
                                color: Colors.grey[400],
                              )
                            : null,
                      ),
                      if (_isEditing)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(screenSize.width * 0.01),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  
                  // User Name
                  if (_isEditing)
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      '${_firstNameController.text} ${_lastNameController.text}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: screenSize.height * 0.01),
                  
                  // User Email
                  Text(
                    _emailController.text,
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Stats Section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.04,
                vertical: screenSize.height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Courses',
                    '12',
                    Icons.school,
                    screenSize,
                    isSmallScreen,
                  ),
                  _buildStatItem(
                    context,
                    'Completed',
                    '8',
                    Icons.check_circle,
                    screenSize,
                    isSmallScreen,
                  ),
                  _buildStatItem(
                    context,
                    'Certificates',
                    '5',
                    Icons.card_membership,
                    screenSize,
                    isSmallScreen,
                  ),
                ],
              ),
            ),

            // Progress Section
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learning Progress',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildProgressCard(
                    context,
                    'Web Development',
                    0.7,
                    screenSize,
                    isSmallScreen,
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildProgressCard(
                    context,
                    'Mobile Development',
                    0.5,
                    screenSize,
                    isSmallScreen,
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildProgressCard(
                    context,
                    'Data Science',
                    0.3,
                    screenSize,
                    isSmallScreen,
                  ),
                ],
              ),
            ),

            // Recent Activity
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildActivityItem(
                    context,
                    'Completed Web Development Basics',
                    '2 hours ago',
                    Icons.check_circle,
                    Colors.green,
                    screenSize,
                    isSmallScreen,
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildActivityItem(
                    context,
                    'Started Mobile Development Course',
                    '1 day ago',
                    Icons.play_circle,
                    Colors.blue,
                    screenSize,
                    isSmallScreen,
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildActivityItem(
                    context,
                    'Earned Data Science Certificate',
                    '3 days ago',
                    Icons.card_membership,
                    Colors.orange,
                    screenSize,
                    isSmallScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Size screenSize,
    bool isSmallScreen,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: isSmallScreen ? screenSize.width * 0.06 : screenSize.width * 0.04,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: screenSize.height * 0.01),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    String title,
    double progress,
    Size screenSize,
    bool isSmallScreen,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            LinearProgressIndicator(
              value: progress,
              minHeight: screenSize.height * 0.01,
            ),
            SizedBox(height: screenSize.height * 0.005),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: TextStyle(
                fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String time,
    IconData icon,
    Color color,
    Size screenSize,
    bool isSmallScreen,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.02),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenSize.width * 0.02),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
              ),
            ),
            SizedBox(width: screenSize.width * 0.02),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.025 : screenSize.width * 0.015,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
