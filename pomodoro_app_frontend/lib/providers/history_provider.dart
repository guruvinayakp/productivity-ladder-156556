import 'package:flutter/material.dart';
import '../models/session.dart';
import '../services/db_service.dart';

/// PUBLIC_INTERFACE
/// Handles fetching and clearing past sessions for display.
class HistoryProvider extends ChangeNotifier {
  final List<Session> _sessions = [];

  /// PUBLIC_INTERFACE
  List<Session> get sessions => List.unmodifiable(_sessions);

  /// PUBLIC_INTERFACE
  /// Load recent sessions from the database.
  Future<void> load() async {
    final items = await DbService().getSessions(limit: 500);
    _sessions
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  /// PUBLIC_INTERFACE
  /// Clear session history and refresh in-memory list.
  Future<void> clear() async {
    await DbService().clearSessions();
    await load();
  }
}
