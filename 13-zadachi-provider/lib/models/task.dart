import 'package:flutter/foundation.dart';

enum Priority { high, medium, low }

class Task {
  final String id;
  final String title;
  bool isDone;
  final Priority priority;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.priority = Priority.medium,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get priorityLabel {
    switch (priority) {
      case Priority.high:
        return 'Высокий';
      case Priority.medium:
        return 'Средний';
      case Priority.low:
        return 'Низкий';
    }
  }
}
