import 'package:chronos/data/repositories/allReminders.dart';
import 'package:flutter/material.dart';

class Week {
  Week(
      {required this.monday,
      required this.sunday,
      required this.selected,
      required this.week,
      required this.reminders});

  DateTime monday;
  DateTime sunday;
  String week;
  bool selected;
  Reminders? reminders;

  Map toJson(){
    return {
      'monday' : monday,
      'sunday' : sunday,
      'week' : week,
      'selected' : selected,
    };
  }
}
