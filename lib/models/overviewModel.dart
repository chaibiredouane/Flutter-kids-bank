import 'package:cloud_firestore/cloud_firestore.dart';

class OverviewModel {
  String? uid;
  String kidUid;
  String? date;
  int? won;
  int? spent;
  int? solde;
  Timestamp? createDate;

  OverviewModel(this.uid, this.kidUid, this.date, this.won, this.spent,
      this.solde, this.createDate);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'kidUid': kidUid,
      'date': date,
      'won': won,
      'spent': spent,
      'solde': solde,
      'createDate': createDate
    };
  }
}
