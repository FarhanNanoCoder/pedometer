import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'appColors.dart';
import 'appText.dart';

void showAppSnackbar({
  required String title,
  required String message,
  int type = 0,
}) {
  //0=success, 1=error, 2=warning
  Color backgroundColor = Colors.black;
  Color textColor = AppColors().white;
  Get.snackbar(
    title.toUpperCase(),
    message,
    backgroundColor: backgroundColor,
    margin: const EdgeInsets.all(0),
    borderRadius: 0,
    colorText: textColor,
    titleText: AppText(
        text: title.toUpperCase(),
        color: textColor,
        style: 'bold',
        size: title==""?0:18.0,
      ).getText(),
      messageText: AppText(
        text: message,
        color: textColor,
        size: message==""?0:16.0,
      ).getText(),
      snackPosition: SnackPosition.BOTTOM,
  );
}
