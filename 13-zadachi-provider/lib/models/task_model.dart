import 'package:flutter/foundation.dart';
import 'task.dart';

enum TaskFilter { all, active, completed }

class TaskModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  TaskFilter get filter => _filter;

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

  void setFilter(TaskFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  void addTask(String title, Priority priority) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
    );
    _tasks.insert(0, task);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
