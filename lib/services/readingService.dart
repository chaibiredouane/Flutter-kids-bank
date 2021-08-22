import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/readingModel.dart';
import 'package:first/services/overviewService.dart';

class ReadingService {
  final String? uid;

  ReadingService({this.uid});

  final CollectionReference readingCollection =
      FirebaseFirestore.instance.collection("readings");

  Future<void> saveReading(String? uid, String kidUid, String date,
      String title, bool finished, String progress) async {
    return await readingCollection.doc(uid).set({
      'kidUid': kidUid,
      'date': date,
      'title': title,
      'finished': finished,
      'progress': progress,
      'createDate': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> persistReading(String kidUid, String date, String title,
      bool finished, String progress) async {
    bool alreadyDone = false;
    var uidDoc;
    await FirebaseFirestore.instance
        .collection('readings')
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: date)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        event.docs.forEach((result) {
          uidDoc = result.id;
          alreadyDone = result.data()['finished'];
        });
      }
      if (num.tryParse(progress) == 100) {
        finished = true;
      }
      saveReading(uidDoc, kidUid, date, title, finished, progress);
      if (finished || alreadyDone)
        OverviewService().persistOverview(
            kidUid, date, finished ? 1 : 0, alreadyDone ? 1 : 0);
    }).catchError((e) => print("error fetching data: $e"));
  }

  ReadingModel _readingFromSnapshot(DocumentSnapshot snapshot) {
    return ReadingModel(
        snapshot.id,
        snapshot.data()['kidUid'],
        snapshot.data()['date'],
        snapshot.data()['title'],
        snapshot.data()['finished'],
        snapshot.data()['progress'],
        snapshot.data()['createDate']);
  }

  Stream<ReadingModel> get reading {
    return readingCollection.doc(uid).snapshots().map(_readingFromSnapshot);
  }

  List<ReadingModel> _readingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      inspect(doc.data());
      return _readingFromSnapshot(doc);
    }).toList();
  }

  Stream<List<ReadingModel>> get readings {
    return readingCollection.snapshots().map(_readingListFromSnapshot);
  }
}
