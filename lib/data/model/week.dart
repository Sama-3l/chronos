import 'package:flutter/material.dart';

class Week {
  Week(
      {required this.monday,
      required this.sunday,
      required this.selected,
      required this.week});

  DateTime monday;
  DateTime sunday;
  String week;
  bool selected;

  Map toJson(){
    return {
      'monday' : monday,
      'sunday' : sunday,
      'week' : week,
      'selected' : selected,
    };
  }
}
