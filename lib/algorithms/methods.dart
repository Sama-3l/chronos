// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/reminder.dart';
import 'package:chronos/data/repositories/allReminders.dart';
import 'package:chronos/data/repositories/weeks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/model/selectedDay.dart';
import '../data/model/week.dart';
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

  
}
