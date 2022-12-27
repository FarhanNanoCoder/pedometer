import 'dart:ui';
import 'package:flutter/material.dart';

showAppDialog({required BuildContext context,required Widget child,bool barrierDismissible=true}){
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (context){
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: child
          ),
        );
      }
  );
}