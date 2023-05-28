// ignore_for_file: prefer_const_constructors

import 'package:chronos/data/model/hive_reminder.dart';
import 'package:chronos/data/model/hive_week.dart';
import 'package:flutter/material.dart';
import 'package:chronos/data/services/notification.dart';

class SetNotification {
  final NotificationService _notify = NotificationService();

  void setAllNotifications(Reminder reminder, Week week) {
    // We have notifications three times a day at 6 am, 6 pm, 10 pm
    DateTime currentDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime currentTime = DateTime.now();
    DateTime date = week.monday;
    print(week.sunday.difference(reminder.deadline).inDays);

    if (reminder.deadlineType == "thisWeek") {
      if (currentDay.difference(week.monday).inDays < 0) {
        //For when the reminder is in this week

      } else {
        // For upcoming weeks
        while (date.difference(week.sunday).inDays <= 0) {
          print(date);
          date = date.add(Duration(days: 1));
        }
      }
    }
    // _notify.initializeNotification();
    // _notify.showNotification(1, 'hello', 'World');
  }
}
