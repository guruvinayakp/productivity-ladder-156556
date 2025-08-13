import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';
import '../services/db_service.dart';
import 'board_provider.dart';

/// PUBLIC_INTERFACE
/// Handles timer flow, focus/break durations, streak rewards, and persistence of session history.
class PomodoroProvider extends ChangeNotifier {
  PomodoroProvider({required this.board})
      : _type = SessionType.focus,
        _remaining = const Duration(minutes: 25);

  final BoardProvider board;

  Duration _remaining;
  SessionType _type;
  Timer? _timer;
  bool _isRunning = false;
  String _taskName = '';

  int _consecutiveFocusCompleted = 0;
  int _focusSinceLongBreak = 0;

  // Constants - can be later made configurable in Settings.
  static const Duration focusDuration = Duration(minutes: 25);
  static const Duration shortBreakDuration = Duration(minutes: 5);
  static const Duration longBreakDuration = Duration(minutes: 30);

  /// PUBLIC_INTERFACE
  Duration get remaining => _remaining;

  /// PUBLIC_INTERFACE
  SessionType get type => _type;

  /// PUBLIC_INTERFACE
  bool get isRunning => _isRunning;

  /// PUBLIC_INTERFACE
  String get taskName => _taskName;

  /// PUBLIC_INTERFACE
  int get consecutiveFocusCompleted => _consecutiveFocusCompleted;

  /// PUBLIC_INTERFACE
  void setTaskName(String name) {
    _taskName = name;
    notifyListeners();
  }

  /// PUBLIC_INTERFACE
  /// Start or resume the current timer. If not running, sets a periodic countdown.
  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _saveInSessionFlag(true);
    _timer ??= Timer.periodic(const Duration(seconds: 1), _onTick);
    notifyListeners();
  }

  /// PUBLIC_INTERFACE
  /// Pause the timer without resetting.
  void pause() {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    _saveInSessionFlag(false);
    notifyListeners();
  }

  /// PUBLIC_INTERFACE
  /// Stop the timer and reset to defaults. If interrupted during focus, reset board and streak.
  void stopAndReset({bool interrupted = false}) {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _saveInSessionFlag(false);

    if (_type == SessionType.focus && interrupted) {
      // Interruption penalty: return to start and reset streak.
      board.resetToStart();
      _consecutiveFocusCompleted = 0;
      _focusSinceLongBreak = 0;
    }

    _type = SessionType.focus;
    _remaining = focusDuration;
    notifyListeners();
  }

  void _onTick(Timer timer) {
    if (_remaining.inSeconds <= 1) {
      _completeCurrent();
    } else {
      _remaining -= const Duration(seconds: 1);
      notifyListeners();
    }
  }

  Future<void> _completeCurrent() async {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _saveInSessionFlag(false);

    // Persist session
    await DbService().insertSession(Session(
      taskName: _type == SessionType.focus ? (_taskName.isEmpty ? 'Untitled Task' : _taskName) : 'Break',
      durationSeconds: _durationForType(_type).inSeconds,
      type: _type,
      completed: true,
      timestamp: DateTime.now(),
    ));

    if (_type == SessionType.focus) {
      _consecutiveFocusCompleted += 1;
      _focusSinceLongBreak += 1;

      // Allow dice roll after completing focus session.
      board.enableDice();

      // Streak reward after every 3 consecutive focus sessions.
      if (_consecutiveFocusCompleted % 3 == 0) {
        board.rewardRandomLadder();
      }

      // Schedule break
      if (_focusSinceLongBreak >= 3) {
        _type = SessionType.longBreak;
        _remaining = longBreakDuration;
        _focusSinceLongBreak = 0;
      } else {
        _type = SessionType.shortBreak;
        _remaining = shortBreakDuration;
      }
      // Auto-start break
      start();
    } else {
      // After break, reset to focus
      _type = SessionType.focus;
      _remaining = focusDuration;
      notifyListeners();
    }
  }

  Duration _durationForType(SessionType t) {
    switch (t) {
      case SessionType.focus:
        return focusDuration;
      case SessionType.shortBreak:
        return shortBreakDuration;
      case SessionType.longBreak:
        return longBreakDuration;
    }
  }

  Future<void> _saveInSessionFlag(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    // Used to penalize leaving the app during focus.
    await prefs.setBool('inSession', value && _type == SessionType.focus);
  }

  /// PUBLIC_INTERFACE
  /// Called when app goes to background. If in focus and running, treat as interruption.
  Future<void> handleAppBackgrounded() async {
    if (_type == SessionType.focus && _isRunning) {
      stopAndReset(interrupted: true);
    }
  }
}
