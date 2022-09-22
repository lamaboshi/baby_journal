import 'dart:convert';

class Memory {
  Memory({
    required this.at,
    required this.createdAt,
    required this.image,
    required this.childId,
    required this.id,
    this.length,
    this.weight,
    this.title,
    this.text,
  });

  factory Memory.fromJson(String source) => Memory.fromMap(json.decode(source));

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      at: DateTime.fromMillisecondsSinceEpoch(map['at']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      image: map['image'] ?? '',
      childId: map['childId'].toInt(),
      id: map['id'].toInt(),
      length: map['length']?.toDouble(),
      weight: map['wight']?.toDouble(),
      title: map['title'],
      text: map['text'],
    );
  }

  final DateTime at;
  final DateTime createdAt;
  final String image;
  final int childId;
  final int id;
  final double? length;
  final String? text;
  final String? title;
  final double? weight;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'at': at.toUtc().toIso8601String()});
    result.addAll({'image': image});
    result.addAll({'childId': childId});
    if (length != null) {
      result.addAll({'length': length});
    }
    if (weight != null) {
      result.addAll({'wight': weight});
    }
    if (title != null) {
      result.addAll({'title': title});
    }
    if (text != null) {
      result.addAll({'text': text});
    }

    return result;
  }

  String toJson() => json.encode(toMap());
}
