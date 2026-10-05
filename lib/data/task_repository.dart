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
  static Future<void> add(String title, DateTime date) async {
    await box.add(Task(title: title.trim(), date: date));
  }

  /// UPDATE
  static Future<void> update(Task task, String title, DateTime date) async {
    task.title = title.trim();
    task.date = date;
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