import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_result.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final ScoreBoard _score = ScoreBoard();
  GameResult? _lastResult;
  bool _isAnimating = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Outcome _determineOutcome(Choice player, Choice computer) {
    if (player == computer) {
      return Outcome.draw;
    }

    if ((player == Choice.rock && computer == Choice.scissors) ||
        (player == Choice.scissors && computer == Choice.paper) ||
        (player == Choice.paper && computer == Choice.rock)) {
      return Outcome.win;
    }

    return Outcome.lose;
  }

  void _play(Choice playerChoice) {
    if (_isAnimating) return;

    final computerChoice = Choice.values[_random.nextInt(Choice.values.length)];
    final outcome = _determineOutcome(playerChoice, computerChoice);

    setState(() {
      _isAnimating = true;
      _lastResult = GameResult(
        playerChoice: playerChoice,
        computerChoice: computerChoice,
        outcome: outcome,
      );
      _score.record(outcome);
    });

    _animationController.reset();
    _animationController.forward().then((_) {
      setState(() {
        _isAnimating = false;
      });
    });
  }

  void _resetScore() {
    setState(() {
      _score.reset();
      _lastResult = null;
    });
  }

  Color _getOutcomeColor(Outcome outcome) {
    switch (outcome) {
      case Outcome.win:
        return Colors.green;
      case Outcome.lose:
        return Colors.red;
      case Outcome.draw:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Камень-Ножницы-Бумага',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _resetScore,
            icon: const Icon(Icons.refresh),
            tooltip: 'Сбросить счёт',
          ),
        ],
      ),
      body: Column(
        children: [
          // Score board
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreItem(
                  'Победы',
                  _score.wins,
                  Colors.greenAccent,
                ),
                _buildDivider(),
                _buildScoreItem(
                  'Ничьи',
                  _score.draws,
                  Colors.orangeAccent,
                ),
                _buildDivider(),
                _buildScoreItem(
                  'Поражения',
                  _score.losses,
                  Colors.redAccent,
                ),
              ],
            ),
          ),

          // Result area
          Expanded(
            child: _lastResult != null
                ? _buildResultArea()
                : _buildWelcomeArea(),
          ),

          // Choice buttons
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const Text(
                  'Выберите ваш ход:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Choice.values
                      .map((choice) => _buildChoiceButton(choice))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white12,
    );
  }

  Widget _buildWelcomeArea() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🪨  📄  ✂️',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 24),
          Text(
            'Сделайте свой выбор!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Нажмите на одну из кнопок ниже',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultArea() {
    final result = _lastResult!;
    final outcomeColor = _getOutcomeColor(result.outcome);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Choices face-off
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Player choice
                  Column(
                    children: [
                      const Text(
                        'Вы',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            result.playerChoice.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.playerChoice.label,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // VS
                  const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Computer choice
                  Column(
                    children: [
                      const Text(
                        'Компьютер',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            result.computerChoice.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.computerChoice.label,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Result text
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                decoration: BoxDecoration(
                  color: outcomeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: outcomeColor.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      result.outcome.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      result.outcome.label,
                      style: TextStyle(
                        color: outcomeColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Total games
              Text(
                'Всего игр: ${_score.totalGames}',
                style: const TextStyle(
                  color: Colors.white30,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(Choice choice) {
    return GestureDetector(
      onTap: () => _play(choice),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              choice.emoji,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 4),
            Text(
              choice.label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
