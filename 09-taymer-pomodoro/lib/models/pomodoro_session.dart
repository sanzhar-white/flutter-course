enum SessionType { work, breakTime }

class PomodoroSession {
  final DateTime startTime;
  final int duration; // in minutes
  final SessionType type;
  final bool completed;

  PomodoroSession({
    required this.startTime,
    required this.duration,
    required this.type,
    required this.completed,
  });

  String get typeLabel => type == SessionType.work ? 'Работа' : 'Перерыв';

  String get formattedDate {
    final d = startTime;
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDuration => '$duration мин';
}
