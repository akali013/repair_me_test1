import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: SafeArea(
        child: _buildUI(context),
      )
    );
  }

  Widget _buildUI(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: Color.fromARGB(248, 228, 225, 217),
            child: ListTile(
              leading: Icon(
                Icons.handshake,
                size: 50,
              ),
              title: Text(
                "Trust",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("We are trustworthy"),
            ),
          ),
          Card(
            color: Color.fromARGB(255, 153, 150, 139),
            child: ListTile(
              leading: Icon(
                Icons.recommend_rounded,
                size: 50,
              ),
              title: Text(
                "Reliability",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("We are reliable"),
            ),
          ),
          Card(
            color: Color.fromARGB(255, 197, 193, 181),
            child: ListTile(
              leading: Icon(
                Icons.done_outline,
                size: 50,
              ),
              title: Text(
                "Quality",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("We ensure top-tier quality"),
            ),
          ),
        ],
      ),
    );
  }
}