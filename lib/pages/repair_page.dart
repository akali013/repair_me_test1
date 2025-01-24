import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repair_me_test1/models/Appointment.dart';
import 'package:repair_me_test1/models/Summary.dart';

class RepairPage extends StatefulWidget {
  const RepairPage({super.key, required this.appointmentDoc});

  final QueryDocumentSnapshot<Appointment> appointmentDoc;

  @override
  State<StatefulWidget> createState() => _RepairPageState();
}

final _appointmentsRef = FirebaseFirestore.instance.collection("Appointments").withConverter(
  fromFirestore: (snapshots, _) => Appointment.fromJson(snapshots.data()!), 
  toFirestore: (appointment, _) => appointment.toJson(),
);
Stream<QuerySnapshot>? _summaryStream;
const TextStyle _cardHeaderStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

class _RepairPageState extends State<RepairPage> {
  @override
  void initState() {
    super.initState();
    _summaryStream = _appointmentsRef.doc(widget.appointmentDoc.id).collection("Summary").snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Repair Summary",
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        actions: [
          _paperworkButton(),
          _payButton(),
        ],
      ),
      body: SafeArea(
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return Container(
      child: _summaryInfo(),
    );
  }

  Widget _summaryInfo() {
    // Use a StreamBuilder instead of a FutureBuilder to listen to changes in Firestore
    return StreamBuilder(
      stream: _summaryStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unable to load repair summary."),
          );
        }
        // There should only be 1 doc in each Summary collection
        Summary summary = Summary.fromJson(snapshot.data!.docs[0].data()! as Map<String, dynamic>);
        return Column(
          children: [
            _summaryScroller(summary),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
            _progressBar(context, summary.progress),
          ],
        );
      }
    );
  }

  Widget _summaryScroller(Summary summary) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.3,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
          _timeCard(summary.completionTime),
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
          _costCard(summary.cost),
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
          _changesCard(summary.changes),
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
          _partsCard(summary.parts),
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.15),
        ],
      ),
    );
  }

  Widget _timeCard(Timestamp time) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.schedule,
            size: 40,
          ),
          title: const Text(
            "Completion Time",
            style: _cardHeaderStyle,
          ),
          subtitle: Text(DateFormat("MM/dd/yy h:mm a").format(time.toDate()).toString()),
        ),
      ),
    );
  }

  Widget _costCard(int cost) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.attach_money,
            size: 45,
          ),
          title: const Text(
            "Cost",
            style: _cardHeaderStyle,
          ),
          subtitle: Text(cost.toString()),
        ),
      ),
    );
  }

  Widget _changesCard(String changes) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.build_circle_outlined,
            size: 45,
          ),
          title: const Text(
            "Changes",
            style: _cardHeaderStyle,
          ),
          subtitle: Text(changes),
        ),
      ),
    );
  }

  Widget _partsCard(List<String> parts) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.tire_repair_outlined,
            size: 45,
          ),
          title: const Text(
            "Parts",
            style: _cardHeaderStyle,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: parts.map<Text>((part) => Text("🤠 $part")).toList(),
          ),
        ),
      ),
    );
  }

  Widget _progressBar(BuildContext context, num progress) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.95,
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: LinearProgressIndicator(
        value: progress / 100,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget _paperworkButton() {
    return IconButton(
      onPressed: () {}, 
      icon: const Icon(
        Icons.description_sharp,
        size: 20,
      ),
      style: IconButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      tooltip: "View PDF",
    );
  }

  Widget _payButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.payment_outlined,
        size: 20,
      ),
      style: IconButton.styleFrom(
        foregroundColor: Colors.greenAccent,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      tooltip: "Pay for repair",
    );
  }
}