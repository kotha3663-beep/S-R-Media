import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/device_model.dart';

class SuspiciousTrackerService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // ডিভাইস আইডি (MAC/IP) -> শেষ কবে প্রক্সি ট্রাফিক পাঠিয়েছে (Timestamp)
  final Map<String, DateTime> _lastProxyActivity = {};
  
  // যে ডিভাইসগুলো সন্দেহভাজন হিসেবে চিহ্নিত হয়েছে
  final Set<String> _flaggedDevices = {};

  Timer? _monitorTimer;

  // নোটিফিকেশন ইনিশিয়ালাইজ করা
  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // আপনার আইকন এখানে সেট হবে
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await _notificationsPlugin.initialize(initializationSettings);
  }

  // প্রক্সি ট্র্যাকিং শুরু করা
  void startMonitoring(List<ConnectedDevice> connectedDevices) {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkForBypass(connectedDevices);
    });
  }

  // যখনই কোনো ডিভাইস প্রক্সির মাধ্যমে ডাটা পাঠাবে, এই ফাংশনটি কল হবে (Native থেকে)
  void updateProxyActivity(String deviceId) {
    _lastProxyActivity[deviceId] = DateTime.now();
    
    // যদি আগে সন্দেহভাজন ছিল, কিন্তু এখন প্রক্সি ব্যবহার করছে, তবে ফ্ল্যাগ সরিয়ে দেবো
    if (_flaggedDevices.contains(deviceId)) {
      _flaggedDevices.remove(deviceId);
      notifyListeners();
    }
  }

  // মূল চেকিং লজিক: কে কানেক্টেড আছে কিন্তু প্রক্সি ব্যবহার করছে না
  void _checkForBypass(List<ConnectedDevice> connectedDevices) {
    final now = DateTime.now();
    
    for (var device in connectedDevices) {
      // যদি ডিভাইসটি হটস্পটে কানেক্টেড থাকে
      if (device.isProxyBypassed == false) {
        final lastActive = _lastProxyActivity[device.id];
        
        // যদি ২০ সেকেন্ডের বেশি সময় ধরে কোনো প্রক্সি ট্রাফিক না আসে
        if (lastActive == null || now.difference(lastActive).inSeconds > 20) {
          
          if (!_flaggedDevices.contains(device.id)) {
            _flaggedDevices.add(device.id);
            
            // অ্যাপের UI আপডেট করা (ডিভাইসটিকে সন্দেহভাজন মার্ক করা)
            device.isProxyBypassed = true; 
            
            // ইউজারকে নোটিফিকেশন পাঠানো
            _sendNotification(device.name, device.id);
            
            notifyListeners();
          }
        }
      }
    }
  }

  // চালাক ধরার নোটিফিকেশন
  Future<void> _sendNotification(String deviceName, String deviceId) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'hospo_security_channel', 
      'Hospo Security Alerts',
      channelDescription: 'Alerts when a device bypasses the proxy',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'চালাকি ধরা পড়েছে! 🚨',
      '$deviceName (IP: $deviceId) প্রক্সি বন্ধ করে দিয়েছে। তাকে ব্লক করুন!',
      platformChannelSpecifics,
    );
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    super.dispose();
  }
}
