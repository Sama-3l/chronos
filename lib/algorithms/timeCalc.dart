// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:chronos/business_logic/blocs/date_selected/date_selected_bloc.dart';
import 'package:chronos/data/model/hive_reminder.dart';
import 'package:chronos/data/model/hive_week.dart';
import 'package:chronos/data/repositories/hive_allReminders.dart';
import 'package:chronos/data/repositories/hive_weeks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/model/selectedDay.dart';

class TimeNow {
  Weeks initializeWeeks(DateTime start) {
    return getWeeksForRange(DateTime.utc(start.year, start.month, start.day),
        DateTime.utc(start.year + 1, start.month, start.day));
  }

  Weeks getWeeksForRange(DateTime start, DateTime end) {
    var date = start;
    DateTime monday;
    DateTime sunday = DateTime.now();
    if (date.weekday != 1) {
      monday = date.subtract(Duration(days: date.weekday - 1));
    } else {
      monday = date;
    }

    Weeks weekObject = Weeks();

    int p = 0;
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
            reminders: Reminders(allReminders: []),
            week:
                "Week ${monday.day.toString().padLeft(2, '0')} - ${sunday.day.toString().padLeft(2, '0')}"));
        p++;
      }
      date = date.add(const Duration(days: 1));
    }

    return weekObject;
  }

  Future<void> selectDate(BuildContext context, DateTime initialDate,
      Reminders currentReminder, SelectedDay selectedDay) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay.selectedDay,
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
      builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: Colors.grey[800],
          colorScheme: ColorScheme.light(
            primary: currentReminder.allReminders[currentReminder.allReminders.length - 1].color, // <-- SEE HERE
            onPrimary: Colors.white, // <-- SEE HERE
            onSurface: Colors.white, // <-- SEE HERE
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.white, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(initialDate.subtract(Duration(days: 1)));
      },
    );

    if (picked != null) {
      currentReminder.allReminders[currentReminder.allReminders.length - 1]
          .deadline = picked;
    }

    BlocProvider.of<DateSelectedBloc>(context).add(DateChangedEvent());
  }

  Future<void> editDate(BuildContext context, DateTime initialDate,
      Reminders currentReminder, SelectedDay selectedDay) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentReminder.allReminders[currentReminder.allReminders.length - 1].deadline,
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
      builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.amberAccent, // <-- SEE HERE
            onPrimary: Colors.redAccent, // <-- SEE HERE
            onSurface: Colors.blueAccent, // <-- SEE HERE
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.red, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(initialDate.subtract(Duration(days: 1)));
      },
    );

    if (picked != null) {
      currentReminder.allReminders[currentReminder.allReminders.length - 1]
          .deadline = picked;
    }

    BlocProvider.of<DateSelectedBloc>(context).add(DateChangedEvent());
  }
}
