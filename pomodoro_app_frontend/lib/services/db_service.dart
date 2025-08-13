import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/session.dart';

/// PUBLIC_INTERFACE
/// Lightweight SQLite wrapper for storing Pomodoro sessions.
class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  static const _dbName = 'pomodoro_ladder.db';
  static const _dbVersion = 1;
  static const _table = 'sessions';

  Database? _db;

  /// PUBLIC_INTERFACE
  /// Lazily open or create the database.
  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            taskName TEXT,
            durationSeconds INTEGER,
            type TEXT,
            completed INTEGER,
            timestamp INTEGER
          )
        ''');
      },
    );
    return _db!;
  }

  /// PUBLIC_INTERFACE
  /// Insert a session record into the database.
  Future<int> insertSession(Session session) async {
    final db = await database;
    return db.insert(_table, session.toMap());
  }

  /// PUBLIC_INTERFACE
  /// Retrieve recent sessions sorted by newest first.
  Future<List<Session>> getSessions({int limit = 200}) async {
    final db = await database;
    final maps = await db.query(
      _table,
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return maps.map(Session.fromMap).toList();
  }

  /// PUBLIC_INTERFACE
  /// Delete all sessions.
  Future<void> clearSessions() async {
    final db = await database;
    await db.delete(_table);
  }
}
