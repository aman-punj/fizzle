// class User {
//   final String name;
//   final String email;
//   final String id;
//
//   User({required this.name, required this.email, required this.id});
//
//   factory User.fromMap(Map<dynamic, dynamic> map) {
//     return User(
//       name: map['name'],
//       email: map['email'],
//       id: map['id'],
//     );
//   }
// }
//
//
class User {
  final String name;
  final String email;
  final String id;
  final String publicKey;

  User({
    required this.name,
    required this.email,
    required this.id,
    required this.publicKey,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      id: map['id'],
      publicKey: map['publicKey'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'publicKey': publicKey,
    };
  }
}
