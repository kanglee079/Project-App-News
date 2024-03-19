// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Reply {
  String id;
  String userId;
  String content;
  DateTime timestamp;
  Reply({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'] as String,
      userId: map['userId'] as String,
      content: map['content'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Reply.fromJson(String source) =>
      Reply.fromMap(json.decode(source) as Map<String, dynamic>);
}
