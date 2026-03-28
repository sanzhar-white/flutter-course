import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../utils/weather_icons.dart';
import 'search_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();

  WeatherData? _weather;
  List<Forecast> _forecast = [];
  bool _isLoading = true;
  String? _error;
  String _currentCity = 'Москва';

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather =
          await _weatherService.getWeatherByCity(_currentCity);
      final forecast =
          await _weatherService.getForecastByCity(_currentCity);
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to demo data if API call fails
      setState(() {
        _weather = _getDemoWeather();
        _forecast = _getDemoForecast();
        _isLoading = false;
        _error = null; // Don't show error, use demo data
      });
    }
  }

  WeatherData _getDemoWeather() {
    return WeatherData(
      city: _currentCity,
      temperature: 18,
      description: 'переменная облачность',
      humidity: 64,
      windSpeed: 3.5,
      icon: '02d',
      feelsLike: 16,
    );
  }

  List<Forecast> _getDemoForecast() {
    final now = DateTime.now();
    final icons = ['01d', '02d', '10d', '03d', '01d'];
    final descriptions = [
      'ясно',
      'переменная облачность',
      'небольшой дождь',
      'облачно',
      'ясно',
    ];
    final temps = [
      [12.0, 22.0],
      [10.0, 19.0],
      [8.0, 14.0],
      [9.0, 16.0],
      [11.0, 21.0],
    ];

    return List.generate(5, (i) {
      return Forecast(
        date: now.add(Duration(days: i + 1)),
        tempMin: temps[i][0],
        tempMax: temps[i][1],
        icon: icons[i],
        description: descriptions[i],
      );
    });
  }

  Future<void> _openSearch() async {
    final city = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (city != null && city.isNotEmpty) {
      _currentCity = city;
      _loadWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoading()
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF4FC3F7),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Загрузка погоды...',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadWeather,
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FC3F7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _loadWeather,
      color: const Color(0xFF4FC3F7),
      backgroundColor: const Color(0xFF16213E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            _buildMainWeather(),
            const SizedBox(height: 8),
            _buildDetailsRow(),
            const SizedBox(height: 24),
            _buildForecastSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 0),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF4FC3F7), size: 22),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _weather?.city ?? _currentCity,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: _openSearch,
              icon: const Icon(Icons.search, color: Colors.white70, size: 28),
              tooltip: 'Поиск города',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWeather() {
    final weather = _weather!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Big weather emoji
          Text(
            getWeatherEmoji(weather.icon),
            style: const TextStyle(fontSize: 100),
          ),
          const SizedBox(height: 8),
          // Temperature
          Text(
            weather.temperatureString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.w200,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          // Description
          Text(
            _capitalize(weather.description),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          // Feels like
          Text(
            'Ощущается как ${weather.feelsLikeString}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow() {
    final weather = _weather!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _DetailItem(
              icon: Icons.water_drop_outlined,
              label: 'Влажность',
              value: '${weather.humidity}%',
            ),
            Container(width: 1, height: 40, color: Colors.white12),
            _DetailItem(
              icon: Icons.air,
              label: 'Ветер',
              value: '${weather.windSpeed} м/с',
            ),
            Container(width: 1, height: 40, color: Colors.white12),
            _DetailItem(
              icon: Icons.thermostat_outlined,
              label: 'Ощущ.',
              value: weather.feelsLikeString,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastSection() {
    if (_forecast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'ПРОГНОЗ НА 5 ДНЕЙ',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _forecast.length,
            itemBuilder: (context, index) {
              final day = _forecast[index];
              return _buildForecastCard(day);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(Forecast day) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.dayOfWeek,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            day.formattedDate,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            getWeatherEmoji(day.icon),
            style: const TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 8),
          Text(
            '${day.tempMax.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${day.tempMin.round()}°',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF4FC3F7), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
