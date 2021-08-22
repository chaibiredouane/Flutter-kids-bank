import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/overviewModel.dart';

class OverviewService {
  final String? uid;

  OverviewService({this.uid});

  final CollectionReference overviewCollection =
      FirebaseFirestore.instance.collection("overview");

  Future<void> saveOverview(String? uid, String kidUid, String date, int won,
      int spent, int solde) async {
    return await overviewCollection.doc(uid).set({
      'kidUid': kidUid,
      'date': date,
      'won': won,
      'spent': spent,
      'solde': solde,
      'createDate': Timestamp.fromDate(DateTime.now())
    });
  }

  Future<void> persistOverview(
      String kidUid, String date, int won, int spent) async {
    var uidDoc;
    var solde = 0;
    log('persistOverview: $kidUid');
    await FirebaseFirestore.instance
        .collection('overview')
        .where('kidUid', isEqualTo: kidUid)
        .orderBy("createDate", descending: true)
        .limit(1)
        .get()
        .then((event) {
      solde = event.docs.first.data()['solde'];
    });

    await FirebaseFirestore.instance
        .collection('overview')
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: date)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        event.docs.forEach((result) {
          won = result.data()['won'] + won;
          spent = result.data()['spent'] + spent;
          print('result.id ' + result.id);
          uidDoc = result.id;
        });
      }
      saveOverview(uidDoc, kidUid, date, won, spent, solde + won - spent);
    }).catchError((e) => print("error fetching data: $e"));
  }

  OverviewModel _overviewFromSnapshot(DocumentSnapshot snapshot) {
    return OverviewModel(
        snapshot.id,
        snapshot.data()['kidUid'],
        snapshot.data()['date'],
        snapshot.data()['won'],
        snapshot.data()['spent'],
        snapshot.data()['solde'],
        snapshot.data()['createDate']);
  }

  Stream<OverviewModel> get overview {
    return overviewCollection.doc(uid).snapshots().map(_overviewFromSnapshot);
  }

  List<OverviewModel> _overviewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _overviewFromSnapshot(doc);
    }).toList();
  }

  Stream<List<OverviewModel>> get overviews {
    return overviewCollection.snapshots().map(_overviewListFromSnapshot);
  }

  Future<List<OverviewModel>> getOverviews() async {
    return await FirebaseFirestore.instance
        .collection('overview')
        // .where('kidUid', isEqualTo: kidUid)
        .snapshots()
        .forEach((element) {
      _overviewListFromSnapshot(element);
    });
  }
}
