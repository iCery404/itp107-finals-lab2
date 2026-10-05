import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:labact2/data/task_repository.dart';
import 'package:labact2/main.dart';
import 'package:labact2/models/task.dart';

void main() {
  testWidgets('Shows empty state when there are no tasks',
      (WidgetTester tester) async {
    // Hive does real file I/O, so it must run outside the fake-async zone.
    await tester.runAsync(() async {
      final dir = Directory.systemTemp.createTempSync('hive_test');
      Hive.init(dir.path);
      Hive.registerAdapter(TaskAdapter());
      await Hive.openBox<Task>(TaskRepository.boxName);
    });

    await tester.pumpWidget(const TodoApp());

    expect(find.text('My To-Do List'), findsOneWidget);
    expect(find.text('No tasks yet'), findsOneWidget);
    expect(find.text('Add task'), findsOneWidget);
  });
}