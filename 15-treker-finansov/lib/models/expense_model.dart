import 'package:flutter/foundation.dart';
import 'expense.dart';
import '../services/storage_service.dart';

class ExpenseModel extends ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = true;

  ExpenseModel() {
    _loadExpenses();
  }

  bool get isLoading => _isLoading;
  List<Expense> get expenses => List.unmodifiable(_expenses);

  Future<void> _loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await StorageService.getExpenses();
    _expenses.sort((a, b) => b.date.compareTo(a.date));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.insert(0, expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
    await StorageService.saveExpense(expense);
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
    await StorageService.deleteExpense(id);
  }

  List<Expense> getExpensesByDay(DateTime date) {
    return _expenses.where((e) =>
      e.date.year == date.year &&
      e.date.month == date.month &&
      e.date.day == date.day
    ).toList();
  }

  double getTotalForDay(DateTime date) {
    return getExpensesByDay(date).fold(0.0, (sum, e) => sum + e.amount);
  }

  double getWeeklyTotal() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(weekStart.year, weekStart.month, weekStart.day);

    return _expenses
        .where((e) => e.date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double getMonthlyTotal() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return _expenses
        .where((e) => e.date.isAfter(startOfMonth.subtract(const Duration(seconds: 1))))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<ExpenseCategory, double> getCategoryTotals() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final monthExpenses = _expenses
        .where((e) => e.date.isAfter(startOfMonth.subtract(const Duration(seconds: 1))));

    final Map<ExpenseCategory, double> totals = {};
    for (final expense in monthExpenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  /// Returns daily totals for last 7 days (Mon-Sun)
  List<MapEntry<DateTime, double>> getWeeklyDailyTotals() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (index) {
      final day = DateTime(weekStart.year, weekStart.month, weekStart.day + index);
      final total = getTotalForDay(day);
      return MapEntry(day, total);
    });
  }

  /// Returns expenses grouped by date
  Map<DateTime, List<Expense>> get groupedExpenses {
    final Map<DateTime, List<Expense>> grouped = {};
    for (final expense in _expenses) {
      final dateKey = DateTime(expense.date.year, expense.date.month, expense.date.day);
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(expense);
    }
    return grouped;
  }
}
