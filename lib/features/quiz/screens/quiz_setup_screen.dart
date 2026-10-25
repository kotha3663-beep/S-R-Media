import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import '../data/question_repository.dart';
import 'quiz_play_screen.dart';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  final _repo = QuestionRepository();
  List<String> _categories = [];
  String? _selectedCategory;
  int _questionCount = 5;
  bool _isLoading = true;
  bool _useKnowledgeBase = true;
  String _lang = 'bn';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final lang = await LanguageService().currentLocale.languageCode;
    final cats = await _repo.getCategories(lang);
    if (mounted) {
      setState(() {
        _lang = lang;
        _categories = cats;
        if (cats.isNotEmpty) _selectedCategory = cats.first;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isBn = _lang == 'bn';

    return Scaffold(
      appBar: AppBar(title: Text(isBn ? 'কুইজ সেটআপ' : 'Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isBn ? 'প্রশ্নের ধরন' : 'Question Type', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              color: _useKnowledgeBase ? AppColors.knowledgeAccent.withOpacity(0.1) : Colors.white,
              child: SwitchListTile(
                title: Text(isBn ? 'জ্ঞানকোষ থেকে প্রশ্ন' : 'Questions from Knowledge Base'),
                subtitle: Text(isBn ? 'পড়া তথ্যগুলোর উপর ভিত্তি করে প্রশ্ন' : 'Questions based on read information'),
                value: _useKnowledgeBase,
                activeColor: AppColors.knowledgeAccent,
                onChanged: (val) => setState(() => _useKnowledgeBase = val),
              ),
            ),
            const SizedBox(height: 24),
            Text(isBn ? 'ক্যাটাগরি নির্বাচন করুন' : 'Select Category', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 24),
            Text(isBn ? 'প্রশ্নের সংখ্যা' : 'Number of Questions', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [5, 10, 20].map((count) {
                final isSelected = _questionCount == count;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _questionCount = count),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary : Colors.white,
                        border: Border.all(color: isSelected ? AppColors.secondary : AppColors.divider),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  List<dynamic> questions;
                  if (_useKnowledgeBase) {
                    questions = await _repo.generateQuestionsFromKnowledge(_lang, _selectedCategory, _questionCount);
                  } else {
                    questions = await _repo.getQuestionsByLanguage(_lang, _selectedCategory, _questionCount);
                  }

                  if (questions.isEmpty) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isBn ? 'প্রশ্ন পাওয়া যায়নি' : 'No questions found')),
                      );
                    }
                    return;
                  }
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPlayScreen(
                          questions: questions.cast(),
                          category: _selectedCategory!,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.knowledgeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isBn ? 'কুইজ শুরু করুন' : 'Start Quiz', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
