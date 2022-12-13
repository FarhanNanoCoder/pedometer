import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedometer/models/userFitModel.dart';

import '../../core/functions.dart';

class UserFitApi {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userFitCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
      .collection("userFit");

  Stream<DocumentSnapshot> getUserFitAsStream({required String date}) {
    return userFitCollection.doc(date).snapshots();
  }

  Stream<QuerySnapshot>? getUserFitHistoryAsStream({int count=7}) {
    try {
      return userFitCollection
          .orderBy("date", descending: true)
          .limit(count)
          .snapshots();
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
    }
    return null;
  }

  Future<UserFitModel?> getUserFit({required String date}) async {
    try {
      DocumentSnapshot doc = await userFitCollection.doc(date).get();
      if (doc.exists) {
        return UserFitModel.fromDocumentSnapshot(doc);
      } else {
        showAppSnackbar(title: "", message: "User fit data doen't exists");
      }
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
    }
  }

  Future setUserFit({required UserFitModel userFitModel}) async {
    try {
      await userFitCollection
          .doc(userFitModel.date ?? "")
          .set(userFitModel.toMap());
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
    }
  }
}
