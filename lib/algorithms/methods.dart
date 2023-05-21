// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/hive_reminder.dart';
import 'package:chronos/data/repositories/hive_allReminders.dart';
import 'package:chronos/data/repositories/hive_weeks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/model/selectedDay.dart';
import '../data/model/hive_week.dart';
import '../presentation/widgets/eachDay.dart';
import '../presentation/widgets/taskCard.dart';

class Methods {
  List<Widget> selectedWeek(SelectedDay? setDay, Weeks weekObject,
      int weekSelectedIndex, SelectedDay selectedDay) {
    List<Widget> weekDays = [];
    DateTime date = weekObject.weeks[weekSelectedIndex].monday;
    DateTime end = weekObject.weeks[weekSelectedIndex].sunday;
    bool selected = false;
    while (date.difference(end).inDays <= 0) {
      if (DateUtils.isSameDay(date, setDay!.selectedDay)) {
        selected = true;
      } else {
        selected = false;
      }

      if (date.weekday == 1) {
        weekDays.add(Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Day(
              date: date.day.toString().padLeft(2, '0'),
              index: date.weekday - 1,
              selected: selected,
              dateTime: date,
              selectedDay: selectedDay),
        ));
      } else if (date.weekday == 7) {
        weekDays.add(Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Day(
              date: date.day.toString().padLeft(2, '0'),
              index: date.weekday - 1,
              selected: selected,
              dateTime: date,
              selectedDay: selectedDay),
        ));
      } else {
        weekDays.add(Day(
          date: date.day.toString().padLeft(2, '0'),
          index: date.weekday - 1,
          selected: selected,
          dateTime: date,
          selectedDay: selectedDay,
        ));
      }
      if (date.weekday != 7) weekDays.add(Spacer());
      date = date.add(const Duration(days: 1));
    }

    return weekDays;
  }

  String checkTodayStatus(
      SelectedDay selectedDay, DateTime todayDateTimeObject) {
    if (selectedDay.selectedDay.day == todayDateTimeObject.day) {
      return "Today";
    } else {
      return "Selected";
    }
  }

  int calculateWeekIndex(DateTime? date, DateTime initial) {
    while (date!.weekday != 7) {
      date = date.add(Duration(days: 1));
    }
    if (date.difference(initial).inDays == -7) {
      return 0;
    } else {
      return ((date.difference(initial).inDays) / 7).ceil();
    }
  }

  void initializeWeeklyReminders(Reminders allReminders, Weeks weekObject) {
    for (int i = 0; i < allReminders.allReminders.length; i++) {
      if (allReminders.allReminders[i].deadlineType == "none") {
        for (int j = 0; j < weekObject.weeks.length; j++) {
          if (weekObject.weeks[j].reminders == null) {
            weekObject.weeks[j].reminders =
                Reminders(allReminders: [allReminders.allReminders[i]]);
          } else {
            weekObject.weeks[j].reminders.allReminders
                .add(allReminders.allReminders[i]);
          }
        }
      } else if (weekObject
              .weeks[calculateWeekIndex(allReminders.allReminders[i].deadline,
                  weekObject.weeks[0].sunday)]
              .reminders ==
          null) {
        weekObject
                .weeks[calculateWeekIndex(allReminders.allReminders[i].deadline,
                    weekObject.weeks[0].sunday)]
                .reminders =
            Reminders(allReminders: [allReminders.allReminders[i]]);
      } else {
        weekObject
            .weeks[calculateWeekIndex(allReminders.allReminders[i].deadline,
                weekObject.weeks[0].sunday)]
            .reminders
            .allReminders
            .add(allReminders.allReminders[i]);
      }
    }
  }

  String getSelectedDate(DateTime selectedDay) {
    final weekday = DateFormat('EEEE').format(selectedDay);
    final day = DateFormat('d').format(selectedDay);
    final month = DateFormat('MMMM').format(selectedDay);
    final year = DateFormat('y').format(selectedDay);

    return '$weekday $day, $month $year';
  }

  bool checkOnOrBefore(Reminders currentReminder) {
    return currentReminder.allReminders[currentReminder.allReminders.length - 1]
                .deadlineType ==
            "on" ||
        currentReminder.allReminders[currentReminder.allReminders.length - 1]
                .deadlineType ==
            "before";
  }
}
