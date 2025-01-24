class Service {
  String name;

  Service(
    {required this.name}
  );

  Service.fromJson(Map<String, Object?> json)
    : this(
      name: json["Name"]! as String,
    );
  
  Service copyWith({
    String? name
  }) {
    return Service(name: name ?? this.name);
  }

  Map<String, Object?> toJson() {
    return {
      "Name": name,
    };
  }
}