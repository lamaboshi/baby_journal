import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/foundation.dart';

class Child {
  final String id;
  final String name;
  final DateTime birthday;
  final List<String> family;
  Child({
    required this.id,
    required this.name,
    required this.birthday,
    required this.family,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'birthday': birthday.millisecondsSinceEpoch});
    result.addAll({'family': family});

    return result;
  }

  factory Child.fromMap(Map<String, dynamic> map, String id) {
    return Child(
      id: id,
      name: map['name'] ?? '',
      birthday: DateTime.parse(map['birthday']),
      family:
          map['family'] == null ? <String>[] : List<String>.from(map['family']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Child &&
        other.id == id &&
        other.name == name &&
        other.birthday == birthday &&
        listEquals(other.family, family);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ birthday.hashCode ^ family.hashCode;
  }

  String age({DateTime? today}) {
    final value = AgeCalculator.age(birthday, today: today);
    return '${value.years}Y ${value.months}M ${value.days}D';
  }
}
