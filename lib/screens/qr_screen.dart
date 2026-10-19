import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  // ডেমো হিসেবে প্রক্সি আইপি এবং পোর্ট (পরে নেটিভ থেকে ডাইনামিক আসবে)
  final String proxyIp = "192.168.43.1";
  final String proxyPort = "8080";
  String wifiPassword = "hospo1234"; // পরে সিস্টেম থেকে রিড করা যাবে

  String get qrData => "WIFI:T:ADB;S:Hospo_Network;P:$wifiPassword;PROXY:$proxyIp:$proxyPort;;";

  void _changePassword() {
    setState(() {
      // ডেমো পাসওয়ার্ড চেঞ্জ
      wifiPassword = "hospo${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password Changed & QR Updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan to Connect')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'অন্যদের ফোনে এই QR কোডটি স্ক্যান করতে বলুন',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // QR কোড জেনারেটর
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 250.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 40),
                const Divider(),
                const SizedBox(height: 16),
                
                // ম্যানুয়াল সেটআপের জন্য IP এবং পোর্ট দেখানো
                const Text('Manual Setup Info (Proxy)', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('IP: $proxyIp', style: const TextStyle(fontSize: 16)),
                Text('Port: $proxyPort', style: const TextStyle(fontSize: 16)),
                Text('Current Wi-Fi Pass: $wifiPassword', style: const TextStyle(fontSize: 16, color: Colors.greenAccent)),
                
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _changePassword,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Change Password & Update QR'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
