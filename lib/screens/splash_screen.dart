import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash for 2 seconds
    if (!mounted) return;

    // Use Provider to get auth state changes
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0A2A36);
    
    return Scaffold(
      backgroundColor: darkBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App name
              const Text(
                'CTECH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 16),
              // Motto
              const Text(
                'Ignite Your Passion For Tech',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 8),
              // Accent underline
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
