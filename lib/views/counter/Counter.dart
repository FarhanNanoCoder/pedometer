import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/core/appButtons.dart';
import 'package:pedometer/core/appColors.dart';
import 'package:pedometer/core/appText.dart';
import 'package:pedometer/core/functions.dart';
import 'package:pedometer/models/userFitModel.dart';
import 'package:pedometer/services/api/baseApi.dart';
import 'package:pedometer/services/api/countApi.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  RxInt steps = 0.obs;
  double prevMag = 0.0, prevX = 0.0, prevY = 0.0, prevZ = 0.0;
  RxString mode = "Holding".obs;
  List<List<double>> data = [];
  bool start = false;
  double xGyro = 0.0;
  double yGyro = 0.0;
  double zGyro = 0.0;

  Future setCount() async {
    if (start) {
      List<List<double>> temp = [
        for (var item in data) [...item]
      ];
      // showAppSnackbar(title: "In counter", message: temp.length.toString());
      data.clear();
      // showAppSnackbar(title: "In counter", message: temp.length.toString());
      int tempCount = await BaseApi().countApi.getCount(data: temp);
      if (start) {
        steps.value += tempCount;
      }
    }
  }

  @override
  void initState() {
    super.initState();
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
        // if (magDelta > 5) {
        //   steps.value++;
        // }
        if (data.length > 99) {
          // showAppSnackbar(title: "", message: "limit encountered");
          setCount();
        }
        prevMag = mag;
        prevX = xAcc;
        prevY = yAcc;
        prevZ = zAcc;
      }
    });
  }

  void submitData() async {
    UserFitModel? userFitModel = await BaseApi()
        .userFitApi
        .getUserFit(id: DateTime.now().toString().substring(0, 10));
    if (userFitModel != null) {
      userFitModel.steps += steps.value;
      userFitModel.caloriesBurnt = userFitModel.steps * .35;
      userFitModel.distanceWalked = userFitModel.steps * 0.00071;
      BaseApi().userFitApi.setUserFit(userFitModel: userFitModel);
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
                    submitData();
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
