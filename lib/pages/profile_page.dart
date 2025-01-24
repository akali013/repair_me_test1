import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:repair_me_test1/models/Mechanic.dart';
import 'package:repair_me_test1/models/Shop.dart';
import 'package:repair_me_test1/models/User.dart' as model;
import 'package:repair_me_test1/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
      ),
      body: SafeArea(
        child: _buildUI(context),
      )
    );
  }

  Widget _buildUI(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _userInfoFieldContainer(context),
          _signOutButton(context),
        ],
      ),
    );
  }

  Widget _signOutButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.4,
      child: ElevatedButton.icon(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Are you sure you want to sign out?",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Closes the confirmation pop-up
                    },
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Log user out of Firebase Auth and send them back to login
                      // and clear navigation history
                      _userService.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            }
          );
        },
        label: const Text("Sign Out"),
        icon: const Icon(
          Icons.logout,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 52, 38),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  Widget _userInfoFieldContainer(BuildContext context) {    
    var descriptors = _initializeDescriptors(_userService.userData!.keys.toList());   // Could be name, email, address, etc.
    var userInfo = _userService.userData!.values.toList();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: const Color.fromARGB(137, 169, 215, 236),
          ),
          borderRadius: BorderRadius.zero
        ),
        child: ListView.builder(
          itemCount: userInfo.length,
          itemBuilder: (context, index) => 
            Padding(
              padding: const EdgeInsets.all(5),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                title: Text(
                  descriptors[index],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  userInfo[index]!.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
                iconColor: Colors.amber,
                tileColor: Theme.of(context).secondaryHeaderColor,
                selectedColor: Colors.blue,
                isThreeLine: true,
              ),
            ),
        ),
      ),
    );
  }

  // Makes the titles of profile tiles look better
  List<String> _initializeDescriptors(List<String> descriptors) {
    List<String> newDescriptors = [];
    for (String data in descriptors) {
      switch (data) {
        case "PhoneNumber": newDescriptors.add("Phone Number");
        case "AccountStatus": newDescriptors.add("Account Status");
        default: newDescriptors.add(data);
      }
    }
    return newDescriptors;
  }
}
