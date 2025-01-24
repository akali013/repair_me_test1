import 'package:cloud_firestore/cloud_firestore.dart';

class Mechanic {
  String name;
  String email;
  String experience;
  List<String> specializations;
  DocumentReference<Map<String, Object?>> shop;

  Mechanic({
    required this.name,
    required this.email,
    required this.experience,
    required this.specializations,
    required this.shop,
  });

  Mechanic.fromJson(Map<String, Object?>json)
    : this(
        name: json["Name"]! as String,
        email: json["Email"]! as String,
        experience: json["Experience"]! as String,
        specializations: json["Specializations"]! as List<String>,
        shop: json["Shop"]! as DocumentReference<Map<String, Object?>>,
    );

  Mechanic copyWith({
    String? name,
    String? email,
    String? experience,
    List<String>? specializations,
    DocumentReference<Map<String, Object?>>? shop,
  }) {
    return Mechanic(
      name: name ?? this.name,
      email: email ?? this.email,
      experience: experience ?? this.experience,
      specializations: specializations ?? this.specializations,
      shop: shop ?? this.shop,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Name": name,
      "Email": email,
      "Experience": experience,
      "Specializations": specializations,
      "Shop": shop,
    };
  }
}