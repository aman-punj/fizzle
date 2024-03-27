import 'package:firebase_database/firebase_database.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:fizzle/user_chat/modal/chat_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';
import '../../auth/util/result.dart';
import '../../core/util/encryption.dart';

class ChatRepository {
  static const storage = FlutterSecureStorage();
  FirebaseDatabase database = FirebaseDatabase.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<Message>> getChats({required String userId, String? selfPrivateKey}) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }
    final usersRef = FirebaseDatabase.instance
        .ref()
        .child('chats')
        .child('${currentUser.uid}$userId');

    return usersRef.onValue.asyncMap((event) async {
      final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
      if (data != null) {
        final List<Message> messages = [];
        for (var entry in data.entries) {
          if (entry.value is Map<dynamic, dynamic>) {
            try {
              final Message message = Message.fromMap(entry.value);
              messages.add(message);
            } catch (e) {
              print('Error parsing message: $e');
            }
          } else {
            print('Invalid message data');
          }
        }
        messages.sort((a, b) => b.time.compareTo(a.time));
        return messages;
      } else {
        print('No data found');
        return [];
      }
    });
  }


  // Future<String> _decryptMessage(
  //     String encryptedMessage, String privateKeyPem) async {
  //   final privateKey = RsaKeyHelper.parsePrivateKeyFromPem(privateKeyPem);
  //   return RsaKeyHelper.decryptWithPrivateKey(encryptedMessage, privateKey);
  // }

  Future<NetworkResult<String>> sendMessage(
      Message message, String receiverPublicKey) async {
    try {
      DatabaseReference selfChatRef = database
          .ref()
          .child('chats/${currentUser?.uid}${message.userId}');

      DatabaseReference receiverChatRef = database
          .ref()
          .child('chats/${message.userId}${currentUser?.uid}');

      String? selfPublicK = await storage.read(key: 'publicKey');

      if (selfPublicK == null) {
        return Error(message: 'Self public key not found');
      }

      RSAPublicKey? selfPublicKey = RsaKeyHelper.parsePublicKeyFromPem(selfPublicK);

      if (selfPublicKey == null) {
        return Error(message: 'Error parsing self public key');
      }

      final encryptedSelfMessage =
      RsaKeyHelper.encryptWithPublicKey(message.text, selfPublicKey);

      await selfChatRef
          .child(message.time.millisecondsSinceEpoch.toString())
          .set({
        'userId': message.userId,
        'text': encryptedSelfMessage,
        'time': message.time.toIso8601String(),
      });

      RSAPublicKey receivePublicKey =
      RsaKeyHelper.parsePublicKeyFromPem(receiverPublicKey);

      final encryptedReceiverMessage =
      RsaKeyHelper.encryptWithPublicKey(message.text, receivePublicKey);

      await receiverChatRef
          .child(message.time.millisecondsSinceEpoch.toString())
          .set({
        'userId': message.userId,
        'text': encryptedReceiverMessage,
        'time': message.time.toIso8601String(),
      });

      return Success('Message sent');
    } catch (e) {
      return Error(message: 'Error occurred: $e');
    }
  }

  Future<NetworkResult<String>> deleteMessage(Message message,
      {bool deleteForAll = true}) async {
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
