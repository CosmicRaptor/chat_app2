import 'package:flutter/material.dart';

class DateUtil{
  static String getLastMessageTime(
  {required BuildContext context, required String time}){
    final Date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if(now.day == Date.day && now.month == Date.month && now.year == Date.year){
      return TimeOfDay.fromDateTime(Date).format(context);
    }
    else {
      return '${Date.day} ${_getMonth(Date)}';
    }
  }

  static String _getMonth (DateTime date){
    switch (date.month){
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
    return 'N/A';
  }
}