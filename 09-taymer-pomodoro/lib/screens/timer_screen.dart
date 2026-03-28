import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pomodoro_session.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  int _workDuration = 25; // minutes
  int _breakDuration = 5; // minutes

  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  SessionType _currentType = SessionType.work;

  final List<PomodoroSession> _history = [];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _totalSeconds = _workDuration * 60;
    _remainingSeconds = _totalSeconds;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _pulseController.stop();
          _pulseController.reset();
          _onSessionComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _isRunning = false;
      _totalSeconds = _currentType == SessionType.work
          ? _workDuration * 60
          : _breakDuration * 60;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _onSessionComplete() {
    final session = PomodoroSession(
      startTime: DateTime.now().subtract(
        Duration(
          minutes: _currentType == SessionType.work
              ? _workDuration
              : _breakDuration,
        ),
      ),
      duration:
          _currentType == SessionType.work ? _workDuration : _breakDuration,
      type: _currentType,
      completed: true,
    );
    _history.insert(0, session);

    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    final isWork = _currentType == SessionType.work;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isWork ? '🎉 Сессия завершена!' : '☕ Перерыв окончен!',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          isWork
              ? 'Отличная работа! Время для перерыва?'
              : 'Готовы снова за работу?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _switchMode();
            },
            child: Text(
              isWork ? 'Начать перерыв' : 'Начать работу',
              style: const TextStyle(color: Color(0xFFE53935)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetTimer();
            },
            child: const Text(
              'Остаться',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  void _switchMode() {
    setState(() {
      _currentType = _currentType == SessionType.work
          ? SessionType.breakTime
          : SessionType.work;
      _totalSeconds = _currentType == SessionType.work
          ? _workDuration * 60
          : _breakDuration * 60;
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
    });
  }

  void _toggleMode() {
    if (_isRunning) _pauseTimer();
    _switchMode();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_totalSeconds == 0) return 0;
    return (_totalSeconds - _remainingSeconds) / _totalSeconds;
  }

  Future<void> _openSettings() async {
    if (_isRunning) _pauseTimer();

    final result = await Navigator.push<Map<String, int>>(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          workDuration: _workDuration,
          breakDuration: _breakDuration,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _workDuration = result['work']!;
        _breakDuration = result['break']!;
        _resetTimer();
      });
    }
  }

  void _openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryScreen(sessions: _history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWork = _currentType == SessionType.work;
    final accentColor =
        isWork ? const Color(0xFFE53935) : const Color(0xFF43A047);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Таймер Помодоро'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'История',
            onPressed: _openHistory,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Настройки',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Mode toggle
            _buildModeToggle(isWork, accentColor),

            const Spacer(),

            // Circular timer
            _buildCircularTimer(accentColor),

            const Spacer(),

            // Control buttons
            _buildControls(accentColor),

            const SizedBox(height: 16),

            // Session counter
            _buildSessionCounter(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle(bool isWork, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isWork) _toggleMode();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isWork ? accentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Работа',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isWork ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isWork) _toggleMode();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isWork
                      ? const Color(0xFF43A047)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Перерыв',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !isWork ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularTimer(Color accentColor) {
    return ScaleTransition(
      scale: _isRunning ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background circle
            CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12,
              color: accentColor.withOpacity(0.15),
              strokeCap: StrokeCap.round,
            ),
            // Progress circle
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  color: accentColor,
                  strokeCap: StrokeCap.round,
                );
              },
            ),
            // Time text
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentType == SessionType.work
                        ? 'Фокус'
                        : 'Отдых',
                    style: TextStyle(
                      fontSize: 16,
                      color: accentColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        _ControlButton(
          icon: Icons.refresh,
          label: 'Сброс',
          color: Colors.white54,
          onTap: _resetTimer,
          size: 56,
        ),
        const SizedBox(width: 24),
        // Start / Pause button
        _ControlButton(
          icon: _isRunning ? Icons.pause : Icons.play_arrow,
          label: _isRunning ? 'Пауза' : 'Старт',
          color: accentColor,
          onTap: _isRunning ? _pauseTimer : _startTimer,
          size: 80,
          filled: true,
        ),
        const SizedBox(width: 24),
        // Skip button
        _ControlButton(
          icon: Icons.skip_next,
          label: 'Далее',
          color: Colors.white54,
          onTap: _toggleMode,
          size: 56,
        ),
      ],
    );
  }

  Widget _buildSessionCounter() {
    final workCount =
        _history.where((s) => s.type == SessionType.work).length;
    return Text(
      'Завершено сессий: $workCount',
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 14,
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final bool filled;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.size,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: filled ? color : Colors.transparent,
              shape: BoxShape.circle,
              border: filled ? null : Border.all(color: color, width: 2),
            ),
            child: Icon(
              icon,
              color: filled ? Colors.white : color,
              size: size * 0.45,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
