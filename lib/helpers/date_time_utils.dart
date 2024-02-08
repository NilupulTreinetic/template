import 'package:intl/intl.dart';

class DateTimeUtil {
  static final DateTimeUtil _singleton = DateTimeUtil._internal();

  factory DateTimeUtil() {
    return _singleton;
  }

  DateTimeUtil._internal();

  getFormattedDate(String date, {String dateFormat = "yyyy-MMM-dd"}) {
    try {
      return DateFormat(dateFormat).format(DateTime.parse(date));
    } catch (e) {
      return "";
    }
  }

  convert12HoursFormat(time) {
    try {
      DateTime dateTime =
          DateFormat("hh:mm").parse("${time.hour}:${time.minute}");
      DateFormat timeFormat = DateFormat("h:mm a");
      return timeFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  getFormattedTime(String date) =>
      DateFormat("hh:mm a").format(DateTime.parse(date));

  int getMonthNumber(String monthName) {
    final months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    String formattedMonthName = monthName.toLowerCase().trim().replaceAllMapped(
          RegExp(r'(^\w|\s\w)'),
          (match) => match.group(0)!.toUpperCase(),
        );

    return months[formattedMonthName] ?? 0;
  }

  getPostFormattedTime(DateTime createdDate) {
    final now = DateTime.now();
    final difference = now.difference(createdDate);
    if (difference.inDays > 3) {
      return getFormattedDate(createdDate.toString(),
          dateFormat: 'dd MMM yyyy');
    }
    if (difference.inDays > 0) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 0) {
      return 'today';
    } else if (difference.inMinutes > 0) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
