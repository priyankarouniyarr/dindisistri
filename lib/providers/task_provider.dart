import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:student_task_tracker/models/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TaskFilter { all, completed, pending }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  String _searchQuery = '';

  List<Task> get tasks =>
      _filteredTasks.isNotEmpty ||
              _searchQuery.isNotEmpty ||
              _currentFilter != TaskFilter.all
          ? _filteredTasks
          : _tasks;

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('tasks') ?? [];
    try {
      _tasks = data.map((e) => Task.fromJson(json.decode(e))).toList();
      _applyFilterAndSearch();
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
    tasks.add(task);
    _applyFilterAndSearch();
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      _applyFilterAndSearch();
      saveTasks();
      notifyListeners();
    }
  }

  void updateTask(Task updatedTask, int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      _applyFilterAndSearch();
      saveTasks();
      notifyListeners();
    }
  }

  void toggleCompleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = Task(
        title: _tasks[index].title,
        description: _tasks[index].description,
        priority: _tasks[index].priority,
        completed: !_tasks[index].completed,
        deadline: _tasks[index].deadline,
      );
      _applyFilterAndSearch();
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
    _applyFilterAndSearch();
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
    _applyFilterAndSearch();
    notifyListeners();
  }

  void filterTasks(TaskFilter filter) {
    _currentFilter = filter;
    _applyFilterAndSearch();
    notifyListeners();
  }

  void searchTasks(String query) {
    _searchQuery = query;
    _applyFilterAndSearch();
    notifyListeners();
  }

  void _applyFilterAndSearch() {
    List<Task> tempTasks = List.from(_tasks);

    // Apply status filter
    switch (_currentFilter) {
      case TaskFilter.completed:
        tempTasks = tempTasks.where((task) => task.completed).toList();
        break;
      case TaskFilter.pending:
        tempTasks = tempTasks.where((task) => !task.completed).toList();
        break;
      case TaskFilter.all:
      default:
        break;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      tempTasks =
          tempTasks
              .where(
                (task) => task.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }

    _filteredTasks = tempTasks;
  }
}
