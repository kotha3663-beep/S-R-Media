import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/transaction_model.dart';

class MonthlyReportScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String lang;

  const MonthlyReportScreen({super.key, required this.transactions, required this.lang});

  @override
  Widget build(BuildContext context) {
    final isBn = lang == 'bn';
    
    // ক্যাটাগরি অনুযায়ী খরচ গ্রুপ করা
    final Map<String, double> expenseByCategory = {};
    final Map<String, double> incomeByCategory = {};
    
    for (var tx in transactions) {
      if (tx.type == 'expense') {
        expenseByCategory[tx.category] = (expenseByCategory[tx.category] ?? 0) + tx.amount;
      } else {
        incomeByCategory[tx.category] = (incomeByCategory[tx.category] ?? 0) + tx.amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'মাসিক রিপোর্ট' : 'Monthly Report'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            isBn ? 'খরচের খাতাসমূহ' : 'Expense Breakdown',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          if (expenseByCategory.isEmpty)
            Text(isBn ? 'কোনো খরচ নেই' : 'No expenses')
          else
            ...expenseByCategory.entries.map((e) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(
                    '৳ ${e.value.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.healthAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            }),
            
          const SizedBox(height: 32),
          Text(
            isBn ? 'আয়ের খাতাসমূহ' : 'Income Breakdown',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          if (incomeByCategory.isEmpty)
            Text(isBn ? 'কোনো আয় নেই' : 'No income')
          else
            ...incomeByCategory.entries.map((e) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(
                    '৳ ${e.value.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.ledgerAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
