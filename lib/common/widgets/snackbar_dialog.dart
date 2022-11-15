import 'package:flutter/material.dart';

class SnackBarDialog {
  static void showSnackBar(BuildContext context, String msg,
      {bool isNormal = true, int seconds = 3, Color? bgColor}) {
    final scaffold = ScaffoldMessenger.of(context);
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      duration: Duration(seconds: seconds),
      backgroundColor: bgColor ?? Colors.redAccent,
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    );
    scaffold.showSnackBar(snackBar);
  }
}
