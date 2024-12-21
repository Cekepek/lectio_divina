class User {
  int id;
  String username;
  String password;
  String name;
  String foto;
  // String email;
  // String nomorTelepon;
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.foto,
    // required this.email,
    // required this.nomorTelepon,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['nama'] as String,
      foto: json['foto'] as String,
      // email: json['email'] as String,
      // nomorTelepon: json['nomorTelepon'] as String,
    );
  }
  // static String encode(List<User> lds) => json.encode(
  //       lds.map<Map<String, dynamic>>((ld) => User.toMap(ld)).toList(),
  //     );
}
