import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'hive_topic.g.dart';

@HiveType(typeId: 3)
class Topic {
  Topic({required this.description, this.subTopics});

  @HiveField(0)
  String description;

  @HiveField(1)
  List<Topic>? subTopics;
}