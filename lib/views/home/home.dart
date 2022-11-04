import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/controllers/userController.dart';
import 'package:pedometer/core/appColors.dart';
import 'package:pedometer/views/counter/Counter.dart';
import 'package:pedometer/views/dashboard/dashboard.dart';
import 'package:pedometer/views/history/History.dart';
import 'package:pedometer/views/settings/settings.dart';

import '../../core/flowNavigationBar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserController userController = Get.find(tag: 'uc-0');
  final _controller = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userController.getUser(FirebaseAuth.instance.currentUser?.uid ?? "");
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().white,
        body: PageView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          pageSnapping: true,
          onPageChanged: (position) {
            setState(() {
              currentIndex = position;
              //print(currentIndex);
            });
          },
          children: [
            DashBoard(),
            Counter(),
            History(),
            Settings(),
          ],
        ),
        bottomNavigationBar: FlowNavigationBar(
          initialIndex: currentIndex,
          activeIconColor: AppColors().white,
          onIndexChangedListener: (index) {
            setState(() {
              currentIndex = index;
              _controller.animateToPage(currentIndex,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              //print(currentIndex);
            });
          },
          icons: const [
            Icons.dashboard_outlined,
            Icons.circle_outlined,
            Icons.history_outlined,
            Icons.settings_outlined,
          ],
        ),
      ),
    );
  }
}
