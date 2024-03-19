// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'replies.dart';

class Comment {
  String id;
  String userId;
  String content;
  DateTime timestamp;
  List<Reply> replies;
  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.replies,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'replies': replies.map((x) => x.toMap()).toList(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      userId: map['userId'] as String,
      content: map['content'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      replies: map['replies'] != null
          ? List<Reply>.from(
              (map['replies'] as List).map<Reply>(
                (x) => Reply.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);
}
