// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/algorithms/methods.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/currentSessionReminders.dart';
import 'package:chronos/data/model/hive_reminder.dart';
import 'package:chronos/data/repositories/hive_allReminders.dart';
import 'package:chronos/data/repositories/hive_weeks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../business_logic/blocs/change_color/change_color_bloc.dart';
import '../business_logic/blocs/change_reminder/change_reminders_bloc.dart';
import '../data/model/notificationID.dart';
import '../data/model/selectedDay.dart';
import '../data/model/hive_week.dart';
import '../presentation/pages/addReminder.dart';
import '../presentation/widgets/eachDay.dart';
import '../presentation/widgets/taskCard.dart';
import '../presentation/widgets/taskCardPopUp.dart';
import '../routes/popUpAnimateRoute.dart';

class WidgetDecider {
  String returnDate(DateTime date) {
    final dayFormat = DateFormat('d');
    final day = dayFormat.format(date);

    final suffixes = [
      "th",
      "st",
      "nd",
      "rd",
      "th",
      "th",
      "th",
      "th",
      "th",
      "th"
    ];
    final suffixIndex = int.parse(day) % 100;
    final suffix = (suffixIndex >= 11 && suffixIndex <= 13)
        ? 'th'
        : suffixes[suffixIndex % 10];

    return day + suffix;
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
        child: reminder.subtitle != ''
            ? AutoSizeText("${reminder.subtitle}:",
                minFontSize: 18,
                maxLines: 1,
                style: GoogleFonts.questrial(
                    color: col.primaryTextColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600))
            : AutoSizeText("Topics:",
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
                  overflow: TextOverflow.ellipsis,
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
      Weeks weekObject,
      int weekSelectedIndex,
      SelectedDay selectedDay,
      Reminders allReminders,
      BuildContext context,
      DateTime appStartDate,
      NumberOfReminders count,
      var db,
      NotificationID id) {
    Week currentWeek = weekObject.weeks[weekSelectedIndex];
    Methods func = Methods();
    List<Widget> taskList = [];
    if (currentWeek.reminders != null) {
      for (int j = 0; j < currentWeek.reminders.allReminders.length; j++) {
        if (checkTodayReminders(
            currentWeek.reminders.allReminders[j], selectedDay)) {
          taskList.add(Dismissible(
            key: Key(count.count.toString()),
            direction: DismissDirection.horizontal,
            dismissThresholds: {
              DismissDirection.endToStart: 0.75,
              DismissDirection.startToEnd: 0.75,
            },
            secondaryBackground: Container(
              margin: EdgeInsets.only(top: 30, bottom: 40),
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Icon(
                  Icons.close_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            background: Container(
              margin: EdgeInsets.only(top: 30, bottom: 40),
              color: Colors.green,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Icon(
                  Icons.done,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            onDismissed: (direction) {
              func.cancelNotifications(allReminders.allReminders[allReminders
                  .allReminders
                  .indexOf(currentWeek.reminders.allReminders[j])]);
              allReminders.allReminders
                  .remove(currentWeek.reminders.allReminders[j]);

              if (currentWeek.reminders.allReminders[j].deadlineType ==
                  'none') {
                func.deleteAllNone(allReminders, weekObject,
                    currentWeek.reminders.allReminders[j]);
              } else {
                weekObject.weeks[weekSelectedIndex].reminders.allReminders
                    .remove(currentWeek.reminders.allReminders[j]);
              }
              BlocProvider.of<ChangeRemindersBloc>(context)
                  .add(AddRemindersEvent());
              db.putAll({
                'reminders': allReminders,
              });

              if (direction == DismissDirection.endToStart) {
              } else if (direction == DismissDirection.startToEnd) {
                //Store completed tasks maybe?
              }
            },
            child: GestureDetector(
              onTap: () {
                Reminder obj = currentWeek.reminders.allReminders[j];
                Navigator.of(context).push(
                  HeroDialogRoute(
                    builder: (context) => Center(
                      child: PopUp(reminder: obj, selectedDay: selectedDay),
                    ),
                  ),
                );
              },
              onDoubleTap: () {
                Navigator.of(context)
                    .push((MaterialPageRoute(builder: (context) {
                  return AddReminderDescriptive(
                      selectedDay: selectedDay,
                      currentReminder: allReminders,
                      weekObject: weekObject,
                      initialDate: appStartDate,
                      reminderIndex: allReminders.allReminders
                          .indexOf(currentWeek.reminders.allReminders[j]),
                      weekSelectedIndex: weekSelectedIndex,
                      weekReminderIndex: j,
                      edit: true,
                      id: id);
                })));
              },
              child: TaskCard(
                  reminder: currentWeek.reminders.allReminders[j],
                  selectedDay: selectedDay),
            ),
          ));
        }
        count.count++;
      }
    }
    return taskList;
  }

  List<Widget> getColors(
      Reminder reminder, TagColors col, BuildContext context) {
    List<Widget> allColors = [];

    for (int i = 0; i < col.returnColorsList().length; i++) {
      allColors.add(Expanded(
        child: GestureDetector(
          onTap: () {
            reminder.color = col.returnColorsList()[i];
            BlocProvider.of<ChangeColorBloc>(context).add(ColorChangesEvent());
          },
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xffffffff), width: 2),
              color: col.returnColorsList()[i],
            ),
            child: col.returnColorsList()[i] == reminder.color
                ? Icon(Icons.done_rounded, size: 25)
                : Container(),
          ),
        ),
      ));
    }

    return allColors;
  }

  List<Widget> popUpTopics(Reminder reminder, BuildContext context) {
    List<Widget> popUpTopics = [];
    List<Widget> subTopics = [];

    if (reminder.topics != null) {
      for (int i = 0; i < reminder.topics!.length; i++) {
        subTopics = [];
        if (reminder.topics![i].subTopics!.isNotEmpty) {
          subTopics.add(Padding(
            padding: const EdgeInsets.only(left: 13, top: 7, right: 13),
            child: AutoSizeText(reminder.topics![i].description,
                minFontSize: 6,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.questrial(
                    letterSpacing: -1, fontSize: 24, color: Colors.black)),
          ));

          for (int j = 0; j < reminder.topics![i].subTopics!.length; j++) {
            subTopics.add(Padding(
                padding: EdgeInsets.only(
                    top: j == 0 ? 5 : 0,
                    bottom: j == reminder.topics!.length - 1 ? 25 : 10,
                    left: 7,
                    right: 7),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xffB793DA),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 15, left: 10, right: 10),
                    child: AutoSizeText(
                        reminder.topics![i].subTopics![j].description,
                        minFontSize: 4,
                        softWrap: true,
                        style: GoogleFonts.questrial(
                            fontSize: 14, color: Colors.black)),
                  ),
                )));
          }
        }
        reminder.topics![i].subTopics!.isEmpty
            ? popUpTopics.add(Padding(
                padding: EdgeInsets.only(
                    left: 7,
                    right: 7,
                    bottom: i == reminder.topics!.length - 1 &&
                            reminder.topics![i].subTopics!.isEmpty
                        ? 35
                        : 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                    child: AutoSizeText(reminder.topics![i].description,
                        minFontSize: 6,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.questrial(
                            letterSpacing: -1,
                            fontSize: 24,
                            color: Colors.black)),
                  ),
                )))
            : popUpTopics.add(
                Padding(
                  padding: EdgeInsets.only(
                      left: 7,
                      right: 7,
                      bottom: i == reminder.topics!.length - 1 &&
                              reminder.topics![i].subTopics!.isEmpty
                          ? 35
                          : 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: subTopics,
                    ),
                  ),
                ),
              );
      }
    }

    return popUpTopics;
  }
}
