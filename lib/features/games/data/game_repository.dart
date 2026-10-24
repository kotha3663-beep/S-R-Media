import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game_record_model.dart';

class GameRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mywork_games.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE game_records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            gameId TEXT UNIQUE,
            highScore INTEGER,
            lastLevel INTEGER,
            lastPlayed TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveGameRecord(GameRecordModel record) async {
    final db = await database;
    final existing = await db.query('game_records', where: 'gameId = ?', whereArgs: [record.gameId]);
    
    if (existing.isEmpty) {
      await db.insert('game_records', record.toMap());
    } else {
      await db.update(
        'game_records',
        record.toMap(),
        where: 'gameId = ?',
        whereArgs: [record.gameId],
      );
    }
  }

  Future<GameRecordModel?> getGameRecord(String gameId) async {
    final db = await database;
    final maps = await db.query('game_records', where: 'gameId = ?', whereArgs: [gameId]);
    
    if (maps.isNotEmpty) {
      return GameRecordModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<GameRecordModel>> getAllRecords() async {
    final db = await database;
    final maps = await db.query('game_records');
    return List.generate(maps.length, (i) {
      return GameRecordModel.fromMap(maps[i]);
    });
  }
}
