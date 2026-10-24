import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('স্বাস্থ্য টিপস'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTipCard('পানি পান', 'প্রতিদিন কমপক্ষে ৮ গ্লাস পানি পান করুন।', Icons.water_drop),
          _buildTipCard('ঘুম', 'প্রতিদিন ৭-৮ ঘণ্টা ঘুমানোর চেষ্টা করুন।', Icons.bedtime),
          _buildTipCard('ব্যায়াম', 'প্রতিদিন অন্তত ৩০ মিনিট হাঁটুন বা ব্যায়াম করুন।', Icons.fitness_center),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.healthAccent.withOpacity(0.1),
          child: Icon(icon, color: AppColors.healthAccent),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
