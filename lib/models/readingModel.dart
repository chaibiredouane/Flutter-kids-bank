import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingModel {
  String? uid;
  String kidUid;
  String? date;
  String? title;
  bool? finished;
  String? progress;
  Timestamp? createDate;

  ReadingModel(this.uid, this.kidUid, this.date, this.title, this.finished,
      this.progress, this.createDate);

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'kidUid': kidUid,
      'date': date,
      'title': title,
      'finished': finished,
      'progress': progress,
      'createDate': createDate,
    };
  }
}
