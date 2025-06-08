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
      icon: Icon(Icons.sort, color: Theme.of(context).colorScheme.primary),
      onSelected: (value) {
        if (value == 'priority') {
          provider.sortTasksByPriority();
        } else if (value == 'deadline') {
          provider.sortTasksByDeadline();
        }
        _listKey.currentState?.setState(() {});
      },
      itemBuilder:
          (_) => [
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
