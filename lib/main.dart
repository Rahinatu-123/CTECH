import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/theme_provider.dart';
import 'services/auth.dart';
// import 'services/notification_service.dart'; // Notification service import commented
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/stories_screen.dart';
import 'screens/tech_words_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/career_details_screen.dart';
import 'screens/career_screen.dart';
import 'screens/verify_otp_screen.dart';
import 'screens/reset_password_screen.dart';

import 'models/career.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize notification service
  // final notificationService = NotificationService(); // Commented notification service instance
  // await notificationService.initialize(); // Commented notification initialization

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authState = context.watch<User?>();

    // If user is already authenticated, show home screen
    if (authState != null) {
      debugPrint('User is authenticated, showing HomeScreen');
      return MaterialApp(
        title: 'CTech',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.theme,
        home: const HomeScreen(),
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/') == true) {
            switch (settings.name) {
              case '/quiz':
                return MaterialPageRoute(
                  builder: (_) => const QuizScreen(),
                  settings: settings,
                );
              case '/careers':
                return MaterialPageRoute(
                  builder: (_) => const CareerScreen(),
                  settings: settings,
                );
              case '/tech-words':
                return MaterialPageRoute(
                  builder: (_) => const TechWordsScreen(),
                  settings: settings,
                );
              case '/settings':
                return MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                  settings: settings,
                );
              case '/career-details':
                final career = settings.arguments as Career;
                return MaterialPageRoute(
                  builder: (_) => CareerDetailsScreen(career: career),
                  settings: settings,
                );
              default:
                return null;
            }
          }
          return null;
        },
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/career': (context) => const CareerScreen(),
          '/stories': (context) => const StoriesScreen(),
          '/tech-words': (context) => const TechWordsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/verify-otp': (context) => VerifyOtpScreen(
                email: ModalRoute.of(context)!.settings.arguments as String,
              ),
          '/reset-password': (context) => ResetPasswordScreen(
                email: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['email']!,
                otp: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['otp']!,
              ),
        },
      );
    }

    // Show splash screen for initial load
    return MaterialApp(
      title: 'CTech',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.theme,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/') == true) {
          switch (settings.name) {
            case '/quiz':
              return MaterialPageRoute(
                builder: (_) => const QuizScreen(),
                settings: settings,
              );
            case '/careers':
              return MaterialPageRoute(
                builder: (_) => const CareerScreen(),
                settings: settings,
              );
            case '/tech-words':
              return MaterialPageRoute(
                builder: (_) => const TechWordsScreen(),
                settings: settings,
              );
            case '/settings':
              return MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
                settings: settings,
              );
            case '/career-details':
              final career = settings.arguments as Career;
              return MaterialPageRoute(
                builder: (_) => CareerDetailsScreen(career: career),
                settings: settings,
              );
            default:
              return null;
          }
        }
        return null;
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/career': (context) => const CareerScreen(),
        '/stories': (context) => const StoriesScreen(),
        '/tech-words': (context) => const TechWordsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/verify-otp': (context) => VerifyOtpScreen(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/reset-password': (context) => ResetPasswordScreen(
              email: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['email']!,
              otp: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['otp']!,
            ),
      },
    );
  }
}
