import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appText.dart';

class AppButton {
  BuildContext context;
  AppButton({required this.context});

  Widget getTextButton(
      {required String title,
      required Function onPressed,
      Color? backgroundColor,
      bool hideShadow = false,
      Size? size,
      Color? textColor}) {
    return TextButton(
        onPressed: () {
          onPressed();
        },
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors().themeColor,
          minimumSize: size ?? Size(MediaQuery.of(context).size.width - 48, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: hideShadow ? 0 : 8,
          shadowColor: AppColors().grey200,
        ),
        child: AppText(
                text: title,
                color: textColor ?? AppColors().white,
                style: "semibold",
                size: 16)
            .getText());
  }

  Widget getOutlinedTextButtton(
      {required String title,
      required Function onPressed,
      Size? size,
      Color? textColor}) {
    return TextButton(
        onPressed: () {
          onPressed();
        },
        
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          minimumSize: size ?? Size(MediaQuery.of(context).size.width - 48, 56),
          
          side: BorderSide(
            color: AppColors().grey200,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          // shadowColor: AppColors().grey200,
        ),
        child: AppText(
                text: title,
                color: textColor ?? AppColors().themeColor,
                style: "semibold",
                size: 16)
            .getText());
  }
}
