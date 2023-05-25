// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/algorithms/widgetDecider.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/selectedDay.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/hive_reminder.dart';

class PopUp extends StatelessWidget {
  PopUp({super.key, required this.reminder, required this.selectedDay});

  Reminder reminder;
  SelectedDay selectedDay;
  PrimaryColors col = PrimaryColors();
  WidgetDecider wd = WidgetDecider();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: reminder.tag1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          color: reminder.color,
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            height: reminder.topics == null
                ? MediaQuery.of(context).size.height * 0.4
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffdadada),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: AutoSizeText(
                          "${reminder.tag1.toLowerCase()} ${reminder.tag2.toLowerCase()}.",
                          minFontSize: 13,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.questrial(
                              letterSpacing: 0.5,
                              fontSize: 25,
                              color: col.primaryTextColor,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                reminder.topics == null
                    ? Expanded(
                        child: Center(
                          child: AutoSizeText("no topics found.",
                              minFontSize: 17,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.questrial(
                                  letterSpacing: -1,
                                  fontSize: 20,
                                  color: col.primaryTextColor)),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 25, bottom: 15),
                        child: AutoSizeText(reminder.subtitle,
                            minFontSize: 17,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.questrial(
                                letterSpacing: 4.5,
                                fontSize: 33,
                                color: col.primaryTextColor,
                                fontWeight: FontWeight.w600)),
                      ),
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: ListView(
                        shrinkWrap: true,
                        children: wd.popUpTopics(reminder, context)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
