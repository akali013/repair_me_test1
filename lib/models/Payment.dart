class Payment {
  int amount;
  String appointment;
  String user;

  Payment({
    required this.amount,
    required this.appointment,
    required this.user,
  });

  Payment.fromJson(Map<String, Object?> json)
    : this(
        amount: json["Amount"]! as int,
        appointment: json["Appointment"]! as String,
        user: json["User"]! as String,
    );

  Payment copyWith({
    int? amount,
    String? appointment,
    String? user,
  }) {
    return Payment(
      amount: amount ?? this.amount,
      appointment: appointment ?? this.appointment,
      user: user ?? this.user,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Amount": amount,
      "Appointment": appointment,
      "User": user,
    };
  }
}