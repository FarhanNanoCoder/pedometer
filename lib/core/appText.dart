import 'package:flutter/material.dart';

import 'appColors.dart';
class AppText {
  String? text, style = 'regular';
  double? size ;
  Color? color = AppColors().grey900;
  FontWeight? fontWeight;
  TextAlign? textAlign = TextAlign.start;
  TextOverflow? textOverflow;

  AppText({
    this.text,
    this.style,
    this.size=16,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.textOverflow,
  });

  void setFontWeight() {
    if (style == 'medium') {
      fontWeight = FontWeight.w500;
    } else if (style == 'semibold') {
      fontWeight = FontWeight.w600;
    } else if (style == 'bold') {
      fontWeight = FontWeight.w700;
    } else if (style == 'extrabold') {
      fontWeight = FontWeight.w800;
    } else if (style == 'black') {
      fontWeight = FontWeight.w900;
    } else {
      fontWeight = FontWeight.w400;
    }
  }

  Text getText() {
    setFontWeight();
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: fontWeight,
        fontSize: size,
        color: color,
        decoration: TextDecoration.none,
        overflow: textOverflow,
      ),
    );
  }

  TextStyle getStyle() {
    setFontWeight();
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: fontWeight,
      fontSize: size,
      color: color,
      decoration: TextDecoration.none,
    );
  }
}

class AppInputDecoration {
  String? label, hint;
  IconData? suffixIcon, prefixIcon;
  Color? suffixIconColor, prefixIconColor;
  Function()? onSuffixButtonClick;

  AppInputDecoration(
      {this.label,
      this.hint,
      this.suffixIcon,
      this.prefixIcon,
      this.suffixIconColor,
      this.prefixIconColor,
      this.onSuffixButtonClick});

  InputDecoration getInputDecoration() {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppText(style: 'regular', color: AppColors().grey400, size: 16)
          .getStyle(),
      helperStyle:
          AppText(style: 'regular', color: AppColors().grey400, size: 10)
              .getStyle(),
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle:
          AppText(style: 'regular', color: AppColors().grey900, size: 16)
              .getStyle(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors().grey200, width: 1),
      ),
      errorStyle: AppText(style: 'regular', color: AppColors().red, size: 12)
          .getStyle(),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors().red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors().red, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors().grey200, width: 1),
      ),
      suffixIcon: suffixIconColor != null
          ? IconButton(
              onPressed: () {
                onSuffixButtonClick!();
              },
              icon: Icon(
                suffixIcon,
                color: suffixIconColor,
                size: 24,
              ),
            )
          : null,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: prefixIconColor,
              size: 24,
            )
          : null,
    );
  }
}