import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_task_tracker/models/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  List<Task> get tasks =>
      _filteredTasks.isNotEmpty || _searchQuery.isNotEmpty
          ? _filteredTasks
          : _tasks;

  String _searchQuery = ''; // Track current search query

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('tasks') ?? [];
    try {
      _tasks = data.map((e) => Task.fromJson(json.decode(e))).toList();
      _filteredTasks = List.from(_tasks); // Initialize with all tasks
    } catch (e) {
      print("Error loading tasks: $e");
      _tasks = [];
      _filteredTasks = [];
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
    searchTasks(_searchQuery); // Reapply search filter after adding
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      searchTasks(_searchQuery); // Reapply search filter after deletion
      saveTasks();
      notifyListeners();
    }
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
    searchTasks(_searchQuery); // Reapply search filter after sorting
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
    searchTasks(_searchQuery); // Reapply search filter after sorting
    notifyListeners();
  }

  void updateTask(Task updatedTask, int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      searchTasks(_searchQuery); // Reapply search filter after update
      saveTasks();
      notifyListeners();
    }
  }

  void searchTasks(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredTasks = List.from(_tasks); // Show all tasks if query is empty
    } else {
      _filteredTasks =
          _tasks
              .asMap()
              .entries
              .where(
                (entry) => entry.value.title.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .map((entry) => entry.value)
              .toList();
    }
    notifyListeners();
  }
}
