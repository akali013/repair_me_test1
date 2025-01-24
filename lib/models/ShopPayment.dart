import 'package:cloud_firestore/cloud_firestore.dart';

class ShopPayment {
  int amount;
  Timestamp date;
  String shop;

  ShopPayment({
    required this.amount,
    required this.date,
    required this.shop,
  });

  ShopPayment.fromJson(Map<String, Object?> json)
    : this(
        amount: json["Amount"]! as int,
        date: json["Date"]! as Timestamp,
        shop: json["Shop"]! as String,
    );
  
  ShopPayment copyWith({
    int? amount,
    Timestamp? date,
    String? shop,
  }) {
    return ShopPayment(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      shop: shop ?? this.shop,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Amount": amount,
      "Date": date,
      "Shop": shop,
    };
  }
}