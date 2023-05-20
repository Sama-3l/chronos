// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/algorithms/methods.dart';
import 'package:chronos/algorithms/widgetDecider.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/selectedDay.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/reminder.dart';

class TaskCard extends StatelessWidget {
  TaskCard({super.key, required this.reminder, required this.selectedDay});

  SelectedDay selectedDay;
  Reminder reminder;
  PrimaryColors col = PrimaryColors();
  Methods func = Methods();
  WidgetDecider wd = WidgetDecider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            color: reminder.color, borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(reminder.tag1.toUpperCase(),
                            minFontSize: 30,
                            maxLines: 1,
                            style: GoogleFonts.questrial(
                                letterSpacing: 0.5,
                                fontSize: 42,
                                color: col.primaryTextColor,
                                fontWeight: FontWeight.w600)),
                        AutoSizeText(reminder.tag2.toUpperCase(),
                            minFontSize: 30,
                            maxLines: 1,
                            style: GoogleFonts.questrial(
                                letterSpacing: 0.5,
                                fontSize: 42,
                                color: col.primaryTextColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: wd.decideDeadline(reminder)),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 20, bottom: 20),
              child: Row(children: wd.returnSubtitleRow(reminder)),
            )
          ]),
        ),
      ),
    );
  }
}
