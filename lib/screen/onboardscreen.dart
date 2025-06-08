import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_task_tracker/utilis/googlefonts.dart';
import 'package:student_task_tracker/screen/appmain_Screen.dart';
import 'package:student_task_tracker/providers/language_font_provider.dart';

class CustomOnboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageFontProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      // light background
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                child: Image.asset(
                  'assets/images/picture.jpg',
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: "Plan your day\nwith "),
                      TextSpan(
                        text: "Todo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          backgroundColor: Color(0xFFFFF1A5),
                          color: Colors.blue,
                          fontFamily:
                              googleFontOptions[languageProvider
                                      .selectedFont]!()
                                  .fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Simply add tasks, Delete tasks, Edit tasks & much more!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 117, 114, 114),
                    fontFamily:
                        googleFontOptions[languageProvider.selectedFont]!()
                            .fontFamily,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to home or next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AppMainScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Let's Go",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily:
                              googleFontOptions[languageProvider
                                      .selectedFont]!()
                                  .fontFamily,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.play_arrow, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
