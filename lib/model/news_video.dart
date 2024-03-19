import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsVideo {
  final String id;
  final String title;
  final String videoUrl;
  int likes;
  NewsVideo({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'videoUrl': videoUrl,
      'likes': likes,
    };
  }

  factory NewsVideo.fromMap(Map<String, dynamic> map) {
    return NewsVideo(
      id: map['id'] as String,
      title: map['title'] as String,
      videoUrl: map['videoUrl'] as String,
      likes: map['likes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsVideo.fromJson(String source) =>
      NewsVideo.fromMap(json.decode(source) as Map<String, dynamic>);
}
