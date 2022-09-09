import 'dart:convert';

class Child {
  final String id;
  final String name;
  final DateTime birthday;
  final List<String> parents;
  Child({
    required this.id,
    required this.name,
    required this.birthday,
    required this.parents,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'birthday': birthday.millisecondsSinceEpoch});
    result.addAll({'parents': parents});

    return result;
  }

  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday']),
      parents: List<String>.from(map['parents']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Child.fromJson(String source) => Child.fromMap(json.decode(source));
}
