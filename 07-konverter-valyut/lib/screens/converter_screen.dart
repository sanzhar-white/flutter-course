import 'package:flutter/material.dart';
import '../models/conversion.dart';
import '../utils/rates.dart';
import 'history_screen.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String _fromCurrency = 'USD';
  String _toCurrency = 'KZT';
  double? _result;
  final List<Conversion> _history = [];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convert() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    final result = convert(amount, _fromCurrency, _toCurrency);

    final conversion = Conversion(
      amount: amount,
      fromCurrency: _fromCurrency,
      toCurrency: _toCurrency,
      result: result,
      timestamp: DateTime.now(),
    );

    setState(() {
      _result = result;
      _history.insert(0, conversion);
      if (_history.length > 5) {
        _history.removeLast();
      }
    });
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _result = null;
    });
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoryScreen(history: _history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер валют'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'История',
            onPressed: _history.isEmpty ? null : _openHistory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Сумма ---
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Сумма',
                  hintText: 'Введите сумму',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите сумму';
                  }
                  final parsed =
                      double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null) {
                    return 'Введите корректное число';
                  }
                  if (parsed <= 0) {
                    return 'Сумма должна быть больше нуля';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Валюты ---
              Row(
                children: [
                  Expanded(
                    child: _CurrencyDropdown(
                      label: 'Из',
                      value: _fromCurrency,
                      onChanged: (v) => setState(() {
                        _fromCurrency = v!;
                        _result = null;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: IconButton.filledTonal(
                      onPressed: _swapCurrencies,
                      icon: const Icon(Icons.swap_horiz),
                      tooltip: 'Поменять местами',
                    ),
                  ),
                  Expanded(
                    child: _CurrencyDropdown(
                      label: 'В',
                      value: _toCurrency,
                      onChanged: (v) => setState(() {
                        _toCurrency = v!;
                        _result = null;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- Кнопка ---
              FilledButton.icon(
                onPressed: _convert,
                icon: const Icon(Icons.currency_exchange),
                label: const Text('Конвертировать'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 28),

              // --- Результат ---
              if (_result != null)
                Card(
                  color: colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Результат',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_result!.toStringAsFixed(2)} $_toCurrency',
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_amountController.text} $_fromCurrency',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String?> onChanged;

  const _CurrencyDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
      ),
      isExpanded: true,
      items: availableCurrencies
          .map(
            (c) => DropdownMenuItem(
              value: c,
              child: Text(currencyNames[c] ?? c),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
