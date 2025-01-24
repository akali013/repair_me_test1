import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  DocumentReference<Map<String, Object?>> person1;
  DocumentReference<Map<String, Object?>> person2;

  ChatRoom({
    required this.person1,
    required this.person2,
  });

  ChatRoom.fromJson(Map<String, Object?> json) 
    : this(
      person1: json["Person1"] as DocumentReference<Map<String, Object?>>,
      person2: json["Person2"] as DocumentReference<Map<String, Object?>>,
    );
  
  ChatRoom copyWith(
    DocumentReference<Map<String, Object?>>? messages,
    DocumentReference<Map<String, Object?>>? person1,
    DocumentReference<Map<String, Object?>>? person2,
  ) {
    return ChatRoom(
      person1: person1 ?? this.person1,
      person2: person2 ?? this.person2,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Person1": person1,
      "Person2": person2,
    };
  }
}