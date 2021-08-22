import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/kidModel.dart';
import 'package:first/models/user.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> saveUser(
      String displayName, String email, String photoURL) async {
    return await userCollection.doc(uid).set({
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
    });
  }

  AppUser _userFromSnapshot(DocumentSnapshot snapshot) {
    return AppUser(
      uid: uid,
      displayName: snapshot.data()['displayName'],
      email: snapshot.data()['email'],
      photoURL: snapshot.data()['photoURL'],
    );
  }

  Stream<AppUser> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  List<AppUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<AppUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
