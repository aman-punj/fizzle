import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../../../core/models/user_models.dart' as USER;
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final _database = FirebaseDatabase.instance.ref().child('users');

  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<USER.User>> getUsersStream() {
    return _database.onValue.map((event) {
      if (event.snapshot.value != null &&
          event.snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> usersMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<USER.User> users = [];
        usersMap.forEach((key, value) {
          USER.User user = USER.User.fromMap(value);

          if (currentUser?.uid != user.id) {
            users.add(user);
          }
        });
        return users;
      } else {
        return <USER.User>[];
      }
    });
  }
}
