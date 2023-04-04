import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeNow {
  List<Map<String, dynamic>> initializeWeeks(int year) {
    return getWeeksForRange(DateTime.utc(year, 1, 1), DateTime.utc(year+1, 1, 1));
  }

  List<Map<String, dynamic>> getWeeksForRange(DateTime start, DateTime end) {
    var date = start;
    DateTime monday;
    DateTime sunday;
    if (date.weekday != 1) {
      monday = date.subtract(Duration(days: date.weekday - 1));
    } else {
      monday = date;
    }

    List<Map<String, dynamic>> weeks = [];

    while (date.difference(end).inDays <= 0) {
      if (date.weekday == 1) {
        monday = date;
      }

      if (date.weekday == 7) {
        sunday = date;
        weeks.add({
          'monday': monday,
          'sunday': sunday,
          'week':
              "Week ${monday.day.toString().padLeft(2, '0')} - ${sunday.day.toString().padLeft(2, '0')}",
          'selected' : false
        });
      }
      date = date.add(const Duration(days: 1));
    }

    return weeks;
  }
}
