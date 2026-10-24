import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/health_tip_model.dart';
import '../data/health_repository.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final _repository = HealthRepository();
  List<HealthTipModel> _tips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    setState(() => _isLoading = true);
    final tips = await _repository.getAllTips();
    setState(() {
      _tips = tips;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('স্বাস্থ্য টিপস'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _tips.length,
              itemBuilder: (context, index) {
                final tip = _tips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.healthAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tip.category,
                                style: const TextStyle(color: AppColors.healthAccent, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                tip.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                color: AppColors.secondary,
                              ),
                              onPressed: () async {
                                await _repository.toggleBookmark(tip.id!, !tip.isBookmarked);
                                _loadTips();
                              },
                            ),
                          ],
                        ),
                        Text(
                          tip.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tip.description,
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
