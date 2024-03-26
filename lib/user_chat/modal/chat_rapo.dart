import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';

import '../../auth/util/result.dart';

class ChatRepository {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<Message>> getChats({required String userId}) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    final _usersRef = FirebaseDatabase.instance
        .ref()
        .child('chats')
        .child('${currentUser.uid}$userId');

    return _usersRef.onValue.map((event) {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data != null) {
        final List<Message> messages = [];
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            final Message message = Message.fromMap(value);
            messages.add(message);
          }
        });
        messages.sort((a, b) => b.time.compareTo(a.time));
        return messages;
      } else {
        return [];
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
          .child(message.time.millisecondsSinceEpoch.toString())
          .set(message.toMap());
      await toUserChat
          .child(message.time.millisecondsSinceEpoch.toString())
          .set(message.toMap());

      return Success('Message sent');
    } catch (e) {
      return Error(message: 'Error occurred');
    }
  }
  Future<NetworkResult<String>> deleteMessage(Message message, {bool deleteForAll = true}) async {
    try {
      DatabaseReference senderChatRef = database
          .ref()
          .child('chats/${currentUser?.uid}${message.userId}')
          .child(message.time.millisecondsSinceEpoch.toString());

      await senderChatRef.remove();

      if (deleteForAll) {
        DatabaseReference receiverChatRef = database
            .ref()
            .child('chats/${message.userId}${currentUser?.uid}')
            .child(message.time.millisecondsSinceEpoch.toString());

        await receiverChatRef.remove();
      }

      return Success('Message deleted');
    } catch (e) {
      return Error(message: 'Error occurred while deleting message');
    }
  }


}
