import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isProxyEnabled = true;
  bool _notifySuspicious = true;
  final TextEditingController _routerNameController = TextEditingController(text: 'আমার রউটার');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // হটস্পট ফোনের নাম পরিবর্তন
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My Hotspot Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _routerNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hotspot name saved!')),
                      );
                    },
                    child: const Text('Save Name'),
                  )
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // টগল অপশনসমূহ
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Proxy Protection'),
                  subtitle: const Text('রুট ছাড়া ট্রাফিক নিয়ন্ত্রণ চালু রাখুন'),
                  value: _isProxyEnabled,
                  onChanged: (val) => setState(() => _isProxyEnabled = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Suspicious Alert'),
                  subtitle: const Text('কেউ চালাকি করলে নোটিফিকেশন পান'),
                  value: _notifySuspicious,
                  onChanged: (val) => setState(() => _notifySuspicious = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // সিকিউরিটি অপশন
          Card(
            child: ListTile(
              leading: const Icon(Icons.security, color: Colors.greenAccent),
              title: const Text('View Saved Passwords'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // পাসওয়ার্ড দেখার স্ক্রিনে নিয়ে যাবে
              },
            ),
          ),
          
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'Hospo v1.0.0\nMade with ♥',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
