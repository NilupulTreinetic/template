import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/widgets/snackbar_dialog.dart';

class Utils {
  static bool isValidEmail(
      {required String email, required BuildContext context}) {
    bool isValid = true;
    if (email.isEmpty) {
      SnackBarDialog.showSnackBar(context, "Please enter Email");
      return isValid = false;
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.trim());
    if (!emailValid) {
      SnackBarDialog.showSnackBar(context, "Please enter a valid Email");
      return isValid = false;
    }
    return isValid;
  }

  static validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10 && phoneNumber.startsWith('0')) {
      return true;
    } else {
      return false;
    }
  }

  static getFormattedDate(String date, {String dateFormat = "yyyy-MMM-dd"}) {
    try {
      return DateFormat(dateFormat).format(DateTime.parse(date));
    } catch (e) {
      return "";
    }
  }

  static convert12HoursFormat(time) {
    try {
      DateTime dateTime =
          DateFormat("hh:mm").parse("${time.hour}:${time.minute}");
      DateFormat timeFormat = DateFormat("h:mm a");
      return timeFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  static getFormattedTime(String date) =>
      DateFormat("hh:mm a").format(DateTime.parse(date));
}
