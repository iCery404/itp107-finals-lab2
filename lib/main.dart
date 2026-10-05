import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/task_repository.dart';
import 'models/task.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive before runApp().
  await Hive.initFlutter();

  // 2. Register the generated adapter.
  Hive.registerAdapter(TaskAdapter());

  // 3. Open the box that holds all to-do items.
  await Hive.openBox<Task>(TaskRepository.boxName);

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silver To-Do',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) =>
          CozyWallpaper(child: child ?? const SizedBox.shrink()),
      home: const HomeScreen(),
    );
  }
}