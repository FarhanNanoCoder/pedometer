import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/core/appButtons.dart';
import 'package:pedometer/core/appColors.dart';
import 'package:pedometer/core/appText.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(text: "dasboard", color: AppColors().grey800).getText(),
          AppButton(context: context).getOutlinedTextButtton(
              title: "Logout",
              onPressed: () {
                FirebaseAuth.instance.signOut();
              })
        ],
      )),
    ));
  }
}
