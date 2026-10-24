import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/preferences_service.dart';
import '../models/knowledge_item_model.dart';
import '../data/knowledge_repository.dart';
import '../../quiz/screens/quiz_setup_screen.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  final _repository = KnowledgeRepository();
  List<KnowledgeItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final lang = await PreferencesService.getLanguage();
    final items = await _repository.getItemsByLanguage(lang);
    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('জ্ঞান ও কুইজ'),
          bottom: const TabBar(
            labelColor: AppColors.knowledgeAccent,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.knowledgeAccent,
            tabs: [
              Tab(text: 'জ্ঞানকোষ'),
              Tab(text: 'কুইজ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildKnowledgeList(),
            _buildQuizTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 80, color: AppColors.knowledgeAccent),
            const SizedBox(height: 24),
            const Text(
              'নিজেকে যাচাই করুন',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            const Text(
              'জ্ঞানকোষ থেকে পড়ে শেখা তথ্যগুলো কুইজ দিয়ে যাচাই করুন। সঠিকতা এবং দ্রুততার উপর ভিত্তি করে স্কোর পাবেন।',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizSetupScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.knowledgeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('কুইজ শুরু করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowledgeList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return const Center(child: Text('কোনো তথ্য পাওয়া যায়নি'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            subtitle: Text(item.category, style: const TextStyle(color: AppColors.textSecondary)),
            iconColor: AppColors.knowledgeAccent,
            collapsedIconColor: AppColors.textSecondary,
            onExpansionChanged: (expanded) async {
              if (expanded && !item.isRead) {
                await _repository.markAsRead(item.id!);
              }
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.body,
                      style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.knowledgeAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.knowledgeAccent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.keyPoint,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.knowledgeAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
