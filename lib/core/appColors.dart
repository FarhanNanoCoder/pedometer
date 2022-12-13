import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _instance = AppColors._internal();
  factory AppColors() {
    return _instance;
  }
  AppColors._internal();

  Color white = Colors.white;
  Color themeColor = const Color(0xFF2F2E41);
  Color themeDark = const Color(0xFF2F2E41);
  Color themeLight = const Color(0xFFFF865E);
  Color grey900 = (Colors.grey[900])!;
  Color grey800 = (Colors.grey[800])!;
  Color grey = (Colors.grey[200])!;
  Color grey600 = (Colors.grey[600])!,
      grey400 = (Colors.grey[400])!,
      grey300 = (Colors.grey[300])!,
      grey200 = (Colors.grey[200])!,
      grey100 = (Colors.grey[100])!,
      red = Colors.redAccent,
      themeHappy = const Color(0xFFFFAB76),
      themeMatteBlue = Color.fromARGB(255, 50, 78, 92),
      // themeGood = const Color(0xFFFF8474),
      // themeOkay = const Color(0xFF14B9C5),
      // themeSad = const Color(0xFF6B4F4F),
      // themeAwful = const Color(0xFF3F3351),
      // themeGreatDark = const Color(0xFF263238),
      // themeGoodDark = const Color(0xFF263238),
      // themeOkayDark = const Color(0xFF263238),
      // themeSadDark = const Color(0xFF574444),
      // themeAwfulDark = const Color(0xFF2D253A),
      themeBrownMedium = const Color(0xFFE6CCA9),
      themeBrownLight = const Color(0xFFE6CCA9),
      themeBrownUltraLight = const Color(0xFFFFF3E4),
      themeMatteYellow = const Color(0xFFFFDD94),
      themeMatteYellowLight = const Color(0xFFF9E697),
      themeMatteOrange = const Color(0xFFFBC591),
      themeMatteOrangeDeep = const Color(0xFFFAB97B),
      themeBrownDeep = const Color(0xFF6B4F4F),
      themeMatteGreenDeep = const Color(0xFF345B63),
      themeMatteRed = const Color(0xFFFF8474);
}
