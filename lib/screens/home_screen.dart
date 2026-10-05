import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/task_repository.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// True if the search text appears in any field of the task.
  bool _matches(Task t, String q) {
    final haystack = [
      t.title,
      t.description,
      t.category,
      t.priority,
      t.location,
      t.assignedTo,
      t.time,
      t.notes,
      formatDate(t.date),
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 68,
        backgroundColor: Stardew.wood,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: const WoodPlank(),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PixelSprout(cell: 3),
            const SizedBox(width: 12),
            Text(
              'My To-Do List',
              textAlign: TextAlign.left,
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: Stardew.parchmentLight,
                shadows: const [
                  Shadow(color: Stardew.woodDark, offset: Offset(2, 2)),
                ],
              ),
            ),
          ],
        ),
      ),
      // Rebuilds the list after every create, update or delete.
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: TaskRepository.box.listenable(),
        builder: (context, box, _) {
          final all = TaskRepository.getAll();

          if (all.isEmpty) {
            return const _EmptyState();
          }

          final q = _query.trim().toLowerCase();
          final tasks =
              q.isEmpty ? all : all.where((t) => _matches(t, q)).toList();

          return Column(
            children: [
              _SearchBar(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                onClear: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
              Expanded(
                child: tasks.isEmpty
                    ? _NoResults(query: _query.trim())
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 6, bottom: 100),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: ValueKey(task.key),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 7),
                              padding: const EdgeInsets.only(right: 24),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Stardew.red,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Stardew.woodDark, width: 3),
                              ),
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.white),
                            ),
                            onDismissed: (_) =>
                                _deleteWithUndo(context, task),
                            child: TaskTile(task: task),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Stardew.grassDark,
        foregroundColor: Stardew.parchmentLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: Stardew.woodDark, width: 3),
        ),
        onPressed: () => showTaskFormDialog(context),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add task',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _deleteWithUndo(BuildContext context, Task task) async {
    // Keep a full copy so Undo restores every field.
    final backup = task.copy();

    final messenger = ScaffoldMessenger.of(context);

    await TaskRepository.delete(task);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Deleted "${backup.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await TaskRepository.box.add(backup);
          },
        ),
      ),
    );
  }
}

/// Search box shown above the task list.
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: Stardew.pixelShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: const TextStyle(color: Stardew.mutedInk),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Stardew.woodDark, width: 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Stardew.woodDark, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Stardew.grassDark, width: 3),
          ),
        ),
      ),
    );
  }
}

/// Shown when the search finds nothing.
class _NoResults extends StatelessWidget {
  final String query;

  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Stardew.parchment,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Stardew.woodDark, width: 3),
          boxShadow: Stardew.pixelShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No matching tasks',
              textAlign: TextAlign.left,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Nothing found for "$query".',
              textAlign: TextAlign.left,
              style: textTheme.bodyMedium?.copyWith(color: Stardew.mutedInk),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Stardew.parchment,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Stardew.woodDark, width: 3),
          boxShadow: Stardew.pixelShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PixelSprout(cell: 7),
            const SizedBox(height: 14),
            Text(
              'No tasks yet',
              textAlign: TextAlign.left,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add task" to plant your first one.',
              textAlign: TextAlign.left,
              style: textTheme.bodyMedium?.copyWith(color: Stardew.mutedInk),
            ),
          ],
        ),
      ),
    );
  }
}