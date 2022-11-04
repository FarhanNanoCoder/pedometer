import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appText.dart';

class AppTitleView extends StatelessWidget {
  String title;
  AppTitleView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: "#${title}", style: 'bold', size: 24).getText(),
        const SizedBox(height: 2,),
        Container(
          width: MediaQuery.of(context).size.width*.6,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors().themeColor,
          ),
        ),
      ],
    );
  }
}
