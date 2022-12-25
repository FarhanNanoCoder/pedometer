import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserFitModel {
  String? id, date, uid;
  int steps = 0;
  Timestamp? timestamp ;
  double caloriesBurnt = 0.0, distanceWalked = 0.0;

  UserFitModel(
      {this.uid,
      this.id,
      this.steps = 0,
      this.caloriesBurnt = 0.0,
      this.timestamp ,
      this.distanceWalked = 0.0});

  factory UserFitModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    dynamic map = doc.data();
    return UserFitModel(
        id: map['id']??"",
        uid: map["uid"] ?? "",
        steps: map["steps"] ?? 0,
        timestamp:
            map["timestamp"] ?? Timestamp.fromDate(DateTime.parse(doc.id)),
        caloriesBurnt:
            map["caloriesBurnt"] != null ? map["caloriesBurnt"] + 0.0 : 0.0,
        distanceWalked:
            map["distanceWalked"] != null ? map["distanceWalked"] + 0.0 : 0.0);
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['steps'] = steps;
    map['id'] = id;
    map['caloriesBurnt'] = caloriesBurnt;
    map['distanceWalked'] = distanceWalked;
    map['timestamp'] = timestamp;
    return map;
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }
}
