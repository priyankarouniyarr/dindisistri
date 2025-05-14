import 'providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_task_tracker/splash_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      title: 'Task Manager',
      themeMode: themeProvider.currentTheme, // Set theme mode based on provider
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
