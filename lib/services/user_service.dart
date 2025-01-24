import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


enum AccountType { User, Mechanic, Shop }

class UserService {
  // Only one instance of this service throughout the app's runtime
  static final UserService _singleton = UserService._internal();

  factory UserService() {
    return _singleton;
  }

  UserService._internal();

  User? currentUser = FirebaseAuth.instance.currentUser;
  AccountType userAccountType = AccountType.User;
  Map<String, Object?>? userData;
  DocumentReference<Map<String, Object?>>? userDoc;

  void changeAccountType(AccountType accountType) {
    userAccountType = accountType;
  }


  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}