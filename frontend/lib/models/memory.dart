import 'dart:convert';

class Memory {
  Memory({
    required this.at,
    required this.createdAt,
    required this.image,
    this.childId,
    required this.id,
    this.length,
    this.weight,
    this.title,
    this.text,
  });

  factory Memory.fromJson(String source) => Memory.fromMap(json.decode(source));

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      at: DateTime.parse(map['at']).toLocal(),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      image: map['image'] ?? '',
      childId: map['childId']?.toInt(),
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
  final int? childId;
  final int id;
  final double? length;
  final String? text;
  final String? title;
  final double? weight;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'at': at.toUtc().toIso8601String()});
    result.addAll({'image': image});
    if (childId != null) {
      result.addAll({'childId': childId});
    }
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

class PagedMemories {
  final int offset;
  final int limit;
  final int count;
  final List<Memory> records;
  PagedMemories({
    required this.offset,
    required this.limit,
    required this.count,
    required this.records,
  });

  factory PagedMemories.fromMap(Map<String, dynamic> map) {
    return PagedMemories(
      offset: map['offset']?.toInt() ?? 0,
      limit: map['limit']?.toInt() ?? 0,
      count: map['count']?.toInt() ?? 0,
      records: List<Memory>.from(map['records']?.map((x) => Memory.fromMap(x))),
    );
  }

  factory PagedMemories.fromJson(String source) =>
      PagedMemories.fromMap(json.decode(source));
}
