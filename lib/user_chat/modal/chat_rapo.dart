import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';

import '../../add_friend/data/user_models.dart' as USER;
import '../../auth/util/result.dart';

class ChatRepository {
  FirebaseDatabase database = FirebaseDatabase.instance;

  final _usersRef = FirebaseDatabase.instance.ref().child('users');

  // final _chatsRef = FirebaseDatabase.instance;

  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<USER.User>> getChats() {
    return _usersRef.onValue.map((event) {
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

  Future<NetworkResult<String>> sendMessage(Message message) async {
    try {
      DatabaseReference chatRef =
          database.ref().child('chats/${currentUser?.uid}${message.userId}');

      DatabaseReference toUserChat =
          database.ref().child('chats/${message.userId}${currentUser?.uid}');

      await chatRef
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .set(message.toMap());
      await toUserChat.child(DateTime.now().millisecondsSinceEpoch.toString())
          .set(message.toMap());

      return Success('Message sent');
    } catch (e) {
      return Error(message: 'Error occured');
    }
  }
}
