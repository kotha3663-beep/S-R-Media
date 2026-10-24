import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/ledger_repository.dart';
import 'add_transaction_screen.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  final LedgerRepository _repository = LedgerRepository();
  List<TransactionModel> _transactions = [];
  double _balance = 0.0;
  double _income = 0.0;
  double _expense = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final transactions = await _repository.getAllTransactions();
    final summary = await _repository.getIncomeAndExpense();
    
    setState(() {
      _transactions = transactions;
      _income = summary['income'] ?? 0.0;
      _expense = summary['expense'] ?? 0.0;
      _balance = _income - _expense;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('হিসাবের খাতা'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: Column(
                children: [
                  _buildSummaryCard(),
                  Expanded(
                    child: _transactions.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final tx = _transactions[index];
                              return _buildTransactionItem(tx);
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
          if (result == true) {
            _loadData();
          }
        },
        backgroundColor: AppColors.ledgerAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'মোট ব্যালেন্স',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(_balance),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('আয়', _income, AppColors.success),
              Container(width: 1, height: 40, color: AppColors.divider),
              _buildSummaryItem('ব্যয়', _expense, AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(
          Formatters.formatCurrency(amount),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'কোনো লেনদেন নেই',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    final isIncome = tx.type == TransactionType.income;
    final color = isIncome ? AppColors.success : AppColors.error;

    return Dismissible(
      key: Key(tx.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        await _repository.deleteTransaction(tx.id!);
        _loadData();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
            ),
          ),
          title: Text(tx.category, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${Formatters.formatDate(tx.date)} • ${tx.note}'),
          trailing: Text(
            '${isIncome ? '+' : '-'}${Formatters.formatCurrency(tx.amount)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
