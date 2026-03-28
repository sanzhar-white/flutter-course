import 'package:flutter/material.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погода',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FC3F7),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F1B2D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1B2D),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}
