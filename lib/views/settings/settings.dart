import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pedometer/views/settings/profile.dart';
import '../../controllers/userController.dart';
import '../../core/appButtons.dart';
import '../../core/appText.dart';
import '../../core/appTitleView.dart';
import 'feedbackView.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find(tag: 'uc-0');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitleView(title: "Settings"),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 56,
                  ),
                  SvgPicture.asset(
                    "assets/images/settings.svg",
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  const SizedBox(
                    height: 96,
                  ),
                  AppButton(context: context).getOutlinedTextButtton(
                      title: "Profile",
                      onPressed: () {
                        Get.to(Profile());
                      }),
                  const SizedBox(
                    height: 24,
                  ),
                  AppButton(context: context).getOutlinedTextButtton(
                      title: "Report problem",
                      onPressed: () {
                        Get.to(FeedbackView());
                      }),
                  const SizedBox(
                    height: 24,
                  ),
                  AppButton(context: context).getOutlinedTextButtton(
                      title: "Signout",
                      onPressed: () {
                        userController.handleSignOut();
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
