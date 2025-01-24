import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:repair_me_test1/models/ChatRoom.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:repair_me_test1/models/Message.dart' as model;
import 'package:repair_me_test1/services/user_service.dart';

class ChatRoomPage extends StatefulWidget {
  final String otherName;
  final DocumentReference<ChatRoom> roomRef;
  final DocumentReference<Map<String, Object?>> author;  // User looking at the chat

  const ChatRoomPage({
    super.key, 
    required this.otherName,
    required this.roomRef,
    required this.author,
  });

  @override
  State<StatefulWidget> createState() => _ChatRoomPageState();
}

// Any types preceded by "types" is from flutter_chat_ui
// Any preceded by "model" is from the models folder
final UserService _userService = UserService();
types.User? _user;
CollectionReference<model.Message>? _messagesRef;

Stream<QuerySnapshot<model.Message>>? _messageStream;

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  void initState() {
    super.initState();
    _messagesRef = widget.roomRef.collection("Messages").withConverter<model.Message>(
      fromFirestore: (snapshots, _) => model.Message.fromJson(snapshots.data()!), 
      toFirestore: (messages, _) => messages.toJson(),
    );
    _messageStream = _messagesRef!.orderBy("Time", descending: true).snapshots();
    _user = types.User(id: _userService.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherName),
      ),
      body: SafeArea(
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: StreamBuilder(
        stream: _messageStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to load chat."),
            );
          }
          return Chat(
            messages: snapshot.data!.docs.map<types.Message>((messageDoc) =>
              _convertToChatMessage(messageDoc.data())
            ).toList(),
            user: _user!,
            onSendPressed: _handleSendPressed,
          );
        }
      ),
    );
  }

  // Build the text message
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user!,
      id: _randomString(),
      text: message.text,
    );

    _addMessage(textMessage.text);
  }

  // // Update the UI with every new message
  // Future<List<types.Message>> _sendMessage(types.TextMessage message) async {
  //   final messages = await _messages;
  //   _addMessage(message.text);
  //   setState(() {
  //     messages!.insert(0, message);
  //   });
  //   return messages!;
  // }

  // Add message to Firestore
  void _addMessage(String content) async {
    model.Message messageToAdd = model.Message(
      from: widget.author,
      content: content,
      time: Timestamp.now(),
    );

    await _messagesRef!.add(messageToAdd);  
  }

  // Creates a unique identifier for each message
  String _randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  // Future<List<types.Message>> _getMessages() async {
  //   List<types.Message> messages = [];
  //   // Order the received messages by newest first
  //   await _messagesRef!.orderBy("Time", descending: true).get().then(
  //     (querySnapshot) {
  //       for (var document in querySnapshot.docs) {
  //         messages.add(_convertToChatMessage(document.data()));
  //       }
  //     }
  //   );

  //   return messages;
  // }

  // Converts a message from model.Message (what's in Firestore)
  // to types.Message (what flutter_chat_ui needs)
  types.TextMessage _convertToChatMessage(model.Message message) {
    return types.TextMessage(
      author: types.User(id: message.from.id),
      id: _randomString(),
      text: message.content,
      createdAt: message.time.millisecondsSinceEpoch,
    );
  }
}