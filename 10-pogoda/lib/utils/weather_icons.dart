/// Maps OpenWeatherMap icon codes to emoji representations.
String getWeatherEmoji(String iconCode) {
  switch (iconCode) {
    case '01d':
      return '☀️';
    case '01n':
      return '🌙';
    case '02d':
      return '⛅';
    case '02n':
      return '☁️';
    case '03d':
    case '03n':
      return '☁️';
    case '04d':
    case '04n':
      return '☁️';
    case '09d':
    case '09n':
      return '🌧️';
    case '10d':
      return '🌦️';
    case '10n':
      return '🌧️';
    case '11d':
    case '11n':
      return '⛈️';
    case '13d':
    case '13n':
      return '❄️';
    case '50d':
    case '50n':
      return '🌫️';
    default:
      return '🌤️';
  }
}

/// Maps weather condition descriptions to emojis (Russian).
String getWeatherEmojiByDescription(String description) {
  final desc = description.toLowerCase();
  if (desc.contains('ясно') || desc.contains('солнц')) return '☀️';
  if (desc.contains('облач')) return '☁️';
  if (desc.contains('дожд')) return '🌧️';
  if (desc.contains('гроз')) return '⛈️';
  if (desc.contains('снег')) return '❄️';
  if (desc.contains('туман')) return '🌫️';
  return '🌤️';
}
