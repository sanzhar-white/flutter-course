import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double amount;
  final double maxAmount;
  final bool isHighlighted;
  final Color color;

  const ChartBar({
    super.key,
    required this.label,
    required this.amount,
    required this.maxAmount,
    this.isHighlighted = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fraction = maxAmount > 0 ? (amount / maxAmount) : 0.0;
    final formatter = NumberFormat.compact(locale: 'ru');

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (amount > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              formatter.format(amount),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: isHighlighted
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.6),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        Flexible(
          child: FractionallySizedBox(
            heightFactor: fraction.clamp(0.02, 1.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isHighlighted
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
