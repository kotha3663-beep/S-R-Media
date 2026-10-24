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
