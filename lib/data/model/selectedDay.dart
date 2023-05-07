import 'package:chronos/data/model/week.dart';
import 'package:flutter/material.dart';

import '../repositories/allReminders.dart';

class SelectedDay {
  SelectedDay({required this.selectedWeekIndex, required this.selectedDay, this.allReminders});

  int selectedWeekIndex;
  DateTime selectedDay;
  Reminders? allReminders;
}
