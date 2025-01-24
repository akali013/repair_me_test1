import 'package:cloud_firestore/cloud_firestore.dart';

class Summary {
  String changes;
  Timestamp completionTime;
  int cost;
  List<String> parts;
  int progress;

  Summary({
    required this.changes,
    required this.completionTime,
    required this.cost,
    required this.parts,
    required this.progress,
  });

  Summary.fromJson(Map<String, Object?> json)
    : this(
      changes: json["Changes"]! as String,
      completionTime: json["CompletionTime"]! as Timestamp,
      cost: json["Cost"]! as int,
      parts: (json["Parts"]! as List).map((part) => part as String).toList(),
      progress: json["Progress"]! as int,
    );
  
  Summary copyWith({
    String? changes,
    Timestamp? completionTime,
    int? cost,
    List<String>? parts,
    int? progress,
  }) {
    return Summary(
      changes: changes ?? this.changes,
      completionTime: completionTime ?? this.completionTime,
      cost: cost ?? this.cost,
      parts: parts ?? this.parts,
      progress: progress ?? this.progress,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Changes": changes,
      "CompletionTime": completionTime,
      "Cost": cost,
      "Parts": parts,
      "Progress": progress,
    };
  }
}