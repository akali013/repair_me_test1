import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:repair_me_test1/services/user_service.dart';
import 'package:status_alert/status_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey(); // Key to validate form values
  String? email, password;
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _buildUI(), // SafeArea prevents physical device parts from blocking the screen
      ),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _title(),
          _loginForm(),
          _loginButton(),
          _signUpButton(),
        ],
      ),
    );
  }

  Widget _title() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.3, // Picture takes up 1/3 of the screen's height
      child: Image.asset(
        "assets/images/logo.png",
        width: 200,
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: MediaQuery.sizeOf(context).height * 0.3,
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Email",
              ),
              // If the validator returns nothing, it's good
              validator: (value) {
                if (value == null || !value.contains("@")) {
                  return "A valid email is required";
                }
                return null;
              },
              onSaved: (value) {
                // Use setState to update variable values
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Password",
              ),
              validator: (value) {
                if (value == null || value.length < 5) {
                  return "A valid password is required";
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: true, // Hide password text
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: OutlinedButton.icon(
        onPressed: _signIn,
        icon: const Icon(
          Icons.login_outlined,
          size: 25,
        ),
        label: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 110, 175, 114),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6,
      child: OutlinedButton.icon(
        onPressed: () {
          // Go to sign up page
          Navigator.pushNamed(context, "/signUp");
        },
        icon: const Icon(
          Icons.person_add_alt_1,
          size: 25,
        ),
        label: const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  void _signIn() async {
    _loginFormKey.currentState?.save(); // Update variable values
    try {
      // First locally validate credentials
      if (_loginFormKey.currentState?.validate() ?? false) {
        // Then use Firebase Authentication to check credentials
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        _getAccountTypeAndData(credential.user!.uid);
        Navigator.pushReplacementNamed(context, "/home"); // Go to home page if successful
      } else {
        _showStatusAlert();
      }
    } on FirebaseAuthException {
      _showStatusAlert();
    } catch (e) {
      _showStatusAlert();
    }
  }

  void _showStatusAlert() {
    StatusAlert.show(
      context,
      duration: const Duration(seconds: 3),
      title: "Login Failed",
      subtitle: "Please try again",
      configuration: const IconConfiguration(
        icon: Icons.error,
      ),
      maxWidth: 200,
    );
  }

  // Based on the user's Firebase Authentication id,
  // determine if they're a user, mechanic, or shop
  void _getAccountTypeAndData(String uid) async {
    await FirebaseFirestore.instance.collection("Shops").doc(uid).get().then(
      (DocumentSnapshot document) {
        if (document.exists) {
          _userService.userData = document.data() as Map<String, Object?>;
          _userService.userAccountType = AccountType.Shop;
        }
      }
    );
    await FirebaseFirestore.instance.collection("Mechanics").doc(uid).get().then(
      (DocumentSnapshot document) {
        if (document.exists) {
          _userService.userData = document.data() as Map<String, Object?>;
          _userService.userAccountType = AccountType.Mechanic;
        }
      }
    );
    await FirebaseFirestore.instance.collection("Users").doc(uid).get().then(
      (DocumentSnapshot document) {
        if (document.exists) {
          _userService.userData = document.data() as Map<String, Object?>;
          _userService.userAccountType = AccountType.User;
        }
      }
    );

    _userService.userDoc = FirebaseFirestore.instance.doc("/${_userService.userAccountType.name}s/${_userService.currentUser!.uid}");
  }
}
