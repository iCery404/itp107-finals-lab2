import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/task_repository.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          final tasks = TaskRepository.getAll();

          if (tasks.isEmpty) {
            return const _EmptyState();
          }

          final done = tasks.where((t) => t.isDone).length;

          return Column(
            children: [
              _QuestBoard(done: done, total: tasks.length),
              Expanded(
                child: ListView.builder(
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
                          border:
                              Border.all(color: Stardew.woodDark, width: 3),
                        ),
                        child: const Icon(Icons.delete_outline,
                            color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteWithUndo(context, task),
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

/// Small parchment board showing how many tasks are finished.
class _QuestBoard extends StatelessWidget {
  final int done;
  final int total;

  const _QuestBoard({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fraction = total == 0 ? 0.0 : done / total;
    final allDone = total > 0 && done == total;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Stardew.parchment,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Stardew.woodDark, width: 3),
        boxShadow: Stardew.pixelShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Stardew.gold, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  allDone
                      ? 'All quests complete!'
                      : 'Quests done: $done / $total',
                  textAlign: TextAlign.left,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Stardew.parchmentLight,
              border: Border.all(color: Stardew.woodDark, width: 2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fraction,
                heightFactor: 1,
                child: Container(color: Stardew.grass),
              ),
            ),
          ),
        ],
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