import 'package:flutter/material.dart';

class AppColors {
  static Color get lightGreen => const Color.fromARGB(255, 58, 142, 130);

  static Color get darkGrey => Color.fromARGB(255, 137, 145, 160);

  static Color get superDarkGray => Color(0xff141414).withOpacity(0.7);

  static Color get blueColor => Color.fromARGB(255, 3, 104, 255);

  static Color get bgBlue => Color(0xff2D74FF);

  static Color get tfBorderColor => Color.fromARGB(255, 225, 227, 231);

  static Color get tfBGColor => Color.fromARGB(80, 220, 220, 220);

  static Color get yellow => Color(0xffFF9F10);

  static Color get green => Color(0xff0EAE44);

  static Color get dangerAlertColor => Color(0xffED5D20);

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
