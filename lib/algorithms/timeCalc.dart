import 'package:chronos/data/model/reminder.dart';
import 'package:chronos/data/model/week.dart';
import 'package:chronos/data/repositories/allReminders.dart';
import 'package:chronos/data/repositories/weeks.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeNow {
  Weeks initializeWeeks(DateTime start) {
    return getWeeksForRange(DateTime.utc(start.year, start.month, start.day),
        DateTime.utc(start.year + 1, start.month, start.day));
  }

  Weeks getWeeksForRange(DateTime start, DateTime end) {
    var date = start;
    DateTime monday;
    DateTime sunday;
    if (date.weekday != 1) {
      monday = date.subtract(Duration(days: date.weekday - 1));
    } else {
      monday = date;
    }

    Weeks weekObject = Weeks();

    while (date.difference(end).inDays <= 0) {
      if (date.weekday == 1) {
        monday = date;
      }

      if (date.weekday == 7) {
        sunday = date;
        weekObject.weeks.add(Week(
            monday: monday,
            sunday: sunday,
            selected: false,
            reminders: Reminders(allReminders: [Reminder()]),
            week:
                "Week ${monday.day.toString().padLeft(2, '0')} - ${sunday.day.toString().padLeft(2, '0')}"));
      }
      date = date.add(const Duration(days: 1));
    }

    return weekObject;
  }
}
