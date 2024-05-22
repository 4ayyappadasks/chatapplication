import 'package:flutter/material.dart';

class Datechanging {
  static String Getformated_Date(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessagetime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return "${sent.day}  ${getmonth(sent)}";
  }

  static String getlastactivetime(
      {required BuildContext context, required String lastactive}) {
    final int i = int.tryParse(lastactive) ?? -1;
    if (i == -1) return "last seen not available";
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formateditime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == time.day &&
        time.month == time.month &&
        time.year == time.year) {
      return "lastseen seen today ${formateditime}";
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return "last seen yesterday at ${formateditime}";
    }
    String month = getmonth(time);
    return "last seen on ${time.day}$month on ${formateditime}";
  }

  static getmonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "NA";
  }
}
