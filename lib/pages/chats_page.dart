import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:repair_me_test1/models/ChatRoom.dart';
import 'package:repair_me_test1/pages/chat_room_page.dart';
import 'package:repair_me_test1/services/user_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final UserService _userService = UserService();
  final _roomsRef = FirebaseFirestore.instance.collection("ChatRooms").withConverter<ChatRoom>(
    fromFirestore: (snapshots, _) => ChatRoom.fromJson(snapshots.data()!), 
    toFirestore: (chatRoom, _) => chatRoom.toJson(),
  );
  Future<List<QueryDocumentSnapshot<ChatRoom>>>? _roomData;
  List<String> _roomNames = [];
  DocumentReference<Map<String, Object?>>? _author;

  @override
  void initState() {
    super.initState();
    _roomData = _getChatRooms();  // Initialize the future object before building to prevent infinite loops
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Rooms"),
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
      child: FutureBuilder(
        future: _roomData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to load rooms."),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 150,
                  ),
                  Text(
                    "You have no chats.",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              )
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ChatRoom chatRoom = snapshot.data![index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.onSecondary,
                  title: Text(_roomNames[index]),
                  subtitle: Text(chatRoom.person2.id),    // Replace with something else idk
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 45,
                  ),
                  onTap: () {
                    // Navigate to the associated chat room
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatRoomPage(
                            otherName: _roomNames[index],
                            roomRef: snapshot.data![index].reference,
                            author: _author!,
                          );
                        }
                      )
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot<ChatRoom>>> _getChatRooms() async {
    List<QueryDocumentSnapshot<ChatRoom>> rooms = [];
    List<String> names = [];  // Names of the other person in each chat

    // Get every chat involving the user
    await _roomsRef.where(
      Filter.or(
        Filter("Person1", isEqualTo: _userService.userDoc),
        Filter("Person2", isEqualTo: _userService.userDoc),
      ),
    ).get().then(
      (querySnapshot) async {
        for (var chatRoom in querySnapshot.docs) {
          // Determine who is sending messages and
          // get the name of the other person in the chat
          if (chatRoom.data().person1 == _userService.userDoc) {
            _author = chatRoom.data().person1;
            await FirebaseFirestore.instance.doc(chatRoom.data().person2.path).get().then(
              (DocumentSnapshot document) {
                var docData = document.data() as Map<String, dynamic>;
                rooms.add(chatRoom);
                names.add(docData["Name"]);
              }
            );
          }
          if (chatRoom.data().person2 == _userService.userDoc) {
            _author = chatRoom.data().person2;
            await FirebaseFirestore.instance.doc(chatRoom.data().person1.path).get().then(
              (DocumentSnapshot document) {
                var docData = document.data() as Map<String, dynamic>;
                rooms.add(chatRoom);
                names.add(docData["Name"]);
              }
            );
          }
        }
      }
    );

    setState(() {
      _roomNames = names;
    });

    return rooms;
  }
}