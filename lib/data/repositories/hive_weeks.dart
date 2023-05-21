import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:chronos/data/model/hive_week.dart';

part 'hive_weeks.g.dart';

@HiveType(typeId: 6)
class Weeks {

  @HiveField(0)
  List<Week> weeks = [];
}