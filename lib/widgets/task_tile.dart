import 'package:flutter/material.dart';

import '../data/task_repository.dart';
import '../models/task.dart';
import '../utils/date_format.dart';
import 'task_form_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  /// Small "icon + text" line, only shown when the text isn't empty.
  Widget? _info(BuildContext context, IconData icon, String text,
      {Color? color}) {
    if (text.trim().isEmpty) return null;
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: c),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c, fontSize: 13),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final today = DateTime.now();
    final overdue = !task.isDone &&
        DateTime(task.date.year, task.date.month, task.date.day)
            .isBefore(DateTime(today.year, today.month, today.day));

    final dateText = task.time.trim().isEmpty
        ? formatDate(task.date)
        : '${formatDate(task.date)} - ${task.time}';

    final details = <Widget?>[
      _info(context, Icons.label_outline, task.category),
      _info(context, Icons.flag_outlined, task.priority),
      _info(context, Icons.place_outlined, task.location),
      _info(context, Icons.person_outline, task.assignedTo),
    ].whereType<Widget>().toList();

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
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurface),
                  ),
                ),
              Row(
                children: [
                  Icon(
                    Icons.event,
                    size: 16,
                    color: overdue ? scheme.error : scheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      dateText,
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                            overdue ? scheme.error : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              if (details.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 2,
                    children: details,
                  ),
                ),
              if (task.notes.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Notes: ${task.notes}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: scheme.onSurfaceVariant,
                    ),
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