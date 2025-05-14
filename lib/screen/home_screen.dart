import '../widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_task_tracker/models/tasks.dart';
import 'package:student_task_tracker/providers/task_provider.dart';
import 'package:student_task_tracker/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<TaskProvider>().loadTasks();
    });
  }

  void showTaskDialog({Task? task, int? index}) {
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    int selectedPriority = task?.priority ?? 1;
    DateTime selectedDate = task?.deadline ?? DateTime.now();

    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Theme.of(context).cardColor,

            child: Padding(
              padding: const EdgeInsets.all(24),
              child: StatefulBuilder(
                builder:
                    (context, setState) => SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                task != null ? Icons.edit : Icons.add_task,
                                color: Theme.of(context).colorScheme.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task != null ? 'Edit Task' : 'Add Task',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: titleCtrl,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: descCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              alignLabelWithHint: true,
                            ),
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: selectedPriority,
                            decoration: InputDecoration(
                              labelText: 'Priority',
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'High',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  'Medium',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text(
                                  'Low',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                            ],
                            onChanged:
                                (val) =>
                                    setState(() => selectedPriority = val ?? 1),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                builder:
                                    (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: Theme.of(
                                          context,
                                        ).colorScheme.copyWith(
                                          primary:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          onPrimary: Colors.white,
                                        ),
                                      ),
                                      child: child!,
                                    ),
                              );
                              if (picked != null) {
                                setState(() => selectedDate = picked);
                              }
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            label: Text(
                              "Deadline: ${selectedDate.toLocal().toString().split(' ')[0]}",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {
                                  if (titleCtrl.text.trim().isEmpty ||
                                      descCtrl.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Title and description are required!',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final newTask = Task(
                                    title: titleCtrl.text.trim(),
                                    description: descCtrl.text.trim(),
                                    priority: selectedPriority,
                                    deadline: selectedDate,
                                  );

                                  if (task != null && index != null) {
                                    context.read<TaskProvider>().updateTask(
                                      newTask,
                                      index,
                                    );
                                    _listKey.currentState?.setState(() {});
                                  } else {
                                    context.read<TaskProvider>().addTask(
                                      newTask,
                                    );
                                    _listKey.currentState?.insertItem(
                                      context
                                              .read<TaskProvider>()
                                              .tasks
                                              .length -
                                          1,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                  }

                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  task != null ? 'Save' : 'Add',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
    );
  }

  void _handleDelete(int index, Task task) {
    final removedTask = task;
    context.read<TaskProvider>().deleteTask(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: TaskTile(task: removedTask, onDelete: () {}, onEdit: () {}),
      ),
      duration: const Duration(milliseconds: 300),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task "${removedTask.title}" deleted',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            context.read<TaskProvider>().addTask(removedTask);
            _listKey.currentState?.insertItem(
              index,
              duration: const Duration(milliseconds: 300),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.sort,
              color: Theme.of(context).colorScheme.primary,
            ),
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
                  const PopupMenuItem(
                    value: 'priority',
                    child: Text(
                      'Sort by Priority',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'deadline',
                    child: Text(
                      'Sort by Deadline',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/flat-lay-notebook-with-list-desk.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child:
                  provider.tasks.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.task_alt,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tasks yet! Add one to get started.',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontFamily: 'Poppins',
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                      : AnimatedList(
                        key: _listKey,
                        padding: const EdgeInsets.all(16),
                        initialItemCount: provider.tasks.length,
                        itemBuilder: (context, index, animation) {
                          final task = provider.tasks[index];
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.5),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                            child: FadeTransition(
                              opacity: animation,
                              child: Card(
                                color: Colors.amberAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors:
                                          isDark
                                              ? [
                                                Colors.grey[900]!,
                                                Colors.grey[800]!,
                                              ]
                                              : [
                                                Colors.white,
                                                Colors.grey[100]!,
                                              ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TaskTile(
                                    task: task,
                                    onDelete: () => _handleDelete(index, task),
                                    onEdit:
                                        () => showTaskDialog(
                                          task: task,
                                          index: index,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () => showTaskDialog(),
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: CircleBorder(),
          elevation: 4,
        ),
      ),
    );
  }
}
