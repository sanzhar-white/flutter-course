class Conversion {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double result;
  final DateTime timestamp;

  Conversion({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.result,
    required this.timestamp,
  });

  String get formattedResult =>
      '${amount.toStringAsFixed(2)} $fromCurrency = ${result.toStringAsFixed(2)} $toCurrency';

  String get formattedTimestamp {
    final d = timestamp;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year;
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }
}
