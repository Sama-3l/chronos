// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/reminder.dart';
import 'package:chronos/data/repositories/allReminders.dart';
import 'package:chronos/data/repositories/weeks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/model/selectedDay.dart';
import '../data/model/week.dart';
import '../presentation/widgets/eachDay.dart';
import '../presentation/widgets/taskCard.dart';

class WidgetDecider {
  String returnDate(DateTime date) {
    if (date.day % 10 == 3) {
      return "3rd";
    } else if (date.day % 10 == 2) {
      return "2nd";
    } else if (date.day % 10 == 1) {
      return "1st";
    } else {
      return "${date.day}th";
    }
  }

  List<Widget> decideDeadline(Reminder reminder) {
    List<Widget> deadline = [];
    PrimaryColors col = PrimaryColors();

    if (reminder.deadlineType == "on") {
      deadline.add(AutoSizeText("On",
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));

      deadline.add(Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(width: 2, height: 35, color: col.primaryTextColor),
      ));

      deadline.add(AutoSizeText(returnDate(reminder.deadline),
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));
    } else if (reminder.deadlineType == "before") {
      deadline.add(AutoSizeText("Before",
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));

      deadline.add(Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(width: 2, height: 35, color: col.primaryTextColor),
      ));

      deadline.add(AutoSizeText(returnDate(reminder.deadline),
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));
    } else if (reminder.deadlineType == "thisWeek") {
      deadline.add(AutoSizeText("This",
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));

      deadline.add(Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(width: 2, height: 35, color: col.primaryTextColor),
      ));

      deadline.add(AutoSizeText("Week",
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));
    } else {
      deadline.add(AutoSizeText("On",
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));

      deadline.add(Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(width: 2, height: 35, color: col.primaryTextColor),
      ));

      deadline.add(AutoSizeText("Agenda",
          minFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.questrial(
              letterSpacing: 0.5,
              fontSize: 25,
              color: col.primaryTextColor,
              fontWeight: FontWeight.w500)));
    }
    return deadline;
  }

  List<Widget> returnSubtitleRow(Reminder reminder) {
    PrimaryColors col = PrimaryColors();
    List<Widget> subtitleRowChildren = [
      Expanded(
        child: AutoSizeText("${reminder.subtitle}:",
            minFontSize: 18,
            maxLines: 1,
            style: GoogleFonts.questrial(
                color: col.primaryTextColor,
                fontSize: 25,
                fontWeight: FontWeight.w600)),
      ),
    ];

    if (reminder.topics != null) {
      for (int i = 0; i < reminder.topics!.length; i++) {
        if (i <= 2) {
          subtitleRowChildren.add(Expanded(
            child: Center(
              child: AutoSizeText(reminder.topics![i].description,
                  minFontSize: 11,
                  maxLines: 1,
                  style: GoogleFonts.questrial(
                      color: col.primaryTextColor.withOpacity(0.5),
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
          ));
        } else {
          // subtitleRowChildren.add(AutoSizeText("...",
          //     minFontSize: 11,
          //     maxLines: 1,
          //     style: GoogleFonts.questrial(
          //         color: col.primaryTextColor.withOpacity(0.5),
          //         fontSize: 18,
          //         fontWeight: FontWeight.w500)));
          break;
        }
      }
    } else {
      for (int i = 0; i < 3; i++) {
        subtitleRowChildren.add(Expanded(
          child: Center(
            child: AutoSizeText('-',
                minFontSize: 11,
                maxLines: 1,
                style: GoogleFonts.questrial(
                    color: col.primaryTextColor.withOpacity(0.5),
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ),
        ));
      }
    }

    return subtitleRowChildren;
  }

  bool checkTodayReminders(Reminder reminder, SelectedDay selectedDay) {
    if (reminder.deadlineType == "on" &&
        (reminder.deadline.day == selectedDay.selectedDay.day)) {
      return true;
    } else if (reminder.deadlineType == "before" &&
            reminder.deadline.isAfter(selectedDay.selectedDay) ||
        reminder.deadline.day == selectedDay.selectedDay.day) {
      return true;
    } else if (reminder.deadlineType == "thisWeek") {
      return true;
    } else if (reminder.deadlineType == "none") {
      return true;
    } else {
      return false;
    }
  }

  List<Widget> currentDayTasks(
      Weeks weekObject, int weekSelectedIndex, SelectedDay selectedDay) {
    Week currentWeek = weekObject.weeks[weekSelectedIndex];
    List<Widget> taskList = [];
    if (currentWeek.reminders != null) {
      for (int j = 0; j < currentWeek.reminders!.allReminders.length; j++) {
        if (checkTodayReminders(
            currentWeek.reminders!.allReminders[j], selectedDay)) {
          taskList.add(TaskCard(
              reminder: currentWeek.reminders!.allReminders[j],
              selectedDay: selectedDay));
        }
      }
    }
    return taskList;
  }
}
