class Review {
  String comments;
  int rating;
  String mechanic;
  String shop;
  String user;

  Review({
    required this.comments,
    required this.rating,
    required this.mechanic,
    required this.shop,
    required this.user,
  });

  Review.fromJson(Map<String, Object?> json)
    : this(
      comments: json["Comments"]! as String,
      rating: json["Rating"]! as int,
      mechanic: json["Mechanic"]! as String,
      shop: json["Shop"]! as String,
      user: json["User"]! as String,
    );
  
  Review copyWith({
    String? comments,
    int? rating,
    String? mechanic,
    String? shop,
    String? user,
  }) {
    return Review(
      comments: comments ?? this.comments,
      rating: rating ?? this.rating,
      mechanic: mechanic ?? this.mechanic,
      shop: shop ?? this.shop,
      user: user ?? this.user,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Comments": comments,
      "Rating": rating,
      "Mechanic": mechanic,
      "Shop": shop,
      "User": user,
    };
  }
}