import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pedometer/core/appButtons.dart';
import 'package:pedometer/core/appText.dart';
import 'package:pedometer/views/entrance/authentication.dart';

class Entrance extends StatefulWidget {
  const Entrance({super.key});

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 56,
              ),
              SvgPicture.asset(
                "assets/images/welcome.svg",
                width: MediaQuery.of(context).size.width * .7,
              ),
              const SizedBox(
                height: 44,
              ),
              AppButton(context: context).getTextButton(
                  title: "Login",
                  onPressed: () {
                    Get.to(Authentication(isLoginState: true));
                  }),
              const SizedBox(
                height: 24,
              ),
              AppButton(context: context).getTextButton(
                  title: "Register",
                  onPressed: () {
                    Get.to(Authentication(isLoginState: false));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
