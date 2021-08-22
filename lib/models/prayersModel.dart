import 'package:cloud_firestore/cloud_firestore.dart';

class Prayer {
  String? uid;
  String? kidUid;
  String? date;
  bool? fajr;
  bool? dhuhr;
  bool? asr;
  bool? maghrib;
  bool? isha;
  int? total;

  Prayer(this.uid, this.kidUid, this.date, this.fajr, this.dhuhr, this.asr,
      this.maghrib, this.isha, this.total);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'kidUid': kidUid,
      'date': date,
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'total': total,
    };
  }
}
