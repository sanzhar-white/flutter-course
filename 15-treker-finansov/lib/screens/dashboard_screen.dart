import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/expense_model.dart';
import '../widgets/chart_bar.dart';
import '../widgets/category_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##0', 'ru_RU');
    return '${formatter.format(amount)} \u20B8';
  }

  String _shortDayName(int weekday) {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<ExpenseModel>(
      builder: (context, model, _) {
        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final weeklyTotal = model.getWeeklyTotal();
        final monthlyTotal = model.getMonthlyTotal();
        final weeklyDaily = model.getWeeklyDailyTotals();
        final maxDaily = weeklyDaily
            .map((e) => e.value)
            .fold(0.0, (a, b) => a > b ? a : b);
        final categoryTotals = model.getCategoryTotals();

        // Sort categories by amount descending
        final sortedCategories = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards row
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'За неделю',
                      amount: _formatAmount(weeklyTotal),
                      icon: Icons.calendar_view_week,
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: 'За месяц',
                      amount: _formatAmount(monthlyTotal),
                      icon: Icons.calendar_month,
                      color: colorScheme.tertiary,
                      backgroundColor: colorScheme.tertiaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Weekly chart
              Text(
                'Расходы за неделю',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 180,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: weeklyDaily.map((entry) {
                        final isToday = entry.key.day == DateTime.now().day &&
                            entry.key.month == DateTime.now().month;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChartBar(
                              label: _shortDayName(entry.key.weekday),
                              amount: entry.value,
                              maxAmount: maxDaily == 0 ? 1 : maxDaily,
                              isHighlighted: isToday,
                              color: isToday
                                  ? colorScheme.primary
                                  : colorScheme.primaryContainer,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category breakdown
              Text(
                'По категориям (этот месяц)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (sortedCategories.isEmpty)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.pie_chart_outline,
                            size: 48,
                            color: colorScheme.onSurface.withOpacity(0.2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Нет расходов за этот месяц',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...sortedCategories.map((entry) {
                  final percentage = monthlyTotal > 0
                      ? (entry.value / monthlyTotal * 100)
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CategoryCard(
                      category: entry.key,
                      amount: entry.value,
                      percentage: percentage,
                      totalAmount: monthlyTotal,
                    ),
                  );
                }),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: backgroundColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                amount,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
