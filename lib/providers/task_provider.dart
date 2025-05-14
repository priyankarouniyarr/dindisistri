import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_task_tracker/models/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('tasks') ?? [];
    try {
      _tasks = data.map((e) => Task.fromJson(json.decode(e))).toList();
    } catch (e) {
      print("Error loading tasks: $e");
      _tasks = [];
    }
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _tasks.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('tasks', data);
  }

  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    saveTasks();
    notifyListeners();
  }

  void sortTasksByPriority() {
    for (int i = 0; i < _tasks.length - 1; i++) {
      for (int j = 0; j < _tasks.length - i - 1; j++) {
        if (_tasks[j].priority > _tasks[j + 1].priority) {
          var temp = _tasks[j];
          _tasks[j] = _tasks[j + 1];
          _tasks[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }

  void sortTasksByDeadline() {
    for (int i = 0; i < _tasks.length - 1; i++) {
      for (int j = 0; j < _tasks.length - i - 1; j++) {
        if (_tasks[j].deadline.isAfter(_tasks[j + 1].deadline)) {
          var temp = _tasks[j];
          _tasks[j] = _tasks[j + 1];
          _tasks[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }

  void updateTask(Task updatedTask, int index) {
    _tasks[index] = updatedTask;
    saveTasks();
    notifyListeners();
  }
}
