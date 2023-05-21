import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import '../model/hive_reminder.dart';
import '../model/hive_week.dart';

part 'hive_allReminders.g.dart';

@HiveType(typeId: 5)
class Reminders{
  Reminders(
      {required this.allReminders,
      this.remindersMappedToMonth});

  @HiveField(0)
  List<Reminder> allReminders;
  

  @HiveField(1)
  Map<Week, List<Reminders>?>? remindersMappedToMonth;
}