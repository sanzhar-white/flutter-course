import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/expense.dart';
import 'models/expense_model.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseCategoryAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('is_dark_theme') ?? false;

  runApp(FinanceTrackerApp(isDark: isDark));
}

class FinanceTrackerApp extends StatefulWidget {
  final bool isDark;

  const FinanceTrackerApp({super.key, required this.isDark});

  @override
  State<FinanceTrackerApp> createState() => FinanceTrackerAppState();

  static FinanceTrackerAppState of(BuildContext context) {
    return context.findAncestorStateOfType<FinanceTrackerAppState>()!;
  }
}

class FinanceTrackerAppState extends State<FinanceTrackerApp> {
  late bool _isDark;

  bool get isDark => _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  void toggleTheme(bool isDark) async {
    setState(() {
      _isDark = isDark;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_theme', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseModel(),
      child: MaterialApp(
        title: 'Трекер финансов',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF2D6A4F),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: const Color(0xFF52B788),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
