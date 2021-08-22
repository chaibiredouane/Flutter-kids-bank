import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/mathModel.dart';
import 'package:first/models/prayersModel.dart';
import 'package:first/services/overviewService.dart';

class MathService {
  final String? uid;

  MathService({this.uid});

  final CollectionReference mathCollection =
      FirebaseFirestore.instance.collection("maths");

  Future<void> saveMath(
      String? uid, String kidUid, String date, bool done, String note) async {
    return await mathCollection.doc(uid).set({
      'kidUid': kidUid,
      'date': date,
      'done': done,
      'note': note,
      'createDate': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> persistMath(
      String kidUid, String date, bool done, String note) async {
    var uidDoc;
    bool alreadyDone = false;
    await FirebaseFirestore.instance
        .collection('maths')
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: date)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        event.docs.forEach((result) {
          alreadyDone = result.data()['done'];
          uidDoc = result.id;
        });
      }
      saveMath(uidDoc, kidUid, date, done, note);
      if (done || alreadyDone)
        OverviewService()
            .persistOverview(kidUid, date, done ? 1 : 0, alreadyDone ? 1 : 0);
    }).catchError((e) => print("error fetching data: $e"));
  }

  MathModel _mathFromSnapshot(DocumentSnapshot snapshot) {
    return MathModel(
        snapshot.id,
        snapshot.data()['kidUid'],
        snapshot.data()['date'],
        snapshot.data()['done'],
        snapshot.data()['note'],
        snapshot.data()['createDate']);
  }

  Stream<MathModel> get math {
    return mathCollection.doc(uid).snapshots().map(_mathFromSnapshot);
  }

  List<MathModel> _mathListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _mathFromSnapshot(doc);
    }).toList();
  }

  Stream<List<MathModel>> get maths {
    return mathCollection.snapshots().map(_mathListFromSnapshot);
  }
}
