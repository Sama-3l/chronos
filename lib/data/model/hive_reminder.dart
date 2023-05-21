import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'hive_topic.dart';

part 'hive_reminder.g.dart';

@HiveType(typeId: 2)
class Reminder {
  Reminder(
      {required this.isDescriptive,
      required this.tag1,
      required this.tag2,
      required this.color,
      required this.deadline,
      required this.subtitle,
      required this.deadlineType,
      this.topics});

  @HiveField(0)
  bool isDescriptive;

  @HiveField(1)
  String tag1;

  @HiveField(2)
  String tag2;

  @HiveField(3)
  Color color;

  @HiveField(4)
  String deadlineType;

  @HiveField(5)
  DateTime deadline;

  @HiveField(6)
  String subtitle;

  @HiveField(7)
  List<Topic>? topics;
}