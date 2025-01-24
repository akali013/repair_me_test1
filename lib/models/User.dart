class User {
  String name;
  String email;
  String phoneNumber;

  User({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  User.fromJson(Map<String, Object?> json)
    : this(
        name: json["Name"]! as String,
        email: json["Email"]! as String,
        phoneNumber: json["PhoneNumber"]! as String,
     );

  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Name": name,
      "Email": email,
      "PhoneNumber": phoneNumber,
    };
  }
}