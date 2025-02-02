import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:repair_me_test1/pages/about_page.dart';
import 'package:repair_me_test1/pages/appointments_page.dart';
import 'package:repair_me_test1/pages/chats_page.dart';
import 'package:repair_me_test1/pages/garage_page.dart';
import 'package:repair_me_test1/pages/home_page.dart';
import 'package:repair_me_test1/pages/login_page.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:repair_me_test1/pages/profile_page.dart';
import 'package:repair_me_test1/pages/sign_up_page.dart';
import 'package:repair_me_test1/services/user_service.dart';
import "firebase_options.dart";

void main() async {
  // Connect to Firebase Firestore db
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Enable data persistence for cost-efficiency
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      _userService.currentUser = user;
    }
  });

  runApp(const RepairMeApp());
}

final UserService _userService = UserService();

class RepairMeApp extends StatelessWidget {
  const RepairMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Repair Me",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Color.fromARGB(255, 75, 75, 75),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 136, 136, 136),
      ),
      initialRoute: "/login",
      // These represent the different screens of the app
      routes: {
        "/login": (context) => const LoginPage(),
        "/home": (context) => const HomePage(),
        "/signUp": (context) => const SignUpPage(),
        "/profile": (context) => const ProfilePage(),
        "/garage": (context) => const GaragePage(),
        "/about": (context) => const AboutPage(),
        "/chats": (context) => const ChatsPage(),
        "/appointments": (context) => const AppointmentsPage(),
      },
    );
  }
}
//this is a test for chris