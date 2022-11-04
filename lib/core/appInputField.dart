import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appText.dart';

class AppInputField {
  final Function(String value)? onChange;
  final FormFieldValidator<String>? validator;
  String? label, hint;
  double borderRadius;
  bool goNextOnComplete, obscureText;
  String? prefixText, suffixText;
  Widget? prefixIcon, suffixIcon;
  TextEditingController? textEditingController;
  TextInputType? textInputType;
  int minLines;
  int maxLines;
  int? maxLength;
  Color textColor, cursorColor, enabledBorderColor, focusedBorderColor;
  Color? backgroundColor;
  bool noBorder, showCounterText;

  AppInputField({
    this.onChange,
    this.validator,
    this.label,
    this.hint,
    this.borderRadius = 8,
    this.prefixText,
    this.prefixIcon,
    this.suffixText,
    this.suffixIcon,
    this.textEditingController,
    this.goNextOnComplete = false,
    this.textInputType,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    Color? textColor,
    Color? cursorColor,
    Color? enabledBorderColor,
    Color? focusedBorderColor,
    this.backgroundColor,
    this.noBorder = false,
    this.showCounterText = true,
  })  : textColor = textColor ?? AppColors().themeDark,
        cursorColor = cursorColor ?? AppColors().themeDark,
        enabledBorderColor = enabledBorderColor ?? AppColors().grey300,
        focusedBorderColor = focusedBorderColor ?? const Color(0xFF607D8B);

  static InputDecoration getDefaultInputDecoration({
    String? hint,
    String? label,
    double borderRadius = 8.0,
    String? prefixText,
    Widget? prefixIcon,
    String? suffixText,
    Widget? suffixIcon,
    bool showCounterText = true,
    Color? hintOrLabelColor,
    Color? enabledBorderColor,
    Color? focusedBorderColor,
    Color? backgroundColor,
  }) {
    hintOrLabelColor ??= AppColors().grey600;

    enabledBorderColor ??= AppColors().grey300;

    focusedBorderColor ??= AppColors().themeDark;

    return InputDecoration(
      hintText: hint,
      
      hintStyle: AppText(
        style: 'regular',
        color: hintOrLabelColor,
        size: 16,
      ).getStyle(),
      helperStyle: AppText(
        style: 'regular',
        color: AppColors().grey400,
        size: 10,
      ).getStyle(),
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: AppText(
        style: 'regular',
        color: hintOrLabelColor,
        size: 16,
      ).getStyle(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 1,
        ),
      ),
      errorStyle: AppText(
        style: 'regular',
        color: AppColors().red,
        size: 12,
      ).getStyle(),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: AppColors().red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: AppColors().red,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: enabledBorderColor,
          width: 1,
        ),
      ),
      fillColor: backgroundColor,
      filled: backgroundColor != null ? true : false,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      suffixText: suffixText,
      suffixIcon: suffixIcon,
      counterText: showCounterText ? null : "",
    );
  }

  TextFormField getField(BuildContext context) {
    return TextFormField(
      /*onEditingComplete: () {
        if (goNextOnComplete) {
          return Functions.nextEditableTextFocus(context);
        } else {
          return FocusScope.of(context).unfocus();
        }
      },*/
      
      style: AppText(color: textColor).getStyle(),
      keyboardType: textInputType ?? TextInputType.text,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: textEditingController,
      autofocus: false,
      cursorColor: textColor,
      onChanged: (value) {
        if (onChange != null) {
          onChange!(value);
        }
      },
      validator: validator,
      textInputAction: (maxLines > 1)
          ? TextInputAction.newline
          : (goNextOnComplete ? TextInputAction.next : TextInputAction.done),
      obscureText: obscureText,
      decoration: getDefaultInputDecoration(
        hint: hint,
        label: label,
        borderRadius: borderRadius,
        prefixText: prefixText,
        prefixIcon: prefixIcon,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        enabledBorderColor: enabledBorderColor,
        focusedBorderColor: focusedBorderColor,
        backgroundColor: backgroundColor,
        showCounterText: showCounterText,
      ),
    );
  }
}
