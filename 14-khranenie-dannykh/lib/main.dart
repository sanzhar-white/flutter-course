import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'models/task_model.dart';
import 'screens/tasks_screen.dart';
import 'services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  final isDark = await PreferencesService.isDarkTheme();

  runApp(DoDoNeApp(isDark: isDark));
}

class DoDoNeApp extends StatefulWidget {
  final bool isDark;

  const DoDoNeApp({super.key, required this.isDark});

  @override
  State<DoDoNeApp> createState() => DoDoNeAppState();

  static DoDoNeAppState of(BuildContext context) {
    return context.findAncestorStateOfType<DoDoNeAppState>()!;
  }
}

class DoDoNeAppState extends State<DoDoNeApp> {
  late bool _isDark;

  bool get isDark => _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  void toggleTheme(bool isDark) {
    setState(() {
      _isDark = isDark;
    });
    PreferencesService.setDarkTheme(isDark);
  }

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
        darkTheme: ThemeData(
          colorSchemeSeed: const Color(0xFF6750A4),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home: const TasksScreen(),
      ),
    );
  }
}
