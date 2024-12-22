import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///login
  Future loginUser(String email, String password) async {
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await DatabaseService(uid: user.uid);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  ///register
  Future registerUser(String email, String password, String name) async {
    try {
      User user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData(
          name,
          email,
        );
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  ///logout
  Future signOutUser() async {
    try {
      _firebaseAuth.signOut();
      HelperFunction.isUserLoggedIn(false);
      HelperFunction.saveUserName("");
      HelperFunction.saveUserEmail("");
    } on FirebaseAuthException catch (e) {
      e.message;
    }
  }

  ///delete
  Future<void> reAuthenticateAndDelete(String password) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        await user.delete();
      }
    } catch (e) {
      e.toString();
    }
  }
}
