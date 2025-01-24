import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RepairMe",
          style: GoogleFonts.birthstone( 
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 45,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          _profileButton(),
        ],
      ),
      body: SafeArea(
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          _screenButtons(),
          Image.asset("assets/images/placeholder.png"),
        ],
      ),
    );
  }

  Widget _profileButton() {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, "/profile");
      }, 
      icon: const Icon(
        Icons.person,
        size: 35,
      ),
      style: IconButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _screenButtons() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.06,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _screenButton(Icons.house, "Home"),
          _screenButton(Icons.garage, "Garage"),
          _screenButton(Icons.build, "Appointments"),
          _screenButton(Icons.map, "Mechanic Map"),
          _screenButton(Icons.chat, "Chats"),
          _screenButton(Icons.reviews, "Reviews"),
          _screenButton(Icons.question_mark, "About"),
        ],
      ),
    );
  }

  Widget _screenButton(IconData icon, String text) {
    Color backgroundColor = Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0
      ),
      child: OutlinedButton.icon(
        onPressed: () {
          switch(text) {
            case "Garage": Navigator.pushNamed(context, "/garage");
            case "About": Navigator.pushNamed(context, "/about");
            case "Chats": Navigator.pushNamed(context, "/chats");
            case "Appointments": Navigator.pushNamed(context, "/appointments");
            default:
          }
        },
        icon: Icon(
          icon,
          size: 23,
          color: Colors.white,
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}