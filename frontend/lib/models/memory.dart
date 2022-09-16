import 'dart:convert';

class Memory {
  Memory({
    required this.at,
    required this.createdAt,
    required this.createdFrom,
    required this.image,
    required this.child,
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
      createdFrom: map['createdFrom'] ?? '',
      image: map['image'] ?? '',
      child: map['child'] ?? '',
      length: map['length']?.toDouble(),
      weight: map['wight']?.toDouble(),
      title: map['title'],
      text: map['text'],
    );
  }

  final DateTime at;
  final DateTime createdAt;
  final String createdFrom;
  final String image;
  final String child;
  final double? length;
  final String? text;
  final String? title;
  final double? weight;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'at': at.millisecondsSinceEpoch});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'createdFrom': createdFrom});
    result.addAll({'image': image});
    result.addAll({'child': child});
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
