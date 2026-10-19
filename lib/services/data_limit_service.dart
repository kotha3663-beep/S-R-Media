import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLimitService extends ChangeNotifier {
  // এটি আমাদের অ্যাপের মূল ডাটা হোল্ডার
  final Map<String, double> _deviceUsage = {}; // IP/MAC -> ব্যবহৃত MB
  final Map<String, double> _deviceLimits = {}; // IP/MAC -> লিমিট MB
  final Map<String, String> _deviceNames = {};  // IP/MAC -> কাস্টম নাম

  Timer? _trackerTimer;

  // ডিভাইসের বর্তমান ডাটা (MB) নিয়ে আসা
  double getUsage(String deviceId) => _deviceUsage[deviceId] ?? 0.0;

  // ডিভাইসের সেট করা লিমিট (MB) নিয়ে আসা
  double getLimit(String deviceId) => _deviceLimits[deviceId] ?? 100.0; // ডিফল্ট ১০০ MB

  // ডিভাইসের নাম নিয়ে আসা
  String getDeviceName(String deviceId) => _deviceNames[deviceId] ?? deviceId;

  // নতুন ডিভাইস লিমিট সেট করা
  Future<void> setLimit(String deviceId, double limitInMB) async {
    _deviceLimits[deviceId] = limitInMB;
    notifyListeners();
    await _saveToStorage();
  }

  // ডিভাইসের নাম পরিবর্তন করা
  Future<void> setDeviceName(String deviceId, String newName) async {
    _deviceNames[deviceId] = newName;
    notifyListeners();
    await _saveToStorage();
  }

  // ট্র্যাকিং শুরু করা (এখানে আমরা সিমুলেট করছি, পরে এটি Native Proxy থেকে ডাটা নিবে)
  void startTracking() {
    _trackerTimer?.cancel();
    _trackerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // TODO: এখানে পরে Kotlin (Android Native) থেকে আসল ডাটা আসবে
      // আপাতত আমরা ডেমো হিসেবে কিছু ডাটা বাড়াচ্ছি
      _simulateTraffic();
    });
  }

  // ডেমো ট্র্যাফিক সিমুলেশন (পরে এটি সরিয়ে আসল ডাটা যুক্ত হবে)
  void _simulateTraffic() {
    bool hasChanged = false;
    for (var deviceId in _deviceLimits.keys) {
      double currentUsage = getUsage(deviceId);
      double limit = getLimit(deviceId);
      
      if (currentUsage < limit) {
        // প্রতি সেকেন্ডে র‍্যান্ডম ০.১ থেকে ০.৫ MB যোগ হচ্ছে
        _deviceUsage[deviceId] = currentUsage + 0.2; 
        hasChanged = true;
      }
    }
    if (hasChanged) {
      notifyListeners();
    }
  }

  // স্টোরেজে সেভ করা (যাতে ওয়াইফাই অন-অফ বা অ্যাপ রিস্টার্টে ডাটা মুছে না যায়)
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Maps to Lists for saving
    List<String> usageList = _deviceUsage.entries.map((e) => '${e.key}:${e.value}').toList();
    List<String> limitList = _deviceLimits.entries.map((e) => '${e.key}:${e.value}').toList();
    List<String> nameList = _deviceNames.entries.map((e) => '${e.key}:${e.value}').toList();

    await prefs.setStringList('device_usage', usageList);
    await prefs.setStringList('device_limits', limitList);
    await prefs.setStringList('device_names', nameList);
  }

  // স্টোরেজ থেকে লোড করা
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    final usageList = prefs.getStringList('device_usage') ?? [];
    final limitList = prefs.getStringList('device_limits') ?? [];
    final nameList = prefs.getStringList('device_names') ?? [];

    _deviceUsage.clear();
    _deviceLimits.clear();
    _deviceNames.clear();

    for (var item in usageList) {
      final parts = item.split(':');
      if (parts.length == 2) _deviceUsage[parts[0]] = double.parse(parts[1]);
    }
    for (var item in limitList) {
      final parts = item.split(':');
      if (parts.length == 2) _deviceLimits[parts[0]] = double.parse(parts[1]);
    }
    for (var item in nameList) {
      final parts = item.split(':');
      if (parts.length == 2) _deviceNames[parts[0]] = parts[1];
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _trackerTimer?.cancel();
    super.dispose();
  }
}
