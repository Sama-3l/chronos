import 'package:chronos/constants/colors.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  TaskCard({super.key, required this.tagColor});

  Color tagColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 15),
      child: Container(
          decoration: BoxDecoration(
              color: tagColor, borderRadius: BorderRadius.circular(30))),
    );
  }
}
