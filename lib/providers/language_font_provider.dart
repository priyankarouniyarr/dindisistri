import 'package:flutter/material.dart';

class LanguageFontProvider with ChangeNotifier {
  String _selectedLanguage = 'en';
  String _selectedFont = 'Roboto';

  String get selectedLanguage => _selectedLanguage;
  String get selectedFont => _selectedFont;

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void setFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }
}
