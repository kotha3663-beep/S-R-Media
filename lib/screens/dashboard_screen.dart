import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_limit_service.dart';
import '../models/device_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // অ্যাপ চালু হলেই ডাটা লোড হবে
    Future.microtask(() => context.read<DataLimitService>().init());
    
    // ডেমো হিসেবে ২টি ডিভাইস অ্যাড করে দিচ্ছি (পরে নেটিভ স্ক্যানার এগুলো দিবে)
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.read<DataLimitService>().addDevice('192.168.43.10');
        context.read<DataLimitService>().addDevice('192.168.43.25');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospo Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              // পরবর্তী ধাপে QR স্ক্রিন আসবে
            },
          )
        ],
      ),
      body: Consumer<DataLimitService>(
        builder: (context, service, child) {
          if (service.devices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: service.devices.length,
            itemBuilder: (context, index) {
              final device = service.devices[index];
              return _buildDeviceCard(device, service);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeviceCard(ConnectedDevice device, DataLimitService service) {
    double progress = device.usedMB / device.limitMB;
    if (progress > 1.0) progress = 1.0;
    
    bool isLimitReached = device.usedMB >= device.limitMB;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  device.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showRenameDialog(device, service),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('IP: ${device.id}', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            
            // প্রোগ্রেস বার
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: isLimitReached ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${device.usedMB.toStringAsFixed(1)} MB / ${device.limitMB.toStringAsFixed(0)} MB'),
                Text(
                  isLimitReached ? 'Blocked' : 'Active',
                  style: TextStyle(
                    color: isLimitReached ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // ডিভাইস ব্লক বা রিমুভ বাটন
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showSetLimitDialog(device, service),
                  icon: const Icon(Icons.tune),
                  label: const Text('Set Limit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // এখানে MAC ব্লক করার লজিক আসবে
                  },
                  icon: const Icon(Icons.block),
                  label: const Text('Block'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(ConnectedDevice device, DataLimitService service) {
    TextEditingController controller = TextEditingController(text: device.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Device'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              service.renameDevice(device.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSetLimitDialog(ConnectedDevice device, DataLimitService service) {
    TextEditingController controller = TextEditingController(text: device.limitMB.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Data Limit (MB)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'MB'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              double limit = double.tryParse(controller.text) ?? 100.0;
              service.setLimit(device.id, limit);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
