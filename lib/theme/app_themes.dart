import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade100,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.tealAccent.shade100,
      foregroundColor: Colors.black,
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.tealAccent,
      foregroundColor: Colors.black,
    ),
  );
}
