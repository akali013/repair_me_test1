import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:repair_me_test1/models/Vehicle.dart';
import 'package:repair_me_test1/services/database_service.dart';
import 'package:repair_me_test1/services/user_service.dart';

class GaragePage extends StatefulWidget {
  const GaragePage({super.key});

  @override
  State<StatefulWidget> createState() => _GaragePageState();
}

final DatabaseService _databaseService = DatabaseService();
final UserService _userService = UserService();
final _vehiclesRef = FirebaseFirestore.instance.collection("Vehicles").withConverter<Vehicle>(
  fromFirestore: (snapshots, _) => Vehicle.fromJson(snapshots.data()!),
  toFirestore: (vehicle, _) => vehicle.toJson(),
);
Stream<QuerySnapshot<Vehicle>>? _vehicleStream;

class _GaragePageState extends State<GaragePage> {
  final GlobalKey<FormState> carFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _vehicleStream = _vehiclesRef.where("Owner", isEqualTo: _userService.userDoc).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Vehicles"),
        actions: [
          _addButton(),
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
        height: MediaQuery.sizeOf(context).height,
        child: StreamBuilder(
          stream: _vehicleStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Unable to load vehicles."),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.car_crash_outlined,
                      size: 140,
                    ),
                    Text(
                      "You have no registered vehicles!",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = snapshot.data!.docs[index].data();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text("${vehicle.year} ${vehicle.make} ${vehicle.model}"),
                    subtitle: Text("${vehicle.mileage} miles"),
                    onTap: () {
                      // View histories
                    },
                    trailing: _deleteButton(snapshot.data!.docs[index].id),
                  ),
                );
              }
            );
          },
        ),
      );
  }

    Widget _deleteButton(String vehicleID) {
    return ElevatedButton.icon(
      onPressed: () {
        FirebaseFirestore.instance.collection("Vehicles").doc(vehicleID).delete().then(
          (doc) => {
            print("Vehicle successfully deleted")
          },
          onError: (e) => print("Error deleting document: $e"),
        );
      },
      icon: const Icon(
        Icons.delete,
        size: 20,
      ),
      label: const Text("Delete"),
    );
  }


  Widget _addButton() {
    return OutlinedButton.icon(
      onPressed: _showAddCarDialog,
      icon: const Icon(Icons.add, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      label: const Text("Add"),
    );
  }

  void _showAddCarDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add a car",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: Column(
            children: [
              _addCarForm(),
              _carFormButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _addCarForm() {
    String? VIN; // Make call to API to resolve VIN to car info

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: MediaQuery.sizeOf(context).height * 0.2,
      child: Form(
        key: carFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: "VIN"),
              onSaved: (value) {
                VIN = value;
              },
              validator: (value) {
                if (value == null || value.length != 17) {
                  return "A valid VIN is required.";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _carFormButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            //_addCar(vehicle)
          },
          child: const Text("Add"),
        ),
      ],
    );
  }

  void _addCar(Vehicle vehicle) {
    _databaseService.addVehicle(vehicle);
  }
}
