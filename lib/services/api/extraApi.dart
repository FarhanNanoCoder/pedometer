import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedometer/core/functions.dart';
import '../../models/problemModel.dart';

class ExtraApi {
  CollectionReference problemCol =
      FirebaseFirestore.instance.collection('problems');
  CollectionReference extraCol = FirebaseFirestore.instance.collection('extra');

  Future createProblem(ProblemModel problemModel) async {
    problemModel.id = problemCol.doc().id;
    return await problemCol
        .doc(problemModel.id)
        .set(problemModel.toMap())
        .then((value) {
      showAppSnackbar(title: "", message: "Your response has been  collected");
    });
  }

  Future getBookPurchaseDetails({required String book_id}) async {
    return await extraCol.doc(book_id).get();
  }
}
