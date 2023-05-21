import 'package:chronos/data/repositories/hive_allReminders.dart';
import 'package:flutter/material.dart';

class User {
  String username;
  String id;
  DateTime initializationDay;
  List<Reminders>? userReminders;

  User(
      {required this.id,
      required this.username,
      required this.initializationDay,
      required this.userReminders});
}
