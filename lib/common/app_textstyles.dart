import 'package:flutter/material.dart';
import 'app_custom_size.dart';

class CustomTextStyle {
  static TextStyle h1({Color color = const Color(0xFF000000)}) => TextStyle(
      fontFamily: 'ClashDisplay',
      color: color,
      fontSize: CustomSize.getFontSize(38),
      height: 1.2,
      fontStyle: FontStyle.normal,
      letterSpacing: 1,
      fontWeight: FontWeight.w600);
// 35.px
}
