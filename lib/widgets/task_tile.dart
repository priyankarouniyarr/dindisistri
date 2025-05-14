import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:student_task_tracker/models/tasks.dart';

String getPriorityLabel(int priority) {
  switch (priority) {
    case 1:
      return 'High';
    case 2:
      return 'Medium';
    case 3:
      return 'Low';
    default:
      return 'Unknown';
  }
}

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    required this.task,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.task.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        subtitle: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.grey), // default style
            children: [
              TextSpan(text: '${widget.task.description}\n'),

              TextSpan(
                text: 'Priority: ${getPriorityLabel(widget.task.priority)}\n',
              ),
              TextSpan(
                text:
                    'Deadline: ${widget.task.deadline.toLocal().toString().split(" ")[0]}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 98, 95, 247),
                ), // 👈 blue for deadline
              ),
            ],
          ),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: widget.onEdit, // Edit button
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onDelete, // Delete button
            ),
          ],
        ),
        onTap: widget.onEdit, // Task tile tap to view or edit
      ),
    );
  }
}
