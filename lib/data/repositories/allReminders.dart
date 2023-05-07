import 'package:chronos/data/model/reminder.dart';
import 'package:chronos/data/model/week.dart';
import 'package:flutter/material.dart';

class Reminders{
  List<Reminder> allReminders;
  Map<Week, List<Reminders>?>? remindersMappedToMonth;

  Reminders({required this.allReminders, this.remindersMappedToMonth});
}