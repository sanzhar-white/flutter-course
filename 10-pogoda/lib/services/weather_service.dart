import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/forecast.dart';

class WeatherService {
  // Replace with your actual OpenWeatherMap API key
  static const String _apiKey = 'YOUR_API_KEY';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Fetches current weather by city name.
  Future<WeatherData> getWeatherByCity(String city) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric&lang=ru',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherData.fromJson(json);
      } else {
        throw WeatherException(
          'Не удалось загрузить погоду. Код: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Ошибка сети. Проверьте подключение к интернету.');
    }
  }

  /// Fetches current weather by geographic coordinates.
  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=ru',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherData.fromJson(json);
      } else {
        throw WeatherException(
          'Не удалось загрузить погоду. Код: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Ошибка сети. Проверьте подключение к интернету.');
    }
  }

  /// Fetches 5-day forecast by city name.
  Future<List<Forecast>> getForecastByCity(String city) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric&lang=ru',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return _parseForecast(json);
      } else {
        throw WeatherException(
          'Не удалось загрузить прогноз. Код: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('Ошибка сети. Проверьте подключение к интернету.');
    }
  }

  List<Forecast> _parseForecast(Map<String, dynamic> json) {
    final list = json['list'] as List<dynamic>;

    // Group by day
    final Map<String, List<dynamic>> grouped = {};
    for (final item in list) {
      final dateStr = (item['dt_txt'] as String).substring(0, 10);
      grouped.putIfAbsent(dateStr, () => []);
      grouped[dateStr]!.add(item);
    }

    // Skip today, take next 5 days
    final days = grouped.entries.skip(1).take(5);
    return days.map((e) => Forecast.fromDayData(e.value)).toList();
  }
}

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}
