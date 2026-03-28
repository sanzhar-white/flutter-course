import 'package:flutter/material.dart';
import '../models/conversion.dart';

class HistoryScreen extends StatelessWidget {
  final List<Conversion> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('История конвертаций'),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'История пуста',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.currency_exchange,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      item.formattedResult,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(item.formattedTimestamp),
                    trailing: Text(
                      '${item.fromCurrency} -> ${item.toCurrency}',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
