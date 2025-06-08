class Task {
  final String title;
  final String description;
  final int priority;
  //final bool completed; // Add this line
  final DateTime deadline;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    // required this.completed, // Add this line
    required this.deadline,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      priority: json['priority'],
      description: json['description'],
      //  completed: json['completed'] ?? false, // Add this line
      deadline: DateTime.parse(json['deadline']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'priority': priority,
    //'completed': completed, // Add this line
    'deadline': deadline.toIso8601String(),
  };
}
