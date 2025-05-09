import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String email;
  final String password;

  const PersonalInfoScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitPersonalInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        
        // Update the user's profile with additional information
        await authService.updateProfile(
          displayName: '${_firstNameController.text} ${_lastNameController.text}',
        );

        // TODO: Store additional user information in Firestore
        // You might want to create a users collection to store the phone number
        // and other user details

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0A2A36);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24, top: 36, bottom: 36, right: 24),
              decoration: const BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(48),
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            // Form Card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // First Name Field
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Last Name Field
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Phone Field
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 32),
                        // Complete Registration Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitPersonalInfo,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: darkBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Complete Registration',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
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
}
