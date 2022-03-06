// ignore_for_file: avoid_print

import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // communicate with firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object base on FirebaseUser(UserCredential)
  MyUser? _userFromUserCredential(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        //.map((User? user) => _userFromUserCredential(user));
        .map(_userFromUserCredential);
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromUserCredential(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromUserCredential(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create a new document for user with the uid
      await DataBaseService(uid: user?.uid).updateUserData('0', 'New crew member', 100);
      
      return _userFromUserCredential(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
