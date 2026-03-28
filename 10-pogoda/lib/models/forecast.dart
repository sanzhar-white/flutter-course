class Forecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;

  Forecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
  });

  factory Forecast.fromDayData(List<dynamic> dayItems) {
    double minTemp = double.infinity;
    double maxTemp = double.negativeInfinity;
    String icon = '';
    String description = '';

    for (final item in dayItems) {
      final temp = (item['main']['temp'] as num).toDouble();
      if (temp < minTemp) minTemp = temp;
      if (temp > maxTemp) maxTemp = temp;
      // Use the midday icon/description if available
      icon = item['weather'][0]['icon'] as String;
      description = item['weather'][0]['description'] as String;
    }

    final dateStr = dayItems[0]['dt_txt'] as String;
    return Forecast(
      date: DateTime.parse(dateStr),
      tempMin: minTemp,
      tempMax: maxTemp,
      icon: icon,
      description: description,
    );
  }

  String get dayOfWeek {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[date.weekday - 1];
  }

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
  }

  String get tempRange => '${tempMin.round()}° / ${tempMax.round()}°';
}
