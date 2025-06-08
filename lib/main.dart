import 'providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_task_tracker/splash_screen.dart';
import 'package:student_task_tracker/providers/noteprovider.dart';
import 'package:student_task_tracker/providers/language_font_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageFontProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' Daily Task Manager',
      themeMode: themeProvider.currentTheme,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
