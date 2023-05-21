import 'package:chronos/data/repositories/hive_allReminders.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hive_week.g.dart';

@HiveType(typeId: 4)
class Week {
  Week(
      {required this.monday,
      required this.sunday,
      required this.selected,
      required this.week,
      required this.reminders});

  @HiveField(0)
  DateTime monday;

  @HiveField(1)
  DateTime sunday;

  @HiveField(2)
  String week;

  @HiveField(3)
  bool selected;

  @HiveField(4)
  Reminders reminders;
}