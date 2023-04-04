// ignore_for_file: prefer_const_constructors, empty_constructor_bodies

import 'package:chronos/constants/colors.dart';
import 'package:flutter/material.dart';

class DayOfWeek extends SliverPersistentHeaderDelegate {
  DayOfWeek({required this.maxheight, required this.minheight});

  double maxheight;
  double minheight;
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
                    borderRadius: BorderRadius.circular(10))),
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
