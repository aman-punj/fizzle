import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../util/result.dart';

class FirebaseAuthService {
  FirebaseDatabase database = FirebaseDatabase.instance;
  Future<NetworkResult<String>> signUp(
      String emailAddress, String password , String userName , String publicKey) async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      DatabaseReference ref = database.ref("users/${credential.user!.uid}");

      await ref.set({
        "name": userName,
        "email": emailAddress,
        "id": credential.user?.uid ?? ' ',
        "publicKey": publicKey
      });
      return Success<String>('Logged in successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return Error<String>(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return Error<String>(
            message: 'The account already exists for that email.');
      } else {
        return Error<String>(message: 'IDK');
      }
    } catch (e) {
      print(e);
      return Error<String>(message: 'Something went wrong');
    }
  }

  Future<NetworkResult<String>> login(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      return Success<String>('Data fetched successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Error<String>(message: 'user not');
      } else if (e.code == 'wrong-password') {
        return Error<String>(message: 'wrong password');
      } else {
        return Error<String>(message: 'IDK');
      }
    } catch (e) {
      return Error<String>(message: 'Something went wrong');
    }
  }
}
