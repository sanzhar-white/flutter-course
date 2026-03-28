import 'package:flutter/material.dart';
import 'screens/converter_screen.dart';

void main() {
  runApp(const KonverterValyutApp());
}

class KonverterValyutApp extends StatelessWidget {
  const KonverterValyutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Конвертер валют',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1565C0),
        useMaterial3: true,
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const ConverterScreen(),
    );
  }
}
