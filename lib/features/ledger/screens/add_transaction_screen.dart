import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/transaction_model.dart';
import '../data/ledger_repository.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _repository = LedgerRepository();

  String _type = 'income';
  String _category = 'বেতন';
  DateTime _date = DateTime.now();

  final List<String> _incomeCategories = ['বেতন', 'ব্যবসা', 'বিনিয়োগ', 'উপহার', 'অন্যান্য'];
  final List<String> _expenseCategories = ['খাবার', 'যাতায়াত', 'কেনাকাটা', 'বিল', 'চিকিৎসা', 'শিক্ষা', 'অন্যান্য'];

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _type = widget.transaction!.type;
      _amountController.text = widget.transaction!.amount.toString();
      _category = widget.transaction!.category;
      _date = widget.transaction!.date;
      _noteController.text = widget.transaction!.note;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final newTransaction = TransactionModel(
        id: widget.transaction?.id,
        type: _type,
        amount: double.parse(_amountController.text),
        category: _category,
        date: _date,
        note: _noteController.text,
      );

      if (widget.transaction == null) {
        await _repository.insertTransaction(newTransaction);
      } else {
        await _repository.updateTransaction(newTransaction);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == 'income' ? _incomeCategories : _expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? 'নতুন লেনদেন' : 'লেনদেন সম্পাদনা'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = 'income'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _type == 'income' ? AppColors.ledgerAccent : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.ledgerAccent),
                        ),
                        child: Center(
                          child: Text(
                            'আয়',
                            style: TextStyle(
                              color: _type == 'income' ? Colors.white : AppColors.ledgerAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _type = 'expense';
                        _category = _expenseCategories[0];
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _type == 'expense' ? AppColors.healthAccent : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.healthAccent),
                        ),
                        child: Center(
                          child: Text(
                            'ব্যয়',
                            style: TextStyle(
                              color: _type == 'expense' ? Colors.white : AppColors.healthAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
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
                  border: OutlineInputBorder(),
                  prefixText: '৳ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'পরিমাণ দিন';
                  }
                  if (double.tryParse(value) == null) {
                    return 'সঠিক সংখ্যা দিন';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'ক্যাটাগরি',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'তারিখ',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_date.day}/${_date.month}/${_date.year}"),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'বিবরণ বা নোট',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('সংরক্ষণ করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
