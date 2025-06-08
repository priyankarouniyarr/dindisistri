import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_task_tracker/models/tasks.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:student_task_tracker/screen/categories.dart';
import 'package:student_task_tracker/widgets/task_tile.dart';
import 'package:student_task_tracker/utilis/googlefonts.dart';
import 'package:student_task_tracker/widgets/custom_drawer.dart';
import 'package:student_task_tracker/providers/task_provider.dart';
import 'package:student_task_tracker/providers/theme_provider.dart';
import 'package:student_task_tracker/providers/language_font_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _speechField = 'title';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<TaskProvider>().loadTasks();
    });
    _searchController.addListener(() {
      context.read<TaskProvider>().searchTasks(_searchController.text);
    });
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus:
          (status) => setState(() => _isListening = status == 'listening'),
      onError:
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could Not Initialize Speech Recognition'),
              backgroundColor: Colors.redAccent,
            ),
          ),
    );
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speech.stop();
    super.dispose();
  }

  void showTaskDialog({Task? task, int? index}) {
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    int selectedPriority = task?.priority ?? 1;
    DateTime selectedDate = task?.deadline ?? DateTime.now();
    final languageProvider = Provider.of<LanguageFontProvider>(
      context,
      listen: false,
    );

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
                                  fontFamily:
                                      googleFontOptions[languageProvider
                                              .selectedFont]!()
                                          .fontFamily,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: titleCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    filled: true,
                                    fillColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily:
                                        googleFontOptions[languageProvider
                                                .selectedFont]!()
                                            .fontFamily,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isListening && _speechField == 'title'
                                      ? Icons.mic
                                      : Icons.mic_none,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed:
                                    () => _startListening(
                                      titleCtrl,
                                      setState,
                                      'title',
                                    ),
                                tooltip: 'Dictate Title',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: descCtrl,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    filled: true,
                                    fillColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceVariant,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    alignLabelWithHint: true,
                                  ),
                                  style: TextStyle(
                                    fontFamily:
                                        googleFontOptions[languageProvider
                                                .selectedFont]!()
                                            .fontFamily,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isListening && _speechField == 'description'
                                      ? Icons.mic
                                      : Icons.mic_none,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed:
                                    () => _startListening(
                                      descCtrl,
                                      setState,
                                      'description',
                                    ),
                                tooltip: 'Dictate Description',
                              ),
                            ],
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
                            items: [
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'High',
                                  style: TextStyle(
                                    fontFamily:
                                        googleFontOptions[languageProvider
                                                .selectedFont]!()
                                            .fontFamily,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  'Medium',
                                  style: TextStyle(
                                    fontFamily:
                                        googleFontOptions[languageProvider
                                                .selectedFont]!()
                                            .fontFamily,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text(
                                  'Low',
                                  style: TextStyle(
                                    fontFamily:
                                        googleFontOptions[languageProvider
                                                .selectedFont]!()
                                            .fontFamily,
                                  ),
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
                                fontFamily:
                                    googleFontOptions[languageProvider
                                            .selectedFont]!()
                                        .fontFamily,
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
                                onPressed: () {
                                  _speech.stop();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily:
                                        googleFontOptions[languageProvider
                                                .selectedFont]!()
                                            .fontFamily,
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
                                        content: Text(
                                          'Title and description are required!',
                                          style: TextStyle(
                                            fontFamily:
                                                googleFontOptions[languageProvider
                                                        .selectedFont]!()
                                                    .fontFamily,
                                          ),
                                        ),
                                        backgroundColor: Colors.redAccent,
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
                                    final originalIndex = context
                                        .read<TaskProvider>()
                                        .tasks
                                        .indexOf(task);
                                    if (originalIndex != -1) {
                                      context.read<TaskProvider>().updateTask(
                                        newTask,
                                        originalIndex,
                                      );
                                    }
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

                                  _speech.stop();
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
                                    fontFamily:
                                        googleFontOptions[languageProvider
                                                .selectedFont]!()
                                            .fontFamily,
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

  void _startListening(
    TextEditingController controller,
    StateSetter setState,
    String field,
  ) {
    if (_isListening && _speechField == field) {
      _speech.stop();
      setState(() => _isListening = false);
    } else {
      _speechField = field;
      _speech.listen(
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
            if (result.finalResult) {
              _isListening = false;
            }
          });
        },
        localeId: 'en_US',
      );
      setState(() => _isListening = true);
    }
  }

  void _handleDelete(int index, Task task) {
    final provider = context.read<TaskProvider>();
    final originalIndex = provider.tasks.indexOf(task);
    if (originalIndex == -1) return;

    final removedTask = task;
    provider.deleteTask(originalIndex);

    if (index < _listKey.currentState!.widget.initialItemCount) {
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: TaskTile(task: removedTask, onDelete: () {}, onEdit: () {}),
        ),
        duration: const Duration(milliseconds: 300),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task "${removedTask.title}" deleted',
          style: TextStyle(
            fontFamily:
                googleFontOptions[Provider.of<LanguageFontProvider>(
                      context,
                      listen: false,
                    ).selectedFont]!()
                    .fontFamily,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            provider.addTask(removedTask);
            _listKey.currentState?.insertItem(
              originalIndex,
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
    final languageProvider = Provider.of<LanguageFontProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Todo List',
          style: TextStyle(
            fontFamily:
                googleFontOptions[languageProvider.selectedFont]!().fontFamily,
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
        ],
      ),
      drawer: CustomDrawer(
        selectedFont: languageProvider.selectedFont,
        onFontChanged: languageProvider.setFont,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/picture1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by title...',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily:
                            googleFontOptions[languageProvider.selectedFont]!()
                                .fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Categories(context, provider, languageProvider),
                  const SizedBox(width: 10),
                ],
              ),
            ),
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
                                fontFamily:
                                    googleFontOptions[languageProvider
                                            .selectedFont]!()
                                        .fontFamily,
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
                          if (index >= provider.tasks.length)
                            return const SizedBox.shrink();
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
          shape: const CircleBorder(),
          elevation: 4,
        ),
      ),
    );
  }
}
