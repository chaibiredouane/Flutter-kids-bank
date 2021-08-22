import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/kidModel.dart';
import 'package:first/models/user.dart';
import 'package:flutter/material.dart';

class KidService {
  final String? uid;

  KidService({this.uid});

  final CollectionReference kidCollection =
      FirebaseFirestore.instance.collection("kids");

  Future<void> saveKid(String userUid, String firstName, String lastName,
      String imageUrl, int solde) async {
    return await kidCollection.doc(uid).set({
      'uid': uid,
      'userUid': userUid,
      'firstName': firstName,
      'photoURL': lastName,
      'imageUrl': imageUrl,
      'solde': solde,
    });
  }

  Kid _kidFromSnapshot(DocumentSnapshot snapshot) {
    return Kid(
        uid: snapshot.id,
        userUid: snapshot.data()['userUid'],
        firstName: snapshot.data()['firstName'],
        lastName: snapshot.data()['lastName'],
        imageUrl: snapshot.data()['imageUrl'],
        solde: snapshot.data()['solde']);
  }

  Stream<Kid> get kid {
    return kidCollection.doc(uid).snapshots().map(_kidFromSnapshot);
  }

  List<Kid> _kidListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _kidFromSnapshot(doc);
    }).toList();
  }

  Stream<List<Kid>> get kids {
    return kidCollection.snapshots().map(_kidListFromSnapshot);
  }
}
