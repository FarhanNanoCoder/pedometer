import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserFitModel {
  String? id, date, uid;
  int steps = 0;
  double caloriesBurnt = 0.0, distanceWalked = 0.0;

  UserFitModel(
      {this.uid,
      this.id,
      this.date,
      this.steps = 0,
      this.caloriesBurnt = 0.0,
      this.distanceWalked = 0.0});

  factory UserFitModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    dynamic map = doc.data();
    return UserFitModel(
        id: map["id"] ?? "",
        uid: map["uid"] ?? "",
        date: map["date"] ?? "",
        steps: map["steps"] ?? 0,
        caloriesBurnt: map["caloriesBurnt"]!=null ? map["caloriesBurnt"] + 0.0 : 0.0,
        distanceWalked:
            map["distanceWalked"]!=null ? map["distanceWalked"] + 0.0 : 0.0);
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uid'] = uid;
    map['steps'] = steps;
    map['date'] = date;
    map['caloriesBurnt'] = caloriesBurnt;
    map['distanceWalked'] = distanceWalked;
    return map;
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }
}
