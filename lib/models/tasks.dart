class Task {
  final String title;
  final String description;
  final int priority;
  final bool completed;
  final DateTime deadline;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.completed,
    required this.deadline,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      completed: json['completed'] ?? false,
      deadline: DateTime.parse(json['deadline']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'priority': priority,
    'completed': completed,
    'deadline': deadline.toIso8601String(),
  };
}
