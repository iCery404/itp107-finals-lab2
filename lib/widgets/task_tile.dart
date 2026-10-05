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

  /// Priority badge. Text wraps instead of being cut off.
  Widget _badge(String text, Color color) {
    final dark = color == Stardew.gold;
    final fg = dark ? Stardew.ink : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Stardew.woodDark, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(Icons.flag, size: 13, color: fg),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.left,
              softWrap: true,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Category chip. Text wraps instead of being cut off.
  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Stardew.parchmentLight,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Stardew.wood, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 13, color: Stardew.mutedInk),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.left,
              softWrap: true,
              style: const TextStyle(fontSize: 12, color: Stardew.ink),
            ),
          ),
        ],
      ),
    );
  }

  /// Icon + text row that wraps onto more lines when long.
  Widget _info(IconData icon, String text, {Color? color, double size = 13}) {
    final c = color ?? Stardew.mutedInk;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 15, color: c),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(fontSize: size, color: c),
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
        : '${formatDate(task.date)} - ${task.time.trim()}';

    final stripe =
        task.isDone ? Stardew.grass : _priorityColor(task.priority);

    final badges = <Widget>[
      if (task.priority.trim().isNotEmpty)
        _badge(task.priority.trim(), _priorityColor(task.priority)),
      if (task.category.trim().isNotEmpty)
        _chip(Icons.label_outline, task.category.trim()),
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
                  child: InkWell(
                    onTap: () => showTaskFormDialog(context, task: task),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 10, 4, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: task.isDone,
                            onChanged: (_) =>
                                TaskRepository.toggleDone(task),
                          ),
                          const SizedBox(width: 4),
                          // Everything wraps and grows with the text.
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: task.isDone
                                          ? Stardew.mutedInk
                                          : Stardew.ink,
                                    ),
                                  ),
                                  if (task.description.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        task.description.trim(),
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                        style: textTheme.bodyMedium
                                            ?.copyWith(color: Stardew.ink),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: _info(
                                      Icons.event,
                                      overdue
                                          ? '$dateText (overdue)'
                                          : dateText,
                                      color: overdue
                                          ? Stardew.red
                                          : Stardew.mutedInk,
                                      size: 14,
                                    ),
                                  ),
                                  if (badges.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: badges,
                                      ),
                                    ),
                                  if (task.location.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: _info(Icons.place_outlined,
                                          task.location.trim()),
                                    ),
                                  if (task.assignedTo.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: _info(Icons.person_outline,
                                          task.assignedTo.trim()),
                                    ),
                                  if (task.notes.trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Notes: ${task.notes.trim()}',
                                        textAlign: TextAlign.left,
                                        softWrap: true,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: Stardew.mutedInk,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit task',
                            icon: const Icon(Icons.edit_outlined,
                                color: Stardew.wood),
                            onPressed: () =>
                                showTaskFormDialog(context, task: task),
                          ),
                        ],
                      ),
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