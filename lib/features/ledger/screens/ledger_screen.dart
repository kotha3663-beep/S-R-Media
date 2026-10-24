import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import '../models/transaction_model.dart';
import '../data/ledger_repository.dart';
import 'add_transaction_screen.dart';
import 'monthly_report_screen.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  final _repository = LedgerRepository();
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String _lang = 'bn';

  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final lang = await LanguageService().currentLocale.languageCode;
    final data = await _repository.getAllTransactions();
    
    double income = 0.0;
    double expense = 0.0;
    
    for (var tx in data) {
      if (tx.type == 'income') {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    if (mounted) {
      setState(() {
        _lang = lang;
        _transactions = data;
        _totalIncome = income;
        _totalExpense = expense;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double balance = _totalIncome - _totalExpense;
    final isBn = _lang == 'bn';

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'হিসাবের খাতা' : 'Ledger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_outline),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => MonthlyReportScreen(transactions: _transactions, lang: _lang))
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isBn ? 'বর্তমান ব্যালেন্স' : 'Current Balance', 
                        style: const TextStyle(color: Colors.white70, fontSize: 16)
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '৳ ${balance.toStringAsFixed(2)}', 
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(isBn ? 'মোট আয়' : 'Total Income', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                              Text(
                                '৳ ${_totalIncome.toStringAsFixed(2)}', 
                                style: const TextStyle(color: AppColors.ledgerAccent, fontSize: 18, fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(isBn ? 'মোট ব্যয়' : 'Total Expense', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                              Text(
                                '৳ ${_totalExpense.toStringAsFixed(2)}', 
                                style: const TextStyle(color: AppColors.healthAccent, fontSize: 18, fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final res = await Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (_) => const AddTransactionScreen())
                            );
                            if (res == true) _loadData();
                          },
                          icon: const Icon(Icons.add),
                          label: Text(isBn ? 'নতুন লেনদেন' : 'Add Transaction'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isBn ? 'সাম্প্রতিক লেনদেন' : 'Recent Transactions', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _transactions.isEmpty
                      ? Center(
                          child: Text(
                            isBn ? 'কোনো লেনদেন নেই' : 'No transactions yet', 
                            style: const TextStyle(color: AppColors.textSecondary)
                          )
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final tx = _transactions[index];
                            final isIncome = tx.type == 'income';
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: (isIncome ? AppColors.ledgerAccent : AppColors.healthAccent).withOpacity(0.2),
                                  child: Icon(
                                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                    color: isIncome ? AppColors.ledgerAccent : AppColors.healthAccent,
                                  ),
                                ),
                                title: Text(tx.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  "${tx.date.day}/${tx.date.month}/${tx.date.year} ${tx.note.isNotEmpty ? '- ${tx.note}' : ''}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  '${isIncome ? '+' : '-'} ৳${tx.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isIncome ? AppColors.ledgerAccent : AppColors.healthAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () async {
                                  final res = await Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (_) => AddTransactionScreen(transaction: tx))
                                  );
                                  if (res == true) _loadData();
                                },
                                onLongPress: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(isBn ? 'মুছে ফেলুন' : 'Delete'),
                                      content: Text(isBn ? 'আপনি কি নিশ্চিত?' : 'Are you sure?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text(isBn ? 'না' : 'No'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(isBn ? 'হ্যাঁ' : 'Yes', style: const TextStyle(color: AppColors.error)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true && tx.id != null) {
                                    await _repository.deleteTransaction(tx.id!);
                                    _loadData();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
