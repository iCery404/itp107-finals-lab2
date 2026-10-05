import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/task_repository.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';

/// Opens the add/edit dialog. Pass [task] to edit, leave null to create.
Future<void> showTaskFormDialog(BuildContext context, {Task? task}) {
  return showDialog<void>(
    context: context,
    builder: (_) => TaskFormDialog(task: task),
  );
}

class TaskFormDialog extends StatefulWidget {
  final Task? task;

  const TaskFormDialog({super.key, this.task});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _category;
  late final TextEditingController _priority;
  late final TextEditingController _location;
  late final TextEditingController _assignedTo;
  late final TextEditingController _time;
  late final TextEditingController _notes;
  late DateTime _selectedDate;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _title = TextEditingController(text: t?.title ?? '');
    _description = TextEditingController(text: t?.description ?? '');
    _category = TextEditingController(text: t?.category ?? '');
    _priority = TextEditingController(text: t?.priority ?? '');
    _location = TextEditingController(text: t?.location ?? '');
    _assignedTo = TextEditingController(text: t?.assignedTo ?? '');
    _time = TextEditingController(text: t?.time ?? '');
    _notes = TextEditingController(text: t?.notes ?? '');
    _selectedDate = t?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _category,
      _priority,
      _location,
      _assignedTo,
      _time,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final first = DateTime(2000);
    final last = DateTime(2100);
    var initial = _selectedDate;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    // Validation: title must not be empty.
    if (!_formKey.currentState!.validate()) return;

    final values = Task(
      title: _title.text.trim(),
      date: _selectedDate,
      description: _description.text.trim(),
      category: _category.text.trim(),
      priority: _priority.text.trim(),
      location: _location.text.trim(),
      assignedTo: _assignedTo.text.trim(),
      time: _time.text.trim(),
      notes: _notes.text.trim(),
    );

    if (_isEditing) {
      await TaskRepository.update(widget.task!, values);
    } else {
      await TaskRepository.add(values);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  /// Small section heading with a wooden divider line.
  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Row(
        children: [
          Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Stardew.woodDark,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(color: Stardew.wood, thickness: 2, height: 2),
          ),
        ],
      ),
    );
  }

  /// One optional text field with a consistent look.
  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    int maxLength = 100,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        textAlign: TextAlign.left,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          counterText: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Stardew.parchment,
      clipBehavior: Clip.antiAlias,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Stardew.woodDark, width: 4),
      ),
      // Wooden sign header
      title: WoodPlank(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
        child: Row(
          children: [
            const PixelSprout(cell: 3),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isEditing ? 'Edit task' : 'New task',
                textAlign: TextAlign.left,
                style: GoogleFonts.pressStart2p(
                  fontSize: 13,
                  color: Stardew.parchmentLight,
                  shadows: const [
                    Shadow(color: Stardew.woodDark, offset: Offset(2, 2)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section('The quest'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    controller: _title,
                    autofocus: true,
                    maxLength: 100,
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Task title *',
                      prefixIcon: Icon(Icons.edit_note),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                ),
                _field(_description, 'Description', Icons.notes,
                    maxLines: 2, maxLength: 200),
                _field(_category, 'Category', Icons.label_outline),
                _field(_priority, 'Priority (High / Medium / Low)',
                    Icons.flag_outlined),
                _section('Where and who'),
                _field(_location, 'Location', Icons.place_outlined),
                _field(_assignedTo, 'Assigned to', Icons.person_outline),
                _section('When'),
                _field(_time, 'Time (e.g. 3:00 PM)', Icons.schedule),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(
                        formatDate(_selectedDate),
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Stardew.ink),
                      ),
                    ),
                  ),
                ),
                _section('Extras'),
                _field(_notes, 'Notes', Icons.sticky_note_2_outlined,
                    maxLines: 2, maxLength: 200),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(_isEditing ? 'Save changes' : 'Add task'),
        ),
      ],
    );
  }
}