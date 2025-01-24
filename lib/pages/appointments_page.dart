import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repair_me_test1/models/Appointment.dart';
import 'package:repair_me_test1/models/Shop.dart';
import 'package:repair_me_test1/models/Vehicle.dart';
import 'package:repair_me_test1/pages/repair_page.dart';
import 'package:repair_me_test1/services/user_service.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _AppointmentsPageState();
}

final UserService _userService = UserService();
final _appointmentsRef = FirebaseFirestore.instance.collection("Appointments").withConverter(
  fromFirestore: (snapshots, _) => Appointment.fromJson(snapshots.data()!), 
  toFirestore: (appointment, _) => appointment.toJson(),
);
final _vehiclesRef = FirebaseFirestore.instance.collection("Vehicles").withConverter(
  fromFirestore: (snapshot, _) => Vehicle.fromJson(snapshot.data()!), 
  toFirestore: (vehicle, _) => vehicle.toJson(),
);
final _shopsRef = FirebaseFirestore.instance.collection("Shops").withConverter(
  fromFirestore: (snapshots, _) => Shop.fromJson(snapshots.data()!), 
  toFirestore: (shop, _) => shop.toJson(),
);

Future<List<QueryDocumentSnapshot<Appointment>>>? _apptsList;
List<Vehicle> _vehiclesList = [];
List<Shop> _shopsList = []; 

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  void initState() {
    super.initState();
    _apptsList = _getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
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
        future: _apptsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to load appointments."),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("You have no appointments!"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Appointment appointment = snapshot.data![index].data();
              Vehicle vehicle = _vehiclesList[index];
              Shop shop = _shopsList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "${vehicle.year} ${vehicle.make} ${vehicle.model}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${DateFormat("MM/dd/yy h:mm a").format(appointment.time.toDate())} - ${shop.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  tileColor: Theme.of(context).primaryColorLight,
                  trailing: const Icon(
                    Icons.chevron_right_sharp,
                    size: 50,
                  ),
                  onTap: () {
                    // Navigate to the summary page of the associated appointment
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RepairPage(
                            appointmentDoc: snapshot.data![index],
                          );
                        }
                      ),
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

  Future<List<QueryDocumentSnapshot<Appointment>>> _getAppointments() async {
    List<QueryDocumentSnapshot<Appointment>> apptDocs = [];
    // Retrieve all appointments that belong to the current user
    await _appointmentsRef.where("User", isEqualTo: _userService.userDoc).get().then(
      (querySnapshot) async {
        // For each appointment, get the corresponding vehicle and shop involved
        apptDocs = querySnapshot.docs;
        _vehiclesList = await Future.wait(apptDocs.map(
          (appointmentDoc) => _getVehicle(appointmentDoc.data().vehicle),
        ));
        _shopsList = await Future.wait(apptDocs.map(
          (appointmentDoc) => _getShop(appointmentDoc.data().shop),
        ));
      }
    );

    return apptDocs;
  }

  Future<Vehicle> _getVehicle(DocumentReference<Map<String, Object?>> vehicleDoc) async {
    Vehicle? vehicle;
    await _vehiclesRef.doc(vehicleDoc.id).get().then(
      (documentSnapshot) {
        vehicle = documentSnapshot.data();
      }
    );
    return vehicle!;
  }

  Future<Shop> _getShop(DocumentReference<Map<String, Object?>> shopDoc) async {
    Shop? shop;
    await _shopsRef.doc(shopDoc.id).get().then(
      (documentSnapshot) {
        shop = documentSnapshot.data();
      }
    );
    return shop!;
  }
}