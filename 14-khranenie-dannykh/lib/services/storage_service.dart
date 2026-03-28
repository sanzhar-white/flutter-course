import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class StorageService {
  static const String _boxName = 'tasks';

  static Future<Box<Task>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Task>(_boxName);
    }
    return await Hive.openBox<Task>(_boxName);
  }

  static Future<void> saveTask(Task task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  static Future<List<Task>> getTasks() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> updateTask(Task task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  static Future<void> deleteTask(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  static Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
