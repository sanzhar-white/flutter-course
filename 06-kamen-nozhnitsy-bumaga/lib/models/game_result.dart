enum Choice {
  rock,
  scissors,
  paper;

  String get emoji {
    switch (this) {
      case Choice.rock:
        return '🪨';
      case Choice.scissors:
        return '✂️';
      case Choice.paper:
        return '📄';
    }
  }

  String get label {
    switch (this) {
      case Choice.rock:
        return 'Камень';
      case Choice.scissors:
        return 'Ножницы';
      case Choice.paper:
        return 'Бумага';
    }
  }
}

enum Outcome {
  win,
  lose,
  draw;

  String get label {
    switch (this) {
      case Outcome.win:
        return 'Вы выиграли!';
      case Outcome.lose:
        return 'Вы проиграли!';
      case Outcome.draw:
        return 'Ничья!';
    }
  }

  String get emoji {
    switch (this) {
      case Outcome.win:
        return '🎉';
      case Outcome.lose:
        return '😔';
      case Outcome.draw:
        return '🤝';
    }
  }
}

class GameResult {
  final Choice playerChoice;
  final Choice computerChoice;
  final Outcome outcome;

  const GameResult({
    required this.playerChoice,
    required this.computerChoice,
    required this.outcome,
  });
}

class ScoreBoard {
  int wins;
  int losses;
  int draws;

  ScoreBoard({
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
  });

  int get totalGames => wins + losses + draws;

  void record(Outcome outcome) {
    switch (outcome) {
      case Outcome.win:
        wins++;
        break;
      case Outcome.lose:
        losses++;
        break;
      case Outcome.draw:
        draws++;
        break;
    }
  }

  void reset() {
    wins = 0;
    losses = 0;
    draws = 0;
  }
}
