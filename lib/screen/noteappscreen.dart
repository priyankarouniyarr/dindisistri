import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/noteprovider.dart';

class NoteAppScreen extends StatefulWidget {
  @override
  _NoteAppScreenState createState() => _NoteAppScreenState();
}

class _NoteAppScreenState extends State<NoteAppScreen> {
  bool showHiddenNotes = false;

  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  TextEditingController _getController(int index, String text) {
    if (_controllers.containsKey(index)) {
      return _controllers[index]!;
    } else {
      final controller = TextEditingController(text: text);
      _controllers[index] = controller;
      return controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => NoteProvider()..loadNotes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Notes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: theme.primaryColor,
          elevation: 6,
          shadowColor: theme.primaryColor.withOpacity(0.5),
          actions: [
            IconButton(
              icon: Icon(
                showHiddenNotes ? Icons.visibility : Icons.visibility_off,
                size: 24,
              ),
              tooltip:
                  showHiddenNotes ? 'Hide Hidden Notes' : 'Show Hidden Notes',
              onPressed: () {
                setState(() {
                  showHiddenNotes = !showHiddenNotes;
                });
              },
            ),
            SizedBox(width: 8),
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Consumer<NoteProvider>(
                builder: (context, provider, _) {
                  final controller = TextEditingController();
                  return Material(
                    elevation: 3,
                    shadowColor: Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: controller,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write a new note...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: theme.primaryColor,
                            size: 22,
                          ),
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              provider.addNote(controller.text.trim());
                              controller.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Notes Grid
            Expanded(
              child: Consumer<NoteProvider>(
                builder: (_, provider, __) {
                  final visibleNotes =
                      showHiddenNotes
                          ? provider.notes
                          : provider.notes
                              .where((note) => note.isVisible)
                              .toList();

                  if (visibleNotes.isEmpty) {
                    return Center(
                      child: Text(
                        'No notes to display.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1 / 1.3,
                      ),
                      itemCount: visibleNotes.length,
                      itemBuilder: (context, index) {
                        final note = visibleNotes[index];
                        final originalIndex = provider.notes.indexOf(note);
                        final controller = _getController(
                          originalIndex,
                          note.content,
                        );

                        return Material(
                          elevation: 6,
                          shadowColor: Colors.black38,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  note.isVisible
                                      ? Colors.white
                                      : Colors.grey.shade200,
                              border: Border.all(
                                color:
                                    note.isVisible
                                        ? theme.primaryColor.withOpacity(0.3)
                                        : Colors.grey[400]!,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child:
                                      note.isVisible
                                          ? TextField(
                                            controller: controller,
                                            maxLines: null,
                                            expands: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[900],
                                              height: 1.3,
                                              fontWeight: FontWeight.w500,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(0.2, 0.2),
                                                  blurRadius: 1,
                                                  color: Colors.black12,
                                                ),
                                              ],
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Edit your note...',
                                              hintStyle: TextStyle(
                                                color: Colors.grey[400],
                                                fontStyle: FontStyle.italic,
                                              ),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          )
                                          : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.lock_outline,
                                                  color: Colors.grey[500],
                                                  size: 26,
                                                ),
                                                SizedBox(height: 6),
                                                Text(
                                                  'Hidden',
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16,
                                                    color: Colors.grey[500],
                                                    letterSpacing: 1.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: theme.primaryColor,
                                      size: 22,
                                    ),
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'toggle_visibility':
                                          provider.toggleVisibility(
                                            originalIndex,
                                          );
                                          break;
                                        case 'save':
                                          if (note.isVisible) {
                                            provider.updateNote(
                                              originalIndex,
                                              controller.text.trim(),
                                            );
                                          }
                                          break;
                                        case 'delete':
                                          provider.deleteNote(originalIndex);
                                          _controllers[originalIndex]
                                              ?.dispose();
                                          _controllers.remove(originalIndex);
                                          break;
                                      }
                                    },
                                    itemBuilder:
                                        (context) => [
                                          PopupMenuItem(
                                            value: 'toggle_visibility',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  note.isVisible
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  note.isVisible
                                                      ? 'Hide Note'
                                                      : 'Show Note',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (note.isVisible)
                                            PopupMenuItem(
                                              value: 'save',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.save,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    'Save',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
