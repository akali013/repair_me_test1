import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  DocumentReference<Map<String, Object?>> from;
  String content;
  Timestamp time;

  Message({
    required this.from,
    required this.content,
    required this.time,
  });

  Message.fromJson(Map<String, Object?> json)
    : this(
      from: json["From"]! as DocumentReference<Map<String, Object?>>,
      content: json["Content"]! as String,
      time: json["Time"]! as Timestamp,
    );
  
  Message copyWith({
    DocumentReference<Map<String, Object>>? from,
    String? content,
    Timestamp? time,
  }) {
    return Message(
      from: from ?? this.from,
      content: content ?? this.content,
      time: time ?? this.time,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "From": from,
      "Content": content,
      "Time": time,
    };
  }
}