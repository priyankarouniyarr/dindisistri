class Task {
  String title;
  String description;
  int priority;
  DateTime deadline;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
  });
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      priority: json['priority'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
    );
  }
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'priority': priority,
    'deadline': deadline.toIso8601String(),
  };
}
