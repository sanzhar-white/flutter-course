import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
enum ExpenseCategory {
  @HiveField(0)
  food,
  @HiveField(1)
  transport,
  @HiveField(2)
  entertainment,
  @HiveField(3)
  shopping,
  @HiveField(4)
  health,
  @HiveField(5)
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food:
        return 'Еда';
      case ExpenseCategory.transport:
        return 'Транспорт';
      case ExpenseCategory.entertainment:
        return 'Развлечения';
      case ExpenseCategory.shopping:
        return 'Покупки';
      case ExpenseCategory.health:
        return 'Здоровье';
      case ExpenseCategory.other:
        return 'Другое';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      case ExpenseCategory.health:
        return Icons.favorite;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return const Color(0xFFFF6B6B);
      case ExpenseCategory.transport:
        return const Color(0xFF4ECDC4);
      case ExpenseCategory.entertainment:
        return const Color(0xFFFFE66D);
      case ExpenseCategory.shopping:
        return const Color(0xFFA06CD5);
      case ExpenseCategory.health:
        return const Color(0xFFFF8A5C);
      case ExpenseCategory.other:
        return const Color(0xFF95AABE);
    }
  }
}

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final ExpenseCategory category;

  @HiveField(4)
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}
