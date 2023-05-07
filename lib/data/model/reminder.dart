import 'package:chronos/data/model/topic.dart';
import 'package:flutter/material.dart';

class Reminder{
  bool isDescriptive;
  String? tag1;
  String? tag2;
  Color? color;
  String? deadlineType;
  DateTime? deadline;
  List<Topic>? topics;

  Reminder({required this.isDescriptive, this.tag1, this.tag2, this.color, this.deadline, this.topics, this.deadlineType});
}