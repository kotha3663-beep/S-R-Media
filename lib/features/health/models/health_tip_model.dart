class HealthTipModel {
  final int? id;
  final String title;
  final String category;
  final String description;
  final bool isBookmarked;

  HealthTipModel({
    this.id,
    required this.title,
    required this.category,
    required this.description,
    this.isBookmarked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }

  factory HealthTipModel.fromMap(Map<String, dynamic> map) {
    return HealthTipModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      description: map['description'],
      isBookmarked: map['isBookmarked'] == 1,
    );
  }
}
