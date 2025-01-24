import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  bool accountStatus;
  String address;
  String name;
  String email;
  List<DocumentReference<Map<String, Object?>>> services;

  Shop({
    required this.accountStatus,
    required this.address,
    required this.name,
    required this.email,
    required this.services,
  });

  Shop.fromJson(Map<String, Object?> json) 
    : this(
      accountStatus: json["AccountStatus"]! as bool,
      address: json["Address"]! as String,
      name: json["Name"]! as String,
      email: json["Email"]! as String,
      services: (json["Services"]! as List).map((service) => service as DocumentReference<Map<String, Object?>>).toList(),
    );
  
  Shop copyWith({
    bool? accountStatus,
    String? address,
    String? name,
    String? email,
    List<DocumentReference<Map<String, Object?>>>? services,
  }) {
    return Shop(
      accountStatus: accountStatus ?? this.accountStatus,
      address: address ?? this.address,
      name: name ?? this.name,
      email: email ?? this.email,
      services: services ?? this.services,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "AccountStatus": accountStatus,
      "Address": address,
      "Email": email,
      "Name": name,
      "Services": services,
    };
  }
}