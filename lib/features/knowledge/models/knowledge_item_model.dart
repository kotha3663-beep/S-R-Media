class KnowledgeItemModel {
  final int? id;
  final int groupId;
  final String languageCode;
  final String category;
  final String title;
  final String body;
  final String keyPoint;
  final bool isRead;

  KnowledgeItemModel({
    this.id,
    required this.groupId,
    required this.languageCode,
    required this.category,
    required this.title,
    required this.body,
    required this.keyPoint,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'languageCode': languageCode,
      'category': category,
      'title': title,
      'body': body,
      'keyPoint': keyPoint,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory KnowledgeItemModel.fromMap(Map<String, dynamic> map) {
    return KnowledgeItemModel(
      id: map['id'],
      groupId: map['groupId'],
      languageCode: map['languageCode'],
      category: map['category'],
      title: map['title'],
      body: map['body'],
      keyPoint: map['keyPoint'],
      isRead: map['isRead'] == 1,
    );
  }
}
