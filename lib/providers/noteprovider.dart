import 'dart:convert';
import '../models/note.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> notes = [];
  bool showAll = false;

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesStringList = prefs.getStringList('notes') ?? [];

    notes =
        notesStringList.map((noteStr) {
          final map = jsonDecode(noteStr);
          return Note(content: map['content'], isVisible: map['isVisible']);
        }).toList();

    notifyListeners();
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesStringList =
        notes.map((note) {
          return jsonEncode({
            'content': note.content,
            'isVisible': note.isVisible,
          });
        }).toList();

    await prefs.setStringList('notes', notesStringList);
  }

  void addNote(String content) {
    notes.insert(0, Note(content: content, isVisible: false));
    saveNotes();
    notifyListeners();
  }

  void toggleVisibility(int index) {
    notes[index].isVisible = !notes[index].isVisible;
    saveNotes();
    notifyListeners();
  }

  void updateNote(int index, String content) {
    notes[index].content = content;
    saveNotes();
    notifyListeners();
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    saveNotes();
    notifyListeners();
  }

  void toggleShowAll() {
    showAll = !showAll;
    notifyListeners();
  }
}
