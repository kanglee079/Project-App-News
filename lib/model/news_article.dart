class NewsArticle {
  String id;
  String idCategory;
  bool isFeatured;
  String title;
  String authorName;
  DateTime dateTime;
  String description;
  String content;
  String photoUrl;
  int likes;

  NewsArticle({
    required this.id,
    required this.idCategory,
    required this.isFeatured,
    required this.title,
    required this.authorName,
    required this.dateTime,
    required this.description,
    required this.content,
    required this.photoUrl,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCategory': idCategory,
      'isFeatured': isFeatured,
      'title': title,
      'authorName': authorName,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'description': description,
      'content': content,
      'photoUrl': photoUrl,
      'likes': likes,
    };
  }

  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      id: map['id'],
      idCategory: map['idCategory'],
      isFeatured: map['isFeatured'],
      title: map['title'],
      authorName: map['authorName'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      description: map['description'],
      content: map['content'],
      photoUrl: map['photoUrl'],
      likes: map['likes'],
    );
  }
}
