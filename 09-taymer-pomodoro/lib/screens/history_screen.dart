import 'package:flutter/material.dart';
import '../models/pomodoro_session.dart';

class HistoryScreen extends StatelessWidget {
  final List<PomodoroSession> sessions;

  const HistoryScreen({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История сессий'),
        centerTitle: true,
      ),
      body: sessions.isEmpty
          ? _buildEmptyState()
          : _buildSessionList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.white24,
          ),
          SizedBox(height: 16),
          Text(
            'Пока нет завершённых сессий',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Начните таймер, чтобы увидеть\nисторию здесь',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white24,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isWork = session.type == SessionType.work;
        final color =
            isWork ? const Color(0xFFE53935) : const Color(0xFF43A047);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isWork ? Icons.work_outline : Icons.coffee_outlined,
                color: color,
              ),
            ),
            title: Text(
              session.typeLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              session.formattedDate,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
              ),
            ),
            trailing: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                session.formattedDuration,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
