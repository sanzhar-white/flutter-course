import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RetseptApp());
}

class RetseptApp extends StatefulWidget {
  const RetseptApp({super.key});

  @override
  State<RetseptApp> createState() => _RetseptAppState();
}

class _RetseptAppState extends State<RetseptApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Рецепты',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFE65100),
        useMaterial3: true,
        brightness: Brightness.light,
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFFFF8A65),
        useMaterial3: true,
        brightness: Brightness.dark,
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}
