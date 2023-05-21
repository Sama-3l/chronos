import 'package:chronos/data/model/hive_week.dart';
import 'package:flutter/material.dart';

import '../repositories/hive_allReminders.dart';

class SelectedDay {
  SelectedDay({required this.selectedWeekIndex, required this.selectedDay, this.allReminders});

  int selectedWeekIndex;
  DateTime selectedDay;
  Reminders? allReminders;
}
