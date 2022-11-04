import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pedometer/services/api/baseApi.dart';
import 'package:pedometer/views/entrance/entrance.dart';
import 'package:pedometer/views/home/home.dart';
import '../core/functions.dart';
import '../models/userModel.dart';

class UserController extends GetxController {
  RxBool userLoader = false.obs;
  Rx<UserModel?> currentUser = UserModel(role: 0).obs;
  Rx<UserModel?> authUser = UserModel(role: 0).obs;
  late Rx<User?> firebaseUser;
  BaseApi baseApi = BaseApi();
  final auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.authStateChanges());
    ever(firebaseUser, _setUserStatus);
  }

  _setUserStatus(User? user) async {
    userLoader.value = true;
    if (user == null) {
      //logout
      Get.offAll(Entrance());
    } else {
      Get.to(Home());
      // var temp = await baseApi.userApi.getUser(user.uid);
      // if (temp != null) {
      //   authUser.value = temp;
      // }
    }

    userLoader.value = false;
  }


  void handleSignOut() async {
    await baseApi.userApi.signOutUser();
  }

  void getUser(String id) async {
    // currentUser.value = await baseApi.userApi.getUser(id);
  }

  void getAuthUser() async {
    // userLoader.value = true;
    // var temp = await baseApi.userApi
    //     .getUser(FirebaseAuth.instance.currentUser?.uid ?? "");
    // if (temp != null) {
    //   authUser.value = temp;
    // }else{
    //   showAppSnackbar(title: "", message: "Something went wrong. Please try again");
    // }
    // userLoader.value = false;
  }

  void setUser(UserModel userModel) async {
    // userLoader.value = true;
    // await baseApi.userApi.setUser(user: userModel);
    // userLoader.value = false;
    // getAuthUser();
  }
}
