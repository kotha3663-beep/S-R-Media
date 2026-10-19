import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordVaultScreen extends StatefulWidget {
  const PasswordVaultScreen({super.key});

  @override
  State<PasswordVaultScreen> createState() => _PasswordVaultScreenState();
}

class _PasswordVaultScreenState extends State<PasswordVaultScreen> {
  bool _isObscured = true;
  String _currentPassword = "hospo1234";

  @override
  void initState() {
    super.initState();
    _loadPassword();
  }

  Future<void> _loadPassword() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPassword = prefs.getString('hotspot_password') ?? "hospo1234";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Vault')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.security, size: 80, color: Colors.greenAccent),
            const SizedBox(height: 24),
            const Text(
              'Current Hotspot Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isObscured ? '••••••••' : _currentPassword,
                    style: const TextStyle(fontSize: 22, letterSpacing: 2, fontFamily: 'monospace'),
                  ),
                  IconButton(
                    icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'এই পাসওয়ার্ডটি আপনার হটস্পটে কানেক্ট হওয়ার জন্য ব্যবহার করা হচ্ছে। পাসওয়ার্ড পরিবর্তন করলে QR কোডও অটোমেটিক আপডেট হয়ে যাবে।',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
