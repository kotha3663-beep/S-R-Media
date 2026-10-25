import '../models/knowledge_item_model.dart';
import '../../../core/database/database_helper.dart';

class KnowledgeRepository {
  Future<List<KnowledgeItemModel>> getItemsByLanguage(String langCode) async {
    final db = await DatabaseHelper.database;
    final maps = await db.query(
      'knowledge_items',
      where: 'languageCode = ?',
      whereArgs: [langCode],
    );
    return List.generate(maps.length, (i) {
      return KnowledgeItemModel.fromMap(maps[i]);
    });
  }

  Future<void> markAsRead(int id) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'knowledge_items',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertInitialDataIfNeeded() async {
    final db = await DatabaseHelper.database;
    final count = await db.query('knowledge_items');
    if (count.isEmpty) {
      // এখানে আপনার আগের ২৪টি তথ্যের লিস্ট বসাবেন
      // (কোড সংক্ষিপ্ত রাখার জন্য আমি এখানে দিচ্ছি না, আপনি আগের knowledge_repository.dart থেকে কপি করে বসাবেন)
    }
  }
}
