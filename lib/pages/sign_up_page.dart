import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:repair_me_test1/models/Mechanic.dart';
import 'package:repair_me_test1/models/Shop.dart';
import 'package:repair_me_test1/models/User.dart' as model;
import 'package:repair_me_test1/services/user_service.dart';
import 'package:status_alert/status_alert.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}


class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey();
  String? _email, _password, _phoneNumber, _name, _address; // Possible values of user, mechanic, or shop accounts
  DocumentReference<Map<String, Object?>>? _shop; // Points to a shop in the Shops collection
  List<QueryDocumentSnapshot<Shop>> _shopDocs = [];
  final UserService _userService = UserService();

  final _usersRef = FirebaseFirestore.instance.collection("/Users");
  final _mechanicsRef = FirebaseFirestore.instance.collection("/Mechanics");
  // Automatically convert Shop documents from Firestore into Shop types and vice versa
  final _shopsRef = FirebaseFirestore.instance.collection("/Shops").withConverter<Shop>(
    fromFirestore: (snapshots, _) => Shop.fromJson(snapshots.data()!),
    toFirestore: (shop, _) => shop.toJson()
  );
  
  @override
  void initState() {
    super.initState();
    _getShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _accountTypeOptions(),
          _formContainer(),
          _signUpButton(),
        ],
      ),
    );
  }

  Widget _accountTypeOptions() {
    return Column(
      children: [
        // Radio buttons for account types
        ListTile(
          title: const Text("User"),
          leading: Radio<AccountType>(
            value: AccountType.User,
            groupValue: _userService.userAccountType,
            onChanged: (value) {
              setState(() {
                _userService.changeAccountType(value!);
              });
            },
          ),
        ),
        ListTile(
          title: const Text("Mechanic"),
          leading: Radio<AccountType>(
            value: AccountType.Mechanic,
            groupValue: _userService.userAccountType,
            onChanged: (value) {
              setState(() {
                _userService.changeAccountType(value!);
              });
            },
          ),
        ),
        ListTile(
          title: const Text("Repair Shop"),
          leading: Radio<AccountType>(
            value: AccountType.Shop,
            groupValue: _userService.userAccountType,
            onChanged: (value) {
              setState(() {
                _userService.changeAccountType(value!);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _formContainer() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: Container(
        // Show the appropriate form based on the chosen account type
        child: switch (_userService.userAccountType) {
          AccountType.Shop => _shopSignUpForm(),
          AccountType.Mechanic => _mechanicSignUpForm(),
          _ => _userSignUpForm()
        },
      ),
    );
  }

  Widget _userSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _nameField(),
          _emailField(),
          _phoneNumberField(),
          _passwordField(),
        ],
      ),
    );
  }

  Widget _mechanicSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _nameField(),
          _emailField(),
          _passwordField(),
          _shopSearchBar(),
        ],
      ),
    );
  }

  Widget _shopSearchBar() {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: "Find your shop...",
        );
      }, suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(_shopDocs.length, (int index) {
          Shop shop = _shopDocs[index].data();
          
          return ListTile(
            title: Text(shop.name),
            onTap: () { 
              setState(() {
                _shop = FirebaseFirestore.instance.collection("Shops").doc(_shopDocs[index].id);
                controller.closeView(shop.name);
              });
            });
        });
      });
  }

  void _getShops() async {
    await _shopsRef.get().then(
      (querySnapshot) {
        _shopDocs = querySnapshot.docs;
      },
      onError: (e) => "Error fetching shops: $e",
    );
  }

  Widget _shopSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Shop Name",
            ),
            validator: (value) {
              if (value == null || value.length < 3) {
                return "A valid shop name is required.";
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          _emailField(),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Address",
            ),
            validator: (value) {
              if (value == null || value.length < 4) {
                return "A valid address is required.";
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _address = value;
              });
            },
          ),
          _passwordField(),
        ],
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.length < 3) {
          return "A valid name is required.";
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Full Name"),
      onSaved: (value) {
        setState(() {
          _name = value;
        });
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      validator: (value) {
        if (value == null || !value.contains("@")) {
          return "A valid email is required.";
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Email"),
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  Widget _phoneNumberField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.length < 10) {
          return "A valid phone number is required.";
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Phone Number"),
      onSaved: (value) {
        setState(() {
          _phoneNumber = value;
        });
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.length < 5) {
          return "A valid password is required.";
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Password"),
      onSaved: (value) {
        setState(() {
          _password = value;
        });
      },
      obscureText: true,
    );
  }

  Widget _signUpButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.5,
      child: ElevatedButton(
        onPressed: _createAccount,
        child: const Text("Create Account"),
      )
    );
  }

  void _createAccount() async {
    _signUpFormKey.currentState?.save();
    if (_signUpFormKey.currentState?.validate() ?? false) {
      try {
        // Add user to Firebase Auth
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        final userID = credential.user!.uid;

        _createFirestoreAccount(userID); // Create account in Firestore with the same userID in Auth
        // user?.sendEmailVerification();
        _showConfirmation();
        Navigator.pushReplacementNamed(context, "/login");
      } on FirebaseAuthException {
        _showStatusAlert();
      } catch (e) {
        _showStatusAlert();
      }
    }
  }

  void _createFirestoreAccount(String uid) async {
    switch (_userService.userAccountType) {
      case AccountType.Shop:
        Shop shopData = Shop(
          accountStatus: false,
          address: _address!,
          email: _email!,
          name: _name!,
          services: [],
        );
        _shopsRef.doc(uid).set(shopData);  // Create Shops document in Firestore
      case AccountType.Mechanic:
        Mechanic mechanicData = Mechanic(
          name: _name!,
          email: _email!,
          experience: "",
          specializations: [],
          shop: _shop!,
        );
        _mechanicsRef.doc(uid).set(mechanicData.toJson()); // Create Mechanics doc in Firestore
      default:
        model.User userData = model.User(
          email: _email!,
          name: _name!,
          phoneNumber: _phoneNumber!,
        );
        _usersRef.doc(uid).set(userData.toJson());  // Create Users doc in Firestore
    }
  }

  void _showStatusAlert() {
    StatusAlert.show(
      context,
      title: "Sign Up Failed",
      subtitle: "Make sure to enter a valid email and password greater than 5 characters",
      configuration: const IconConfiguration(
        icon: Icons.error,
      ),
      duration: const Duration(seconds: 5),
    );
  }

  void _showConfirmation() {
    StatusAlert.show(
      context,
      title: "Account Created!",
      configuration: const IconConfiguration(
        icon: Icons.verified,
      ),
      duration: const Duration(seconds: 2),
    );
  }
}
