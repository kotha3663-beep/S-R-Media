import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/language_service.dart';
import '../models/knowledge_item_model.dart';
import '../data/knowledge_repository.dart';
import 'knowledge_details_screen.dart';
import '../../quiz/screens/quiz_setup_screen.dart';
import '../../quiz/screens/quiz_history_screen.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  final _repository = KnowledgeRepository();
  List<KnowledgeItemModel> _items = [];
  List<KnowledgeItemModel> _filteredItems = [];
  bool _isLoading = true;
  String _lang = 'bn';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final lang = await LanguageService().currentLocale.languageCode;
    final items = await _repository.getItemsByLanguage(lang);
    if (mounted) {
      setState(() {
        _lang = lang;
        _items = items;
        _filteredItems = items;
        _isLoading = false;
      });
    }
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items.where((item) => 
        item.title.toLowerCase().contains(query.toLowerCase()) || 
        item.category.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = _lang == 'bn';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isBn ? 'জ্ঞান ও কুইজ' : 'Knowledge & Quiz'),
          bottom: TabBar(
            labelColor: AppColors.knowledgeAccent,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.knowledgeAccent,
            tabs: [
              Tab(text: isBn ? 'জ্ঞানকোষ' : 'Knowledge'),
              Tab(text: isBn ? 'কুইজ' : 'Quiz'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildKnowledgeTab(isBn),
            _buildQuizTab(isBn),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowledgeTab(bool isBn) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterItems,
            decoration: InputDecoration(
              hintText: isBn ? 'তথ্য খুঁজুন...' : 'Search knowledge...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
        ),
        Expanded(
          child: _filteredItems.isEmpty
              ? Center(child: Text(isBn ? 'কোনো তথ্য পাওয়া যায়নি' : 'No knowledge found'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.knowledgeAccent.withOpacity(0.1),
                          child: const Icon(Icons.lightbulb, color: AppColors.knowledgeAccent),
                        ),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item.category),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          if (!item.isRead && item.id != null) {
                            await _repository.markAsRead(item.id!);
                          }
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => KnowledgeDetailsScreen(item: item)),
                            ).then((_) => _loadData());
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQuizTab(bool isBn) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 80, color: AppColors.knowledgeAccent),
            const SizedBox(height: 24),
            Text(
              isBn ? 'নিজেকে যাচাই করুন' : 'Test Yourself',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              isBn 
                ? 'জ্ঞানকোষ থেকে পড়ে শেখা তথ্যগুলো কুইজ দিয়ে যাচাই করুন। সঠিকতা এবং দ্রুততার উপর ভিত্তি করে স্কোর পাবেন।'
                : 'Test the knowledge you learned from the knowledge base. You will get scores based on accuracy and speed.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizSetupScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.knowledgeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isBn ? 'নতুন কুইজ শুরু করুন' : 'Start New Quiz', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizHistoryScreen()));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.knowledgeAccent,
                  side: const BorderSide(color: AppColors.knowledgeAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isBn ? 'কুইজ ইতিহাস' : 'Quiz History', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
