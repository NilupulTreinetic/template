import 'package:flutter/material.dart';

class CustomTextStyles {
  static TextStyle bold23BlackStyle() {
    return const TextStyle(
        color: Colors.black,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold,
        fontSize: 23);
  }

  static TextStyle bold14BlueStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      // color: AppColors.blueColor,
    );
  }

  static TextStyle regularLato14BlackStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Lato",
      color: Colors.black,
    );
  }

  static TextStyle regularLato14GreyStyle() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Lato",
      color: Colors.black.withOpacity(0.5),
    );
  }
}
