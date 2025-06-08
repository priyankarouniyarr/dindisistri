import 'package:flutter/material.dart';
import 'package:student_task_tracker/utilis/googlefonts.dart';
import 'package:student_task_tracker/providers/task_provider.dart';
import 'package:student_task_tracker/providers/language_font_provider.dart';

final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

Container Categories(
  BuildContext context,
  TaskProvider provider,
  LanguageFontProvider languageProvider,
) {
  return Container(
    alignment: Alignment.bottomRight,
    child: PopupMenuButton<String>(
      icon: Icon(
        Icons.filter_list,
        color: Theme.of(context).colorScheme.primary,
      ),
      onSelected: (value) {
        if (value == 'priority') {
          provider.sortTasksByPriority();
        } else if (value == 'deadline') {
          provider.sortTasksByDeadline();
        } else if (value == 'all') {
          provider.filterTasks(TaskFilter.all);
        } else if (value == 'completed') {
          provider.filterTasks(TaskFilter.completed);
        } else if (value == 'pending') {
          provider.filterTasks(TaskFilter.pending);
        }
        _listKey.currentState?.setState(() {});
      },
      itemBuilder:
          (_) => [
            PopupMenuItem(
              value: 'all',
              child: Text(
                'All Tasks',
                style: TextStyle(
                  fontFamily:
                      googleFontOptions[languageProvider.selectedFont]!()
                          .fontFamily,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'completed',
              child: Text(
                'Completed',
                style: TextStyle(
                  fontFamily:
                      googleFontOptions[languageProvider.selectedFont]!()
                          .fontFamily,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'pending',
              child: Text(
                'Pending',
                style: TextStyle(
                  fontFamily:
                      googleFontOptions[languageProvider.selectedFont]!()
                          .fontFamily,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'priority',
              child: Text(
                'Sort by Priority',
                style: TextStyle(
                  fontFamily:
                      googleFontOptions[languageProvider.selectedFont]!()
                          .fontFamily,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'deadline',
              child: Text(
                'Sort by Deadline',
                style: TextStyle(
                  fontFamily:
                      googleFontOptions[languageProvider.selectedFont]!()
                          .fontFamily,
                ),
              ),
            ),
          ],
    ),
  );
}
