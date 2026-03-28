import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task_model.dart';
import 'screens/tasks_screen.dart';

void main() {
  runApp(const DoDoNeApp());
}

class DoDoNeApp extends StatelessWidget {
  const DoDoNeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskModel(),
      child: MaterialApp(
        title: 'DoDone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF6750A4),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: const TasksScreen(),
      ),
    );
  }
}
