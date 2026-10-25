import '../models/game_record_model.dart';
import '../../../core/database/database_helper.dart';

class GameRepository {
  Future<void> saveGameRecord(GameRecordModel record) async {
    final db = await DatabaseHelper.database;
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
    final db = await DatabaseHelper.database;
    final maps = await db.query('game_records', where: 'gameId = ?', whereArgs: [gameId]);
    
    if (maps.isNotEmpty) {
      return GameRecordModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<GameRecordModel>> getAllRecords() async {
    final db = await DatabaseHelper.database;
    final maps = await db.query('game_records');
    return List.generate(maps.length, (i) {
      return GameRecordModel.fromMap(maps[i]);
    });
  }
}
