// ignore_for_file: prefer_const_constructors, empty_constructor_bodies

import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/hive_week.dart';
import 'package:flutter/material.dart';

class DayOfWeek extends SliverPersistentHeaderDelegate {
  DayOfWeek(
      {required this.maxheight,
      required this.minheight,
      required this.thisWeek,
      required this.currentWeekMap});

  double maxheight;
  double minheight;
  Week currentWeekMap;
  List<Widget> thisWeek;
  PrimaryColors col = PrimaryColors();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: col.appColor,
      child: Padding(
          padding: EdgeInsets.only(top: 10, left: 13, right: 13, bottom: 25),
          child: SizedBox(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(child: Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: thisWeek),
                ))),
          )),
    );
  }

  @override
  double get maxExtent => maxheight;

  @override
  double get minExtent => minheight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
