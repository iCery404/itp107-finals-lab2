import 'package:hive/hive.dart';

part 'task.g.dart';

/// A single to-do item stored in the Hive box.
@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  String description;

  @HiveField(4)
  String category;

  @HiveField(5)
  String priority;

  @HiveField(6)
  String location;

  @HiveField(7)
  String assignedTo;

  @HiveField(8)
  String time;

  @HiveField(9)
  String notes;

  Task({
    required this.title,
    required this.date,
    this.isDone = false,
    this.description = '',
    this.category = '',
    this.priority = '',
    this.location = '',
    this.assignedTo = '',
    this.time = '',
    this.notes = '',
  });

  /// Plain copy (not tied to the box). Used for Undo after delete.
  Task copy() => Task(
        title: title,
        date: date,
        isDone: isDone,
        description: description,
        category: category,
        priority: priority,
        location: location,
        assignedTo: assignedTo,
        time: time,
        notes: notes,
      );
}