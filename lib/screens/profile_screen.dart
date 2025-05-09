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

  Widget _buildActivityCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () => _toggleEdit(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isEditing ? _pickImage : null,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            backgroundImage: _imageUrl != null
                                ? _imageUrl!.startsWith('http')
                                    ? NetworkImage(_imageUrl!) as ImageProvider
                                    : FileImage(File(_imageUrl!))
                                : null,
                            child: _imageUrl == null
                                ? const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          if (_isEditing)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _firstNameController,
                      enabled: _isEditing,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      enabled: _isEditing,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      enabled: false, // Email can't be changed directly
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        helperText: 'Email cannot be changed directly',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildActivityCard(
                context,
                'Tech Words',
                '12 words contributed',
                Icons.book,
                Colors.green,
                () => Navigator.pushNamed(context, '/tech-words'),
              ),
              const SizedBox(height: 16),
              _buildActivityCard(
                context,
                'Success Stories',
                '3 stories shared',
                Icons.star,
                Colors.amber,
                () => Navigator.pushNamed(context, '/stories'),
              ),
              const SizedBox(height: 16),
              _buildActivityCard(
                context,
                'Career Quiz',
                'Last taken: 2 days ago',
                Icons.quiz,
                Colors.blue,
                () => Navigator.pushNamed(context, '/quiz'),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Log Out',
                isOutlined: true,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
