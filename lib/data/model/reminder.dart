import 'package:chronos/data/model/topic.dart';
import 'package:flutter/material.dart';

class Reminder {
  bool isDescriptive;
  String tag1;
  String tag2;
  Color color;
  String deadlineType;
  DateTime deadline;
  String subtitle;
  List<Topic>? topics;

  Reminder(
      {required this.isDescriptive,
      required this.tag1,
      required this.tag2,
      required this.color,
      required this.deadline,
      required this.subtitle,
      this.topics,
      required this.deadlineType});
}
