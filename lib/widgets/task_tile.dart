import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_task_tracker/models/tasks.dart';
import 'package:student_task_tracker/utilis/googlefonts.dart';
import 'package:student_task_tracker/providers/language_font_provider.dart';

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

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggleComplete;

  const TaskTile({
    required this.task,
    required this.index,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageFontProvider>(context);

    return Dismissible(
      key: Key(task.title.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: ListTile(
          leading: Checkbox(
            value: task.completed,
            onChanged: (value) => onToggleComplete(),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily:
                  googleFontOptions[languageProvider.selectedFont]!()
                      .fontFamily,
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily:
                    googleFontOptions[languageProvider.selectedFont]!()
                        .fontFamily,
              ),
              children: [
                TextSpan(text: '${task.description}\n'),
                TextSpan(
                  text: 'Priority: ${getPriorityLabel(task.priority)}\n',
                ),
                TextSpan(
                  text:
                      'Deadline: ${task.deadline.toLocal().toString().split(" ")[0]}',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.view_agenda, color: Colors.deepPurple),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}
