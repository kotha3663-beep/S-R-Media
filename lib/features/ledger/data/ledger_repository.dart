import '../models/transaction_model.dart';
import '../../../core/database/database_helper.dart';

class LedgerRepository {
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await DatabaseHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await DatabaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  Future<int> deleteTransaction(int id) async {
    final db = await DatabaseHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await DatabaseHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}
