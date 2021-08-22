import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/models/user.dart';
import 'package:first/services/database.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebaseUser(User? user) {
    return user != null
        ? AppUser(
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL)
        : null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Stream<AppUser?> get userRedoune {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      stderr.writeln('print me' + email);
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password,
      String displayName, String photoURL) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      await DatabaseService(uid: user.uid)
          .saveUser(displayName, email, photoURL);

      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
}
