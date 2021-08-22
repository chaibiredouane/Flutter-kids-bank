class Kid {
  String? uid;
  String? userUid;
  String? firstName;
  String? lastName;
  String? imageUrl;
  int? solde;

  Kid(
      {this.uid,
      this.userUid,
      this.firstName,
      this.lastName,
      this.imageUrl,
      this.solde});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userUid': userUid,
      'firstName': firstName,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'solde': solde,
    };
  }

  factory Kid.fromMap(Map<String, dynamic> map) => new Kid(
      uid: map['uid'],
      userUid: map['userUid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      imageUrl: map['imageUrl'],
      solde: map['solde']);
}
