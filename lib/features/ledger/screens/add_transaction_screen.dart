import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/preferences_service.dart';
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
  String _lang = 'bn';

  final List<String> _incomeCategoriesBn = ['বেতন', 'ব্যবসা', 'বিনিয়োগ', 'উপহার', 'অন্যান্য'];
  final List<String> _expenseCategoriesBn = ['খাবার', 'যাতায়াত', 'কেনাকাটা', 'বিল', 'চিকিৎসা', 'শিক্ষা', 'অন্যান্য'];

  final List<String> _incomeCategoriesEn = ['Salary', 'Business', 'Investment', 'Gift', 'Others'];
  final List<String> _expenseCategoriesEn = ['Food', 'Transport', 'Shopping', 'Bills', 'Health', 'Education', 'Others'];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    if (widget.transaction != null) {
      _type = widget.transaction!.type;
      _amountController.text = widget.transaction!.amount.toString();
      _category = widget.transaction!.category;
      _date = widget.transaction!.date;
      _noteController.text = widget.transaction!.note;
    }
  }

  Future<void> _loadLanguage() async {
    final lang = await PreferencesService.getLanguage();
    if (mounted) {
      setState(() {
        _lang = lang;
        if (widget.transaction == null) {
          _category = _type == 'income' 
              ? (_lang == 'bn' ? _incomeCategoriesBn[0] : _incomeCategoriesEn[0])
              : (_lang == 'bn' ? _expenseCategoriesBn[0] : _expenseCategoriesEn[0]);
        }
      });
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
    final isBn = _lang == 'bn';
    final incomeCats = isBn ? _incomeCategoriesBn : _incomeCategoriesEn;
    final expenseCats = isBn ? _expenseCategoriesBn : _expenseCategoriesEn;
    final categories = _type == 'income' ? incomeCats : expenseCats;

    if (!categories.contains(_category)) {
      _category = categories[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null 
            ? (isBn ? 'নতুন লেনদেন' : 'New Transaction') 
            : (isBn ? 'লেনদেন সম্পাদনা' : 'Edit Transaction')),
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
                      onTap: () => setState(() {
                        _type = 'income';
                        _category = incomeCats[0];
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _type == 'income' ? AppColors.ledgerAccent : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.ledgerAccent),
                        ),
                        child: Center(
                          child: Text(
                            isBn ? 'আয়' : 'Income',
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
                        _category = expenseCats[0];
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
                            isBn ? 'ব্যয়' : 'Expense',
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
                decoration: InputDecoration(
                  labelText: isBn ? 'টাকার পরিমাণ' : 'Amount',
                  border: const OutlineInputBorder(),
                  prefixText: '৳ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isBn ? 'পরিমাণ দিন' : 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return isBn ? 'সঠিক সংখ্যা দিন' : 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: isBn ? 'ক্যাটাগরি' : 'Category',
                  border: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: isBn ? 'তারিখ' : 'Date',
                    border: const OutlineInputBorder(),
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
                decoration: InputDecoration(
                  labelText: isBn ? 'বিবরণ বা নোট' : 'Note (Optional)',
                  border: const OutlineInputBorder(),
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
                  child: Text(
                    isBn ? 'সংরক্ষণ করুন' : 'Save', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
