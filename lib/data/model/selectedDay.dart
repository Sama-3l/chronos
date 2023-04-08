import 'package:chronos/data/model/week.dart';
import 'package:flutter/material.dart';

class SelectedDay {
  SelectedDay({required this.selectedWeekIndex, required this.selectedDay});

  int selectedWeekIndex;
  DateTime selectedDay;
}
