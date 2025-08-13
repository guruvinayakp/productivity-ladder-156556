import 'dart:math';
import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
/// Board state and dice operations for Snakes & Ladders mechanics.
class BoardProvider extends ChangeNotifier {
  BoardProvider();

  // 10x10 board positions 1..100
  int _position = 1;
  bool _canRollDice = false;
  int? _lastDice;

  final Map<int, int> _ladders = const {
    2: 38,
    7: 14,
    8: 31,
    15: 26,
    21: 42,
    28: 84,
    36: 44,
    51: 67,
    71: 91,
    78: 98,
  };

  final Map<int, int> _snakes = const {
    16: 6,
    46: 25,
    49: 11,
    62: 19,
    64: 60,
    74: 53,
    89: 68,
    92: 88,
    95: 75,
    99: 80,
  };

  /// PUBLIC_INTERFACE
  int get position => _position;

  /// PUBLIC_INTERFACE
  bool get canRollDice => _canRollDice;

  /// PUBLIC_INTERFACE
  int? get lastDice => _lastDice;

  /// PUBLIC_INTERFACE
  /// Enable dice rolling (typically after completing a focus session).
  void enableDice() {
    _canRollDice = true;
    notifyListeners();
  }

  /// PUBLIC_INTERFACE
  /// Reset board position and disable dice.
  void resetToStart() {
    _position = 1;
    _lastDice = null;
    _canRollDice = false;
    notifyListeners();
  }

  /// PUBLIC_INTERFACE
  /// Roll a six-faced dice, move the token and apply snakes/ladders.
  int rollDiceAndMove() {
    if (!_canRollDice) return _position;
    final rnd = Random();
    final roll = rnd.nextInt(6) + 1;
    _lastDice = roll;
    _moveBy(roll);
    _canRollDice = false;
    notifyListeners();
    return roll;
  }

  void _moveBy(int steps) {
    int next = _position + steps;
    if (next > 100) next = 100;
    // Apply ladders first
    if (_ladders.containsKey(next)) {
      next = _ladders[next]!;
    }
    // Apply snakes
    if (_snakes.containsKey(next)) {
      next = _snakes[next]!;
    }
    _position = next;
  }

  /// PUBLIC_INTERFACE
  /// Random ladder climb reward as streak bonus.
  void rewardRandomLadder() {
    final ladderKeys = _ladders.keys.toList();
    ladderKeys.shuffle();
    // Find a ladder that moves forward from current pos if possible
    for (final foot in ladderKeys) {
      final head = _ladders[foot]!;
      if (head > _position) {
        _position = head;
        notifyListeners();
        return;
      }
    }
    // Fallback: move forward by 3
    _position = (_position + 3).clamp(1, 100);
    notifyListeners();
  }

  /// PUBLIC_INTERFACE
  Map<int, int> get ladders => Map.unmodifiable(_ladders);

  /// PUBLIC_INTERFACE
  Map<int, int> get snakes => Map.unmodifiable(_snakes);
}
