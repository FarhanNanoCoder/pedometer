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

  Stream<DocumentSnapshot> getUserFitAsStream({required String id}) {
    return userFitCollection.doc(id).snapshots();
  }

  Stream<QuerySnapshot>? getUserFitHistoryAsStream({int count = 7}) {
    try {
      final Timestamp now = Timestamp.fromDate(DateTime.now());
      final Timestamp lastDay =
          Timestamp.fromDate(DateTime.now().subtract(Duration(days: count)));
      return userFitCollection
          // .orderBy("date", descending: true)
          .where('timestamp', isLessThan: now, isGreaterThan: lastDay)
          .snapshots();
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
    }
    return null;
  }

  Future<UserFitModel?> getUserFit({required String id}) async {
    try {
      DocumentSnapshot doc = await userFitCollection.doc(id).get();
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
          .doc(userFitModel.id ?? "")
          .set(userFitModel.toMap());
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
    }
  }
}
