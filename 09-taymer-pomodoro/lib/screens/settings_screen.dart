import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final int workDuration;
  final int breakDuration;

  const SettingsScreen({
    super.key,
    required this.workDuration,
    required this.breakDuration,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _workDuration;
  late double _breakDuration;

  @override
  void initState() {
    super.initState();
    _workDuration = widget.workDuration.toDouble();
    _breakDuration = widget.breakDuration.toDouble();
  }

  void _saveAndReturn() {
    Navigator.pop(context, {
      'work': _workDuration.round(),
      'break': _breakDuration.round(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Work duration
            _buildSettingsCard(
              icon: Icons.work_outline,
              title: 'Время работы',
              value: '${_workDuration.round()} мин',
              color: const Color(0xFFE53935),
              slider: Slider(
                value: _workDuration,
                min: 15,
                max: 45,
                divisions: 30,
                activeColor: const Color(0xFFE53935),
                inactiveColor: const Color(0xFFE53935).withOpacity(0.2),
                label: '${_workDuration.round()} мин',
                onChanged: (value) {
                  setState(() => _workDuration = value);
                },
              ),
              minLabel: '15 мин',
              maxLabel: '45 мин',
            ),

            const SizedBox(height: 24),

            // Break duration
            _buildSettingsCard(
              icon: Icons.coffee_outlined,
              title: 'Время перерыва',
              value: '${_breakDuration.round()} мин',
              color: const Color(0xFF43A047),
              slider: Slider(
                value: _breakDuration,
                min: 3,
                max: 15,
                divisions: 12,
                activeColor: const Color(0xFF43A047),
                inactiveColor: const Color(0xFF43A047).withOpacity(0.2),
                label: '${_breakDuration.round()} мин',
                onChanged: (value) {
                  setState(() => _breakDuration = value);
                },
              ),
              minLabel: '3 мин',
              maxLabel: '15 мин',
            ),

            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveAndReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Сохранить',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Widget slider,
    required String minLabel,
    required String maxLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          slider,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(minLabel,
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
                Text(maxLabel,
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
