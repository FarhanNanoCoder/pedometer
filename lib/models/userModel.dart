import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  late String? id,dob,name, email, phone;
  late int role;

  UserModel(
      {this.name,
      this.email,
      this.phone,
      this.id,
      this.dob,
      this.role=0});

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    dynamic map = doc.data();
    return UserModel(
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      phone: map['phone'] ?? "",
      role: map['role'] ?? 0,
      id: map['id']??"",
      dob: map['dob']??"",
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['role'] = role;
    map['id'] = id;
    map['dob'] = dob;
    return map;
  }


  String toJsonString() {
    return jsonEncode(toMap());
  }
}
