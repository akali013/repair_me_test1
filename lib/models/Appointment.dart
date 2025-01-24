import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String paperwork;
  List<DocumentReference<Map<String, Object?>>> services;
  DocumentReference<Map<String, Object?>> shop;
  Timestamp time;
  DocumentReference<Map<String, Object?>> user;
  DocumentReference<Map<String, Object?>> vehicle;

  Appointment({
    required this.paperwork,
    required this.services,
    required this.shop,
    required this.time,
    required this.user,
    required this.vehicle,
  });

  Appointment.fromJson(Map<String, Object?> json) 
    : this(
      paperwork: json["Paperwork"]! as String,
      services: (json["Services"]! as List).map((service) => service as DocumentReference<Map<String, Object?>>).toList(),
      shop: json["Shop"]! as DocumentReference<Map<String, Object?>>,
      time: json["Time"]! as Timestamp,
      user: json["User"]! as DocumentReference<Map<String, Object?>>,
      vehicle: json["Vehicle"]! as DocumentReference<Map<String, Object?>>,
    );
  
  Appointment copyWith({
    String? paperwork,
    List<DocumentReference<Map<String, Object?>>>? services,
    DocumentReference<Map<String, Object?>>? shop,
    Timestamp? time,
    DocumentReference<Map<String, Object?>>? user,
    DocumentReference<Map<String, Object?>>? vehicle,
  }) {
    return Appointment(
      paperwork: paperwork ?? this.paperwork,
      services: services ?? this.services,
      shop: shop ?? this.shop,
      time: time ?? this.time,
      user: user ?? this.user,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Paperwork": paperwork,
      "Services": services,
      "Shop": shop,
      "Time": time,
      "User": user,
      "Vehicle": vehicle,
    };
  }
}