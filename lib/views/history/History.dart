import 'package:flutter/material.dart';
import 'package:pedometer/core/appText.dart';

class History extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: AppText(text: "History").getText(),));
  }

}