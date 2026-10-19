import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_model.dart';

class DataLimitService extends ChangeNotifier {
  List<ConnectedDevice> _devices = [];
  List<ConnectedDevice> get devices => _devices;

  Timer? _trackerTimer;

  // অ্যাপ চালু হওয়ার সময় ডাটা লোড করা
  Future<void> init() async {
    await _loadFromStorage();
    startTracking();
  }

  // নতুন ডিভাইস অ্যাড করা (নেটিভ স্ক্যানার থেকে আসবে)
  void addDevice(String id) {
    if (!_devices.any((d) => d.id == id)) {
      _devices.add(ConnectedDevice(id: id, name: 'Unknown Device'));
      notifyListeners();
      _saveToStorage();
    }
  }

  // লিমিট সেট করা
  Future<void> setLimit(String id, double limit) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      _devices[index].limitMB = limit;
      notifyListeners();
      await _saveToStorage();
    }
  }

  // নাম পরিবর্তন
  Future<void> renameDevice(String id, String newName) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      _devices[index].name = newName;
      notifyListeners();
      await _saveToStorage();
    }
  }

  // ট্র্যাকিং শুরু (আপাতত ডেমো সিমুলেশন, পরে নেটিভ প্রক্সি থেকে আসবে)
  void startTracking() {
    _trackerTimer?.cancel();
    _trackerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _simulateTraffic();
    });
  }

  void _simulateTraffic() {
    bool hasChanged = false;
    for (var device in _devices) {
      if (device.usedMB < device.limitMB) {
        device.usedMB += 0.2; // সিমুলেশন: প্রতি সেকেন্ডে 0.2 MB খরচ
        hasChanged = true;
      } else {
        // লিমিট শেষ, এখানে নেটিভ কোডে ইন্টারনেট ব্লক হবে
      }
    }
    if (hasChanged) notifyListeners();
  }

  // ওয়াইফাই অফ-অন করলেও ডাটা সেভ থাকবে
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(_devices.map((e) => e.toJson()).toList());
    await prefs.setString('hospo_devices', jsonString);
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('hospo_devices');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _devices = decoded.map((e) => ConnectedDevice.fromJson(e)).toList();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _trackerTimer?.cancel();
    super.dispose();
  }
}
