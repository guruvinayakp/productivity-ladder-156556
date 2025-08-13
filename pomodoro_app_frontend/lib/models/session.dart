/// PUBLIC_INTERFACE
enum SessionType { focus, shortBreak, longBreak }

/// PUBLIC_INTERFACE
/// Session model for persistence and UI display.
class Session {
  final int? id;
  final String taskName;
  final int durationSeconds;
  final SessionType type;
  final bool completed;
  final DateTime timestamp;

  Session({
    this.id,
    required this.taskName,
    required this.durationSeconds,
    required this.type,
    required this.completed,
    required this.timestamp,
  });

  /// PUBLIC_INTERFACE
  /// Convert to map for SQLite storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'durationSeconds': durationSeconds,
      'type': type.name,
      'completed': completed ? 1 : 0,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  /// PUBLIC_INTERFACE
  /// Create a Session from a map loaded from SQLite.
  static Session fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as int?,
      taskName: map['taskName'] as String? ?? '',
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      type: _typeFromString(map['type'] as String? ?? 'focus'),
      completed: (map['completed'] as int? ?? 0) == 1,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  static SessionType _typeFromString(String value) {
    switch (value) {
      case 'focus':
        return SessionType.focus;
      case 'shortBreak':
        return SessionType.shortBreak;
      case 'longBreak':
        return SessionType.longBreak;
      default:
        return SessionType.focus;
    }
  }

  /// PUBLIC_INTERFACE
  /// Human readable label.
  String displayLabel() {
    switch (type) {
      case SessionType.focus:
        return 'Focus';
      case SessionType.shortBreak:
        return 'Short Break';
      case SessionType.longBreak:
        return 'Long Break';
    }
  }
}
