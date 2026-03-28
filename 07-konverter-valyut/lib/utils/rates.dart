/// Курсы валют относительно KZT (1 единица валюты = X тенге).
const Map<String, double> ratesToKZT = {
  'KZT': 1.0,
  'USD': 450.0,
  'EUR': 490.0,
  'RUB': 5.2,
};

/// Конвертирует [amount] из [from] в [to].
double convert(double amount, String from, String to) {
  final fromRate = ratesToKZT[from];
  final toRate = ratesToKZT[to];
  if (fromRate == null || toRate == null) {
    throw ArgumentError('Неизвестная валюта: $from или $to');
  }
  return amount * fromRate / toRate;
}

const List<String> availableCurrencies = ['KZT', 'USD', 'EUR', 'RUB'];

const Map<String, String> currencyNames = {
  'KZT': 'Тенге (KZT)',
  'USD': 'Доллар (USD)',
  'EUR': 'Евро (EUR)',
  'RUB': 'Рубль (RUB)',
};
