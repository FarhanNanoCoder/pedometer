import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pedometer/core/appButtons.dart';
import 'package:pedometer/core/appColors.dart';
import 'package:pedometer/core/appDialog.dart';
import 'package:pedometer/core/appText.dart';
import 'package:pedometer/core/functions.dart';
import 'package:pedometer/models/userFitModel.dart';
import 'package:pedometer/services/api/baseApi.dart';
import 'package:pedometer/services/api/countApi.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../controllers/userController.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  RxInt steps = 0.obs;
  RxDouble stepSize = 2.5.obs;
  double prevMag = 0.0, prevX = 0.0, prevY = 0.0, prevZ = 0.0;
  final UserController userController = Get.find(tag: 'uc-0');
  RxString mode = "Holding".obs;
  List<List<double>> data = [];
  bool start = false;
  double xGyro = 0.0;
  double yGyro = 0.0;
  double zGyro = 0.0;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future setCount() async {
    if (start) {
      List<List<double>> temp = [
        for (var item in data) [...item]
      ];
      // showAppSnackbar(title: "In counter", message: temp.length.toString());
      data.clear();
      // showAppSnackbar(title: "In counter", message: temp.length.toString());
      int age = DateTime.now().year -
          DateTime.parse(userController.authUser.value?.dob ?? "").year;

      Map<String, dynamic>? res = await BaseApi().countApi.getCount(
          data: temp,
          age: age,
          height: userController.authUser.value?.height ?? 0.0,
          weight: userController.authUser.value?.weight ?? 0.0,
          gender: userController.authUser.value?.gender == "Male"
              ? 1
              : userController.authUser.value?.gender == "Female"
                  ? 0
                  : 2);
      if (start && res != null) {
        int temp = res['count'];
        double stepSize = res['step_size'];
        // showAppSnackbar(title: "", message: res['step_size']?.toString()??"");
        steps.value += temp;
        stepSize = stepSize;
      }
    }
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so used a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    gyroscopeEvents.listen((event) {
      if (start) {
        xGyro = event.x;
        yGyro = event.y;
        zGyro = event.z;
      }
    });
    accelerometerEvents.listen((event) {
      if (start) {
        double xAcc = event.x;
        double yAcc = event.y;
        double zAcc = event.z;
        //filtering
        double mag = sqrt(xAcc * xAcc + yAcc * yAcc + zAcc * zAcc);
        double magDelta = mag - prevMag;
        data.add([
          xAcc,
          yAcc,
          zAcc,
          xGyro,
          yGyro,
          zGyro,
          prevMag,
          mag,
          magDelta,
        ]);

        if (_connectionStatus != ConnectivityResult.none) {
          if (data.length > 99) {
            setCount();
          }
        } else {
          // showAppSnackbar(title: "", message: "In offline mode");
          data.clear();
          if (magDelta > 5) {
            steps.value++;
          }
        }

        prevMag = mag;
        prevX = xAcc;
        prevY = yAcc;
        prevZ = zAcc;
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void submitData(BuildContext context) async {
    UserFitModel? userFitModel = await BaseApi()
        .userFitApi
        .getUserFit(id: DateTime.now().toString().substring(0, 10));
    if (userFitModel != null) {
      userFitModel.steps += steps.value;
      userFitModel.distanceWalked =
          userFitModel.steps * stepSize.value * 0.0003048;
      userFitModel.caloriesBurnt = userFitModel.distanceWalked * 62;
      // showAppSnackbar(
      //     title: "", message: userFitModel.distanceWalked.toString());
      BaseApi().userFitApi.setUserFit(userFitModel: userFitModel);
      showAppDialog(
          context: context,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors().white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(text: "Session completed!", style: "medium", size: 18)
                    .getText(),
                const SizedBox(
                  height: 36,
                ),
                AppText(text: steps.value.toString(), style: "bold", size: 36)
                    .getText(),
                const SizedBox(
                  height: 8,
                ),
                AppText(text: "steps  have been performed", size: 14).getText(),
                const SizedBox(
                  height: 36,
                ),
                AppButton(context: context).getTextButton(
                    title: "Continue",
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ));
    }
    resetValues();
  }

  void resetValues() {
    steps.value = 0;
    setState(() {
      data = [];
      prevMag = 0;
      prevX = 0;
      prevY = 0;
      prevZ = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(text: 'Counter', style: 'bold', size: 24).getText(),
            const SizedBox(
              height: 36,
            ),
            Obx(() => Center(
                child: AppText(
                        text: steps.value.toString(), size: 48, style: 'bold')
                    .getText())),
            AppText(text: "steps have been counted", size: 12).getText(),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppColors().grey200,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                  child:
                      AppText(text: start ? "Walking" : "Holding").getText()),
            ),
            const SizedBox(
              height: 72,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.width * .5,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppColors().grey300,
                ),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * .5),
              ),
              child: Center(
                child: Icon(
                  start
                      ? Icons.directions_walk_outlined
                      : Icons.mode_standby_outlined,
                  size: 72,
                  color: start ? AppColors().themeLight : AppColors().grey800,
                ),
              ),
            ),
            const SizedBox(
              height: 96,
            ),
            AppButton(context: context).getTextButton(
                size: Size(MediaQuery.of(context).size.width, 96),
                backgroundColor:
                    start ? AppColors().red : AppColors().themeLight,
                title: start ? "End session" : "Start session",
                onPressed: () {
                  if (start) {
                    //submit
                    submitData(context);
                  } else {
                    resetValues();
                  }
                  setState(() {
                    start = !start;
                  });
                }),
          ],
        ),
      ),
    ));
  }
}
