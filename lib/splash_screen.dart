import 'dart:async';
import 'package:flutter/material.dart';
import 'package:student_task_tracker/screen/onboardscreen.dart';
import 'package:student_task_tracker/screen/appmain_Screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start the logo fade-in animation slowly
    Timer(Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to next screen after delay
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => CustomOnboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 120, 81, 176),
              Color.fromARGB(255, 81, 26, 190),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(seconds: 3), // slower scale
            curve: Curves.easeOutExpo, // smoother appearance
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: AnimatedOpacity(
                  duration: Duration(seconds: 3), // slower fade
                  opacity: _opacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo.png', height: 130),
                      SizedBox(height: 25),
                      Text(
                        "Din Dristri",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Track. Plan. Succeed.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
