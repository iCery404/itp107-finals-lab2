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

  Task({
    required this.title,
    required this.date,
    this.isDone = false,
  });
}