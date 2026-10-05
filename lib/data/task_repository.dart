import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';

/// All Hive CRUD operations.
class TaskRepository {
  TaskRepository._();

  static const String boxName = 'taskBox';

  static Box<Task> get box => Hive.box<Task>(boxName);

  /// READ - all tasks, earliest date first.
  static List<Task> getAll() {
    final tasks = box.values.toList();
    tasks.sort((a, b) => a.date.compareTo(b.date));
    return tasks;
  }

  /// CREATE
  static Future<void> add(Task task) async {
    await box.add(task);
  }

  /// UPDATE - copy the edited values into the stored task and save.
  static Future<void> update(Task task, Task edited) async {
    task.title = edited.title;
    task.date = edited.date;
    task.description = edited.description;
    task.category = edited.category;
    task.priority = edited.priority;
    task.location = edited.location;
    task.assignedTo = edited.assignedTo;
    task.time = edited.time;
    task.notes = edited.notes;
    await task.save();
  }

  /// UPDATE - mark done / not done.
  static Future<void> toggleDone(Task task) async {
    task.isDone = !task.isDone;
    await task.save();
  }

  /// DELETE
  static Future<void> delete(Task task) async {
    await task.delete();
  }
}