import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/ledger_repository.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _repository = LedgerRepository();

  TransactionType _type = TransactionType.expense;
  String _category = 'খাবার';
  DateTime _date = DateTime.now();

  final Map<String, IconData> _expenseCategories = {
    'খাবার': Icons.fastfood,
    'যাতায়াত': Icons.directions_bus,
    'কেনাকাটা': Icons.shopping_bag,
    'বিল': Icons.receipt,
    'চিকিৎসা': Icons.local_hospital,
    'শিক্ষা': Icons.school,
    'অন্যান্য': Icons.category,
  };

  final Map<String, IconData> _incomeCategories = {
    'বেতন': Icons.work,
    'ব্যবসা': Icons.storefront,
    'বিনিয়োগ': Icons.trending_up,
    'উপহার': Icons.card_giftcard,
    'অন্যান্য': Icons.category,
  };

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final transaction = TransactionModel(
        amount: double.parse(_amountController.text),
        type: _type,
        category: _category,
        date: _date,
        note: _noteController.text,
      );

      await _repository.addTransaction(transaction);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == TransactionType.expense ? _expenseCategories : _incomeCategories;
    if (!categories.containsKey(_category)) {
      _category = categories.keys.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('নতুন লেনদেন'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTypeSelector(
                    'আয়',
                    TransactionType.income,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTypeSelector(
                    'ব্যয়',
                    TransactionType.expense,
                    AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'টাকার পরিমাণ',
                prefixIcon: Icon(Icons.monetization_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'পরিমাণ লিখুন';
                }
                if (double.tryParse(value) == null) {
                  return 'সঠিক সংখ্যা লিখুন';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'ক্যাটাগরি',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: categories.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(entry.value, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _category = val);
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'তারিখ',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text('${_date.day}/${_date.month}/${_date.year}'),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'বিবরণ বা নোট',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: _type == TransactionType.income ? AppColors.success : AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('সংরক্ষণ করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(String label, TransactionType type, Color color) {
    final isSelected = _type == type;
    return InkWell(
      onTap: () => setState(() {
        _type = type;
        _category = (type == TransactionType.expense ? _expenseCategories : _incomeCategories).keys.first;
      }),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: isSelected ? color : AppColors.divider),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
