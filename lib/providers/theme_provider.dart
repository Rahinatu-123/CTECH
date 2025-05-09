import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  static const darkBlue = Color(0xFF0A2A36);

  bool get isDarkMode => _isDarkMode;

  static final lightTheme = ThemeData(
    primaryColor: darkBlue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: darkBlue,
      secondary: darkBlue,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    dividerColor: Colors.grey[300],
  );

  static final darkTheme = ThemeData(
    primaryColor: darkBlue,
    scaffoldBackgroundColor: darkBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black12,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.white70,
      surface: Colors.black12,
      onSurface: Colors.white,
    ),
    dividerColor: Colors.white24,
  );

  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
