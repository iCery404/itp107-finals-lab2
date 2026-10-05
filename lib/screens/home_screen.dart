import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/task_repository.dart';
import '../models/task.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My To-Do List',
          style: TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      // Rebuilds the list after every create, update or delete.
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: TaskRepository.box.listenable(),
        builder: (context, box, _) {
          final tasks = TaskRepository.getAll();

          if (tasks.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 96),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: ValueKey(task.key),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.only(right: 24),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: scheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.delete_outline, color: scheme.onError),
                ),
                onDismissed: (_) => _deleteWithUndo(context, task),
                child: TaskTile(task: task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.onSecondary,
        onPressed: () => showTaskFormDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist_rounded, size: 80, color: scheme.primary),
            const SizedBox(height: 16),
            Text('No tasks yet', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap "Add task" to create your first one.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}