import 'package:cloud_firestore/cloud_firestore.dart';

class MathModel {
  String? uid;
  String kidUid;
  String? date;
  bool? done;
  String? note;
  Timestamp? createDate;

  MathModel(
      this.uid, this.kidUid, this.date, this.done, this.note, this.createDate);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'kidUid': kidUid,
      'date': date,
      'done': done,
      'note': note,
      'createDate': createDate,
    };
  }
}
