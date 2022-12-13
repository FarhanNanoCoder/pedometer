import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/core/appButtons.dart';
import 'package:pedometer/core/appText.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  RxInt steps = 0.obs;
  RxInt stepsManual = 0.obs;
  double prevMag = 0.0, prevX = 0.0, prevY = 0.0, prevZ = 0.0;
  RxString mode = "Holding".obs;
  List<dynamic> data = [];
  List<List<dynamic>> rows = [];
  bool start = false;
  double xGyro = 0.0;
  double yGyro = 0.0;
  double zGyro = 0.0;

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
        data.add({
          "timestamp": DateTime.now().toString(),
          "x_acc": xAcc,
          "y_acc": yAcc,
          "z_acc": zAcc,
          "x_gyro": xGyro,
          "y_gyro": yGyro,
          "z_gyro": zGyro,
          "prev_mag": prevMag,
          "mag": mag,
          "mag_delta": mag - prevMag,
          "original_steps": stepsManual.value
        });
        // var tempMode = mode;
        // if (y - prevY >= 0.762 && z - prevZ <= 0.0762) {
        //   //2.5 feet in moving axis, 3 inch in perpendicuar axis
        //   tempMode.value = "Walking and holding the phone in hand";
        // } else {
        //   tempMode.value = "Holding";
        // }
        if (magDelta > 5.5) {
          steps.value++;
        }
        prevMag = mag;
        prevX = xAcc;
        // mode = tempMode;
        prevY = yAcc;
        prevZ = zAcc;
      }
    });
  }

  void saveData() async {
    List<dynamic> cols = [];
    cols.add("timestamp");
    cols.add("x_acc");
    cols.add("y_acc");
    cols.add("z_acc");
    cols.add("x_gyro");
    cols.add("y_gyro");
    cols.add("z_gyro");
    cols.add("prev_mag");
    cols.add("mag");
    cols.add("mag_delta");
    cols.add("original_steps");
    rows.add(cols);

    for (int i = 0; i < data.length; i++) {
      List<dynamic> row = [];
      row.add(data[i]["timestamp"]);
      row.add(data[i]["x_acc"]);
      row.add(data[i]["y_acc"]);
      row.add(data[i]["z_acc"]);
      row.add(data[i]["x_gyro"]);
      row.add(data[i]["y_gyro"]);
      row.add(data[i]["z_gyro"]);
      row.add(data[i]["prev_mag"]);
      row.add(data[i]["mag"]);
      row.add(data[i]["mag_delta"]);
      row.add(data[i]["original_steps"]);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);
    Get.snackbar("Saving", dir);
    File temp = File("$dir/res.csv");
    temp.writeAsString(csv);
  }

  void resetValues() {
    steps.value = 0;
    stepsManual.value = 0;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: 'Counter', style: 'bold', size: 18).getText(),
            const SizedBox(
              height: 36,
            ),
            Obx(() => Center(
                child: AppText(text: steps.toString(), size: 48, style: 'bold')
                    .getText())),
            Obx((() => Center(
                    child: AppText(
                  text: mode.value,
                  size: 16,
                ).getText()))),
            const SizedBox(
              height: 24,
            ),
            AppButton(context: context).getOutlinedTextButtton(
                title: start ? "Stop" : "Start",
                onPressed: () {
                  setState(() {
                    start = !start;
                  });
                }),
            const SizedBox(
              height: 24,
            ),
            AppButton(context: context).getOutlinedTextButtton(
              title: "Reset",
              onPressed: resetValues,
            ),
            const SizedBox(
              height: 24,
            ),
            AppButton(context: context)
                .getOutlinedTextButtton(title: "Save", onPressed: saveData),
            const SizedBox(
              height: 24,
            ),
            Obx(() => AppButton(context: context).getTextButton(
                size: Size(MediaQuery.of(context).size.width, 800),
                title: "Count($stepsManual)",
                onPressed: () {
                  stepsManual.value++;
                })),
          ],
        ),
      ),
    ));
  }
}
