import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_limit_service.dart';
import '../models/device_model.dart';
import 'qr_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DataLimitService>().init());
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.read<DataLimitService>().addDevice('192.168.43.10');
        context.read<DataLimitService>().addDevice('192.168.43.25');
      }
    });
  }

  // নিচের নেভিগেশন বার অনুযায়ী স্ক্রিন পরিবর্তন
  final List<Widget> _screens = [
    const _DeviceListWidget(),
    const QrScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.devices), label: 'Devices'),
          NavigationDestination(icon: Icon(Icons.qr_code), label: 'Connect'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// ডিভাইস লিস্ট আলাদা উইজেটে রাখা হলো
class _DeviceListWidget extends StatelessWidget {
  const _DeviceListWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospo Dashboard'),
        centerTitle: true,
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
              return _buildDeviceCard(context, device, service);
            },
          );
        },
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, ConnectedDevice device, DataLimitService service) {
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
                  onPressed: () => _showRenameDialog(context, device, service),
                )
              ],
            ),
            const SizedBox(height: 4),
            Text('IP: ${device.id}', style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 16),
            
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[800],
              color: isLimitReached ? Colors.red : Colors.greenAccent,
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
                    color: isLimitReached ? Colors.red : Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showSetLimitDialog(context, device, service),
                  icon: const Icon(Icons.tune),
                  label: const Text('Set Limit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // MAC ব্লক লজিক
                  },
                  icon: const Icon(Icons.block),
                  label: const Text('Block'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.redAccent,
                    elevation: 0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, ConnectedDevice device, DataLimitService service) {
    TextEditingController controller = TextEditingController(text: device.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Device'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                service.renameDevice(device.id, controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSetLimitDialog(BuildContext context, ConnectedDevice device, DataLimitService service) {
    TextEditingController controller = TextEditingController(text: device.limitMB.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Data Limit'),
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
