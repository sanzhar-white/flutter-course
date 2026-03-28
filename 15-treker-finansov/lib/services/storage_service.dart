import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class StorageService {
  static const String _boxName = 'expenses';

  static Future<Box<Expense>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Expense>(_boxName);
    }
    return await Hive.openBox<Expense>(_boxName);
  }

  static Future<void> saveExpense(Expense expense) async {
    final box = await _getBox();
    await box.put(expense.id, expense);
  }

  static Future<List<Expense>> getExpenses() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> deleteExpense(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  static Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
