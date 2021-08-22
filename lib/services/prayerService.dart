import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/prayersModel.dart';
import 'package:first/services/overviewService.dart';

class PrayerService {
  final String? uid;

  PrayerService({this.uid});

  final CollectionReference prayerCollection =
      FirebaseFirestore.instance.collection("prayers");

  Future<void> savePrayer(String? uid, String kidUid, String date, bool fajr,
      bool dhuhr, bool asr, bool maghrib, bool isha, int total) async {
    return await prayerCollection.doc(uid).set({
      'kidUid': kidUid,
      'date': date,
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'total': total,
    });
  }

  Future<void> persistPrayer(String kidUid, String date, bool fajr, bool dhuhr,
      bool asr, bool maghrib, bool isha, int total) async {
    total = total + getTotalToday(fajr, dhuhr, asr, maghrib, isha);
    var uidDoc;
    await FirebaseFirestore.instance
        .collection('prayers')
        .where('kidUid', isEqualTo: kidUid)
        .where('date', isEqualTo: date)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        event.docs.forEach((result) {
          print('result.id ' + result.id);
          uidDoc = result.id;
          total = (result.data()['total'] + total) -
              getTotalToday(
                  result.data()['fajr'],
                  result.data()['dhuhr'],
                  result.data()['asr'],
                  result.data()['maghrib'],
                  result.data()['isha']);
        });
      }
      if (total >= 5) {
        total = total - 5;
        OverviewService().persistOverview(kidUid, date, 1, 0);
      }
      savePrayer(uidDoc, kidUid, date, fajr, dhuhr, asr, maghrib, isha, total);
    }).catchError((e) => print("error fetching data: $e"));
  }

  int getTotalToday(bool fajr, bool dhuhr, bool asr, bool maghrib, bool isha) {
    return (fajr ? 1 : 0) +
        (dhuhr ? 1 : 0) +
        (asr ? 1 : 0) +
        (maghrib ? 1 : 0) +
        (isha ? 1 : 0);
  }

  Prayer _prayerFromSnapshot(DocumentSnapshot snapshot) {
    return Prayer(
        snapshot.id,
        snapshot.data()['kidUid'],
        snapshot.data()['date'],
        snapshot.data()['fajr'],
        snapshot.data()['dhuhr'],
        snapshot.data()['asr'],
        snapshot.data()['maghrib'],
        snapshot.data()['isha'],
        snapshot.data()['total']);
  }

  Stream<Prayer> get prayer {
    return prayerCollection.doc(uid).snapshots().map(_prayerFromSnapshot);
  }

  List<Prayer> _prayerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _prayerFromSnapshot(doc);
    }).toList();
  }

  Stream<List<Prayer>> get prayers {
    return prayerCollection.snapshots().map(_prayerListFromSnapshot);
  }
}
