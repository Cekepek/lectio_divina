import 'dart:convert';

class User {
  int id;
  String username;
  String password;
  String name;
  String foto;
  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.name,
      required this.foto});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        username: json['username'] as String,
        password: json['password'] as String,
        name: json['nama'] as String,
        foto: json['foto'] as String);
  }
  // static String encode(List<User> lds) => json.encode(
  //       lds.map<Map<String, dynamic>>((ld) => User.toMap(ld)).toList(),
  //     );
}
