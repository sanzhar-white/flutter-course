import 'package:flutter/foundation.dart';
import 'task.dart';
import '../services/storage_service.dart';

enum TaskFilter { all, active, completed }

class TaskModel extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  bool _isLoading = true;

  TaskModel() {
    _loadTasks();
  }

  TaskFilter get filter => _filter;
  bool get isLoading => _isLoading;

  List<Task> get allTasks => List.unmodifiable(_tasks);

  List<Task> get activeTasks =>
      _tasks.where((task) => !task.isDone).toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isDone).toList();

  List<Task> get filteredTasks {
    switch (_filter) {
      case TaskFilter.all:
        return allTasks;
      case TaskFilter.active:
        return activeTasks;
      case TaskFilter.completed:
        return completedTasks;
    }
  }

  int get activeCount => activeTasks.length;
  int get completedCount => completedTasks.length;

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await StorageService.getTasks();
    _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(TaskFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  Future<void> addTask(String title, Priority priority) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
    );
    _tasks.insert(0, task);
    notifyListeners();
    await StorageService.saveTask(task);
  }

  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
      await StorageService.updateTask(_tasks[index]);
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
    await StorageService.deleteTask(id);
  }

  Future<void> clearAll() async {
    _tasks.clear();
    notifyListeners();
    await StorageService.clearAll();
  }
}
