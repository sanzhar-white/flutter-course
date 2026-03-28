import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../widgets/expense_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('d MMMM yyyy', 'ru');
    final amountFormat = NumberFormat('#,##0', 'ru_RU');

    return Consumer<ExpenseModel>(
      builder: (context, model, _) {
        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = model.groupedExpenses;
        final sortedDates = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        if (sortedDates.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: colorScheme.onSurface.withOpacity(0.2),
                ),
                const SizedBox(height: 16),
                Text(
                  'Нет расходов',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Добавьте первый расход',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final expenses = grouped[date]!;
            final dayTotal = expenses.fold(0.0, (sum, e) => sum + e.amount);

            final isToday = date.day == DateTime.now().day &&
                date.month == DateTime.now().month &&
                date.year == DateTime.now().year;

            final isYesterday = date.day == DateTime.now().subtract(const Duration(days: 1)).day &&
                date.month == DateTime.now().subtract(const Duration(days: 1)).month &&
                date.year == DateTime.now().subtract(const Duration(days: 1)).year;

            String dateLabel;
            if (isToday) {
              dateLabel = 'Сегодня';
            } else if (isYesterday) {
              dateLabel = 'Вчера';
            } else {
              dateLabel = dateFormat.format(date);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${amountFormat.format(dayTotal)} \u20B8',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ...expenses.map((expense) => ExpenseTile(expense: expense)),
              ],
            );
          },
        );
      },
    );
  }
}
