import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String year;
  String make;
  String model;
  int mileage;
  String repairHistory;
  String crashHistory;
  DocumentReference<Map<String, dynamic>> owner;

  Vehicle({
    required this.year,
    required this.make,
    required this.model,
    required this.mileage,
    required this.repairHistory,
    required this.crashHistory,
    required this.owner,
  });

  Vehicle.fromJson(Map<String, Object?> json) 
    : this(
      year: json["Year"]! as String,
      make: json["Make"]! as String,
      model: json["Model"]! as String,
      mileage: json["Mileage"]! as int,
      repairHistory: json["RepairHistory"]! as String,
      crashHistory: json["CrashHistory"]! as String,
      owner: json["Owner"]! as DocumentReference<Map<String, dynamic>>,
    );

  Vehicle copyWith({
    String? year,
    String? make,
    String? model,
    int? mileage,
    String? repairHistory,
    String? crashHistory,
    DocumentReference<Map<String, dynamic>>? owner,
  }) {
    return Vehicle(
      year: year ?? this.year,
      make: make ?? this.make,
      model: model ?? this.model,
      mileage: mileage ?? this.mileage,
      repairHistory: repairHistory ?? this.repairHistory,
      crashHistory: crashHistory ?? this.crashHistory,
      owner: owner ?? this.owner,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Year": year,
      "Make": make,
      "Model": model,
      "Mileage": mileage,
      "RepairHistory": repairHistory,
      "CrashHistory": crashHistory,
      "Owner": owner,
    };
  }
}