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
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    required this.task,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageFontProvider>(context);

    return Dismissible(
      key: Key(task.title?.toString() ?? ''),
      direction: DismissDirection.endToStart,

      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily:
                  googleFontOptions[languageProvider.selectedFont]!()
                      .fontFamily,
            ),
          ),
          subtitle: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
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
                  style: const TextStyle(
                    color: Color.fromARGB(255, 98, 95, 247),
                  ),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.view_agenda, color: Colors.deepPurple),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}
