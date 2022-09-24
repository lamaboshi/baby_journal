import 'dart:convert';

class User {
  final String name;
  final String email;
  final String password;
  final String token;
  User({
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name.trim()});
    result.addAll({'email': email.trim()});
    result.addAll({'password': password.trim()});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? token,
    List<String>? children,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
    );
  }
}
