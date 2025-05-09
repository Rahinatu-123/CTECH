import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth.dart';
import '../widgets/custom_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(4, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final otp = _otpControllers.map((c) => c.text).join();
      
      // TODO: Implement actual API call to verify OTP
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.pushNamed(
          context,
          '/reset-password',
          arguments: {
            'email': widget.email,
            'otp': otp,
          },
        );
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
          'Verify OTP',
          style: TextStyle(
            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.04),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Enter Verification Code',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.07 : screenSize.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Text(
                    'We\'ve sent a verification code to your email',
                    style: TextStyle(
                      fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),

                  // OTP Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: screenSize.width * 0.12,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.015,
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length == 1 && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Verify',
                      isLoading: _isLoading,
                      onPressed: _verifyOtp,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),

                  // Resend Code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code? ',
                        style: TextStyle(
                          fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                // TODO: Implement resend OTP
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('OTP resent successfully'),
                                  ),
                                );
                              },
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: isSmallScreen ? screenSize.width * 0.035 : screenSize.width * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
