class ConnectedDevice {
  final String id; // MAC বা IP
  String name;
  double usedMB;
  double limitMB;
  bool isProxyBypassed; // সন্দেহজনক ডিভাইস ট্র্যাকিং

  ConnectedDevice({
    required this.id,
    required this.name,
    this.usedMB = 0.0,
    this.limitMB = 100.0,
    this.isProxyBypassed = false,
  });

  // স্টোরেজের জন্য
  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'usedMB': usedMB, 'limitMB': limitMB, 'isProxyBypassed': isProxyBypassed,
  };

  factory ConnectedDevice.fromJson(Map<String, dynamic> json) => ConnectedDevice(
    id: json['id'],
    name: json['name'],
    usedMB: json['usedMB'],
    limitMB: json['limitMB'],
    isProxyBypassed: json['isProxyBypassed'] ?? false,
  );
}
