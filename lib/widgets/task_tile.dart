import 'package:flutter/material.dart';

import '../data/task_repository.dart';
import '../models/task.dart';
import '../utils/date_format.dart';
import 'task_form_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final today = DateTime.now();
    final overdue = !task.isDone &&
        DateTime(task.date.year, task.date.month, task.date.day)
            .isBefore(DateTime(today.year, today.month, today.day));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: scheme.surface.withAlpha(235),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withAlpha(60)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onTap: () => showTaskFormDialog(context, task: task),
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) => TaskRepository.toggleDone(task),
        ),
        title: Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? scheme.outline : scheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(
                Icons.event,
                size: 16,
                color: overdue ? scheme.error : scheme.secondary,
              ),
              const SizedBox(width: 6),
              Text(
                formatDate(task.date),
                style: textTheme.bodyMedium?.copyWith(
                  color: overdue ? scheme.error : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          tooltip: 'Edit task',
          icon: Icon(Icons.edit_outlined, color: scheme.outline),
          onPressed: () => showTaskFormDialog(context, task: task),
        ),
      ),
    );
  }
}