class GameRecordModel {
  final int? id;
  final String gameId;
  final int highScore;
  final int lastLevel;
  final DateTime lastPlayed;

  GameRecordModel({
    this.id,
    required this.gameId,
    required this.highScore,
    required this.lastLevel,
    required this.lastPlayed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameId': gameId,
      'highScore': highScore,
      'lastLevel': lastLevel,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }

  factory GameRecordModel.fromMap(Map<String, dynamic> map) {
    return GameRecordModel(
      id: map['id'],
      gameId: map['gameId'],
      highScore: map['highScore'],
      lastLevel: map['lastLevel'],
      lastPlayed: DateTime.parse(map['lastPlayed']),
    );
  }
}
