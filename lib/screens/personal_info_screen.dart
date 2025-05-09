import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/auth.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = context.read<AuthService>().currentUser;
    if (user != null) {
      final names = user.displayName?.split(' ') ?? ['', ''];
      setState(() {
        _firstNameController.text = names[0];
        _lastNameController.text = names.length > 1 ? names[1] : '';
        // Load other user data if available
      });
    }
  }

  Future<void> _savePersonalInfo() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final firstName = _firstNameController.text.trim();
        final lastName = _lastNameController.text.trim();
        final displayName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
        
        await context.read<AuthService>().updateProfile(
          displayName: displayName,
        );
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personal information updated successfully')),
        );
        Navigator.pop(context);
      } catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: screenSize.width * 0.1,
                        backgroundImage: context.read<AuthService>().currentUser?.photoURL != null
                            ? NetworkImage(context.read<AuthService>().currentUser!.photoURL!)
                            : null,
                        child: context.read<AuthService>().currentUser?.photoURL == null
                            ? Icon(
                                Icons.person,
                                size: screenSize.width * 0.1,
                                color: Colors.grey[400],
                              )
                            : null,
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      TextButton.icon(
                        onPressed: () {
                          // Handle profile picture change
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Change Profile Picture'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Personal Information Form
                Text(
                  'Basic Information',
                  style: TextStyle(
                    fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                
                // Name Fields
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _firstNameController,
                        labelText: 'First Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: screenSize.width * 0.02),
                    Expanded(
                      child: CustomTextField(
                        controller: _lastNameController,
                        labelText: 'Last Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Contact Information
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Location
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                
                CustomTextField(
                  controller: _locationController,
                  labelText: 'City, Country',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Bio
                Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: isSmallScreen ? screenSize.width * 0.04 : screenSize.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                
                CustomTextField(
                  controller: _bioController,
                  labelText: 'Bio',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your bio';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Save Button
                Center(
                  child: CustomButton(
                    onPressed: _isLoading ? () {} : () {
                      _savePersonalInfo();
                    },
                    text: _isLoading ? 'Saving...' : 'Save Changes',
                    width: screenSize.width * 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
