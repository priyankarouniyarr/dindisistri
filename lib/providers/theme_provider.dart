import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // The current theme mode (system, dark, light)
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  // This property will help determine if the current theme is dark
  bool get isDark => _currentTheme == ThemeMode.dark;

  // Method to toggle between light, dark, and system themes
  void toggleTheme() {
    // Cycles through the themes (system -> light -> dark -> system -> ...)
    if (_currentTheme == ThemeMode.system) {
      _currentTheme = ThemeMode.light;
    } else if (_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;
    } else {
      _currentTheme = ThemeMode.system;
    }
    notifyListeners();
  }
}
