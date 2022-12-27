import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedometer/core/functions.dart';
import 'package:pedometer/models/userFitModel.dart';
import 'package:pedometer/models/userModel.dart';
import 'package:pedometer/services/api/baseApi.dart';

class UserApi {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signOutUser() async {
    return _auth.signOut();
  }

  Future<UserCredential?> createAuthUserWithEmailAndPassword(
      {required UserModel userModel, required String password}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userModel.email ?? "", password: password);
      if (userCredential.user != null) {
        userModel.id = userCredential.user?.uid ?? "";
        await createUser(user: userModel);
        await BaseApi().userFitApi.setUserFit(userFitModel: UserFitModel(
          uid: userCredential.user?.uid ?? "",
          id: DateTime.now().toString().substring(0,10),
          timestamp: Timestamp.fromDate(DateTime.parse(DateTime.now().toString().substring(0,10)))
        ));
        return userCredential;
      }
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
    }
  }

  Future<UserCredential?> signInUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
    }
  }

  Future<UserModel?> getUser(String id) async {
    DocumentSnapshot doc = await usersCollection.doc(id).get();
    if (doc.exists) {
      return UserModel.fromDocumentSnapshot(doc);
    }
    return null;
  }

  Future createUser({required UserModel user}) async {
    return usersCollection.doc(user.id).set(user.toMap()).then((value) {});
  }

  Future setUser({required UserModel user}) async {
    return usersCollection.doc(user.id).set(user.toMap()).then((value) {
      showAppSnackbar(title: "", message: "Successfully updated user data");
    });
  }
}
