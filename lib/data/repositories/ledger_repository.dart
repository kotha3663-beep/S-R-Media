import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class LedgerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> addTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await _dbHelper.database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<double> getTotalBalance() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT 
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as total_income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as total_expense
      FROM transactions
    ''');
    
    if (result.isNotEmpty) {
      final totalIncome = (result.first['total_income'] as num?)?.toDouble() ?? 0.0;
      final totalExpense = (result.first['total_expense'] as num?)?.toDouble() ?? 0.0;
      return totalIncome - totalExpense;
    }
    return 0.0;
  }

  Future<Map<String, double>> getIncomeAndExpense() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT 
        SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as total_income,
        SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as total_expense
      FROM transactions
    ''');

    if (result.isNotEmpty) {
      return {
        'income': (result.first['total_income'] as num?)?.toDouble() ?? 0.0,
        'expense': (result.first['total_expense'] as num?)?.toDouble() ?? 0.0,
      };
    }
    return {'income': 0.0, 'expense': 0.0};
  }
}
