import 'package:flutter/material.dart';

import '../data/task_repository.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';
import 'task_form_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  /// Color that matches the priority text (High / Medium / Low).
  Color _priorityColor(String p) {
    final v = p.toLowerCase().trim();
    if (v.startsWith('high') || v == 'urgent') return Stardew.red;
    if (v.startsWith('med')) return Stardew.gold;
    if (v.startsWith('low')) return Stardew.grassDark;
    return Stardew.wood;
  }

  Widget _badge(String text, Color color) {
    final dark = color == Stardew.gold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Stardew.woodDark, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag,
              size: 13, color: dark ? Stardew.ink : Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: dark ? Stardew.ink : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Stardew.parchmentLight,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Stardew.wood, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Stardew.mutedInk),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Stardew.ink),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Stardew.mutedInk),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Stardew.mutedInk),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final today = DateTime.now();
    final overdue = !task.isDone &&
        DateTime(task.date.year, task.date.month, task.date.day)
            .isBefore(DateTime(today.year, today.month, today.day));

    final dateText = task.time.trim().isEmpty
        ? formatDate(task.date)
        : '${formatDate(task.date)} - ${task.time}';

    final stripe =
        task.isDone ? Stardew.grass : _priorityColor(task.priority);

    final badges = <Widget>[
      if (task.priority.trim().isNotEmpty)
        _badge(task.priority.trim(), _priorityColor(task.priority)),
      if (task.category.trim().isNotEmpty)
        _chip(Icons.label_outline, task.category.trim()),
    ];

    final infos = <Widget>[
      if (task.location.trim().isNotEmpty)
        _info(Icons.place_outlined, task.location.trim()),
      if (task.assignedTo.trim().isNotEmpty)
        _info(Icons.person_outline, task.assignedTo.trim()),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: Stardew.parchment,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Stardew.woodDark, width: 3),
        boxShadow: Stardew.pixelShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Priority color stripe
              Container(
                width: 10,
                decoration: BoxDecoration(
                  color: stripe,
                  border: const Border(
                    right: BorderSide(color: Stardew.woodDark, width: 2),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    onTap: () => showTaskFormDialog(context, task: task),
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (_) => TaskRepository.toggleDone(task),
                    ),
                    title: Text(
                      task.title,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                        color: task.isDone ? Stardew.mutedInk : Stardew.ink,
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
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: Stardew.ink),
                              ),
                            ),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 16,
                                color: overdue
                                    ? Stardew.red
                                    : Stardew.grassDark,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  overdue ? '$dateText (overdue)' : dateText,
                                  textAlign: TextAlign.left,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: overdue
                                        ? Stardew.red
                                        : Stardew.mutedInk,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (badges.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: badges,
                              ),
                            ),
                          if (infos.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 2,
                                children: infos,
                              ),
                            ),
                          if (task.notes.trim().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Notes: ${task.notes}',
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Stardew.mutedInk,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Edit task',
                      icon: const Icon(Icons.edit_outlined,
                          color: Stardew.wood),
                      onPressed: () =>
                          showTaskFormDialog(context, task: task),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}