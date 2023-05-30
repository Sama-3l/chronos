// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/hive_reminder.dart';
import 'package:chronos/data/repositories/hive_allReminders.dart';
import 'package:chronos/data/repositories/hive_weeks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../business_logic/blocs/change_reminder/change_reminders_bloc.dart';
import '../data/model/hive_topic.dart';
import '../data/model/notificationID.dart';
import '../data/model/selectedDay.dart';
import '../data/model/hive_week.dart';
import '../presentation/widgets/eachDay.dart';
import '../presentation/widgets/taskCard.dart';

import '../data/services/notification.dart';

class Methods {
  NotificationService notify = NotificationService();
  List<Widget> selectedWeek(SelectedDay? setDay, Weeks weekObject,
      int weekSelectedIndex, SelectedDay selectedDay) {
    List<Widget> weekDays = [];
    DateTime date = weekObject.weeks[weekSelectedIndex].monday;
    DateTime end = weekObject.weeks[weekSelectedIndex].sunday;
    bool selected = false;
    while (date.difference(end).inDays <= 0) {
      if (DateUtils.isSameDay(date, setDay!.selectedDay)) {
        selected = true;
      } else {
        selected = false;
      }

      if (date.weekday == 1) {
        weekDays.add(Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Day(
              date: date.day.toString().padLeft(2, '0'),
              index: date.weekday - 1,
              selected: selected,
              dateTime: date,
              selectedDay: selectedDay),
        ));
      } else if (date.weekday == 7) {
        weekDays.add(Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Day(
              date: date.day.toString().padLeft(2, '0'),
              index: date.weekday - 1,
              selected: selected,
              dateTime: date,
              selectedDay: selectedDay),
        ));
      } else {
        weekDays.add(Day(
          date: date.day.toString().padLeft(2, '0'),
          index: date.weekday - 1,
          selected: selected,
          dateTime: date,
          selectedDay: selectedDay,
        ));
      }
      if (date.weekday != 7) weekDays.add(Spacer());
      date = date.add(const Duration(days: 1));
    }

    return weekDays;
  }

  String checkTodayStatus(
      SelectedDay selectedDay, DateTime todayDateTimeObject) {
    if (selectedDay.selectedDay.day == todayDateTimeObject.day) {
      return "Today";
    } else {
      return "Selected";
    }
  }

  int calculateWeekIndex(DateTime? date, DateTime initial) {
    while (date!.weekday != 7) {
      date = date.add(Duration(days: 1));
    }
    if (date.difference(initial).inDays % 7 == 0) {
      return (date.difference(initial).inDays / 7).ceil() + 1;
    } else {
      return (date.difference(initial).inDays / 7).ceil();
    }
    // if (date.difference(initial).inDays == -7) {
    //   return 0;
    // } else {
    //   return ((date.difference(initial).inDays) / 7).ceil();
    // }
  }

  void initializeWeeklyReminders(Reminders allReminders, Weeks weekObject) {
    for (int i = 0; i < allReminders.allReminders.length; i++) {
      if (allReminders.allReminders[i].deadlineType == "none") {
        for (int j = 0; j < weekObject.weeks.length; j++) {
          if (weekObject.weeks[j].reminders == null) {
            weekObject.weeks[j].reminders =
                Reminders(allReminders: [allReminders.allReminders[i]]);
          } else {
            weekObject.weeks[j].reminders.allReminders
                .add(allReminders.allReminders[i]);
          }
        }
      } else if (weekObject
              .weeks[calculateWeekIndex(allReminders.allReminders[i].deadline,
                      weekObject.weeks[0].sunday) -
                  1]
              .reminders ==
          null) {
        weekObject
                .weeks[calculateWeekIndex(allReminders.allReminders[i].deadline,
                        weekObject.weeks[0].sunday) -
                    1]
                .reminders =
            Reminders(allReminders: [allReminders.allReminders[i]]);
      } else {
        weekObject
            .weeks[calculateWeekIndex(allReminders.allReminders[i].deadline,
                    weekObject.weeks[0].sunday) -
                1]
            .reminders
            .allReminders
            .add(allReminders.allReminders[i]);
      }
    }
  }

  String getSelectedDate(DateTime selectedDay) {
    final weekday = DateFormat('EEEE').format(selectedDay);
    final day = DateFormat('d').format(selectedDay);
    final month = DateFormat('MMMM').format(selectedDay);
    final year = DateFormat('y').format(selectedDay);

    return '$weekday $day, $month $year';
  }

  bool checkOnOrBefore(Reminders currentReminder) {
    return currentReminder.allReminders[currentReminder.allReminders.length - 1]
                .deadlineType ==
            "on" ||
        currentReminder.allReminders[currentReminder.allReminders.length - 1]
                .deadlineType ==
            "before" ||
        currentReminder.allReminders[currentReminder.allReminders.length - 1]
                .deadlineType ==
            "thisWeek";
  }

  bool checkBeforeSubmission(
      TextEditingController tag1, TextEditingController tag2) {
    return tag1.text.trim().isNotEmpty && tag2.text.trim().isNotEmpty;
  }

  void submit(
      Reminders allReminders,
      int reminderIndex,
      bool submitReady,
      TextEditingController tag1Controller,
      TextEditingController tag2Controller,
      TextEditingController subtitleController,
      List<TextEditingController> topicsController,
      Map<int, List<TextEditingController>> subtopicsController,
      bool edit,
      Weeks weekObject,
      DateTime initialDate,
      BuildContext context,
      var db,
      int originalWeekIndex,
      NotificationID id) {
    Reminder obj = allReminders.allReminders[reminderIndex];
    if (submitReady) {
      List<Topic>? subtopics = [];
      obj.tag1 = tag1Controller.text;
      obj.tag2 = tag2Controller.text;
      if (subtitleController.text != '') {
        obj.subtitle = subtitleController.text;
      }

      tag1Controller.clear();
      tag2Controller.clear();
      subtitleController.clear();
      for (int i = 0; i < topicsController.length; i++) {
        subtopics = [];
        obj.topics ??= [];
        if (subtopicsController[i] != null) {
          for (int j = 0; j < subtopicsController[i]!.length; j++) {
            subtopics.add(Topic(description: subtopicsController[i]![j].text));
          }
        }

        obj.topics!.add(
            Topic(description: topicsController[i].text, subTopics: subtopics));
        topicsController[i].clear();
      }
      if (!edit) {
        if (obj.deadlineType == 'none') {
          for (int i = 0; i < weekObject.weeks.length; i++) {
            weekObject.weeks[i].reminders.allReminders.add(obj);
          }
        } else {
          weekObject.weeks[calculateWeekIndex(obj.deadline, initialDate) - 1]
              .reminders.allReminders
              .add(obj);
        }
      } else {
        weekObject.weeks[originalWeekIndex].reminders.allReminders.remove(obj);
        if (obj.deadlineType == 'none') {
          for (int i = 0; i < weekObject.weeks.length; i++) {
            weekObject.weeks[i].reminders.allReminders.add(obj);
          }
        } else {}
        weekObject.weeks[originalWeekIndex].reminders.allReminders.remove(obj);
        weekObject.weeks[calculateWeekIndex(obj.deadline, initialDate) - 1]
            .reminders.allReminders
            .add(obj);
      }
      setNotifications(obj, initialDate, weekObject, id, edit);
      BlocProvider.of<ChangeRemindersBloc>(context).add(AddRemindersEvent());
      db.putAll(
          {'reminders': allReminders, 'notifications': id.notificationID});
    }
  }

  void deleteAllNone(
      Reminders allReminders, Weeks weekObject, Reminder? reminderToRemove) {
    for (int i = 0; i < weekObject.weeks.length; i++) {
      weekObject.weeks[i].reminders.allReminders.remove(reminderToRemove);
    }
  }

  void setNotifications(Reminder reminder, DateTime initial, Weeks weekObject,
      NotificationID id, bool edit) {
    if (edit) {
      reminder.notificationIDs = null;
    }
    List<int> time_notify = [6, 12, 18, 22];
    DateTime currentDateTime = DateTime.now();
    DateTime currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    bool deadlineInCurrentWeek = calculateWeekIndex(currentDate, initial) ==
        calculateWeekIndex(reminder.deadline, initial);

    if (reminder.deadlineType == 'thisWeek') {
      if (deadlineInCurrentWeek) {
        DateTime date = currentDate;

        while (date
                .difference(weekObject
                    .weeks[calculateWeekIndex(reminder.deadline, initial) - 1]
                    .sunday)
                .inDays <=
            0) {
          if (currentDate.day == date.day) {
            //Current Time is not less than 10 pm
            for (int i = 0; i < time_notify.length; i++) {
              if (currentDateTime.hour < time_notify[i]) {
                normalTimesefore10PM(reminder, id, date, time_notify[i]);
              }
            }
            //Current time is more than 10 pm
            if (currentDateTime.hour > 22) {
              afterTime10PM(reminder, id, currentDateTime);
            }
          } else {
            for (int i = 0; i < time_notify.length; i++) {
              normalTimesefore10PM(reminder, id, date, time_notify[i]);
            }
          }
          date = date.add(Duration(days: 1));
        }
      } else {
        DateTime date = weekObject
            .weeks[calculateWeekIndex(reminder.deadline, initial) - 1].monday;
        DateTime end = weekObject
            .weeks[calculateWeekIndex(reminder.deadline, initial) - 1].sunday;
        while (date.difference(end).inDays <= 0) {
          for (int i = 0; i < time_notify.length; i++) {
            normalTimesefore10PM(reminder, id, date, time_notify[i]);
          }
          date = date.add(Duration(days: 1));
        }
      }
    } else if (reminder.deadlineType == 'on') {
      if (currentDate.day == reminder.deadline.day) {
        //Current Time is not less than 10 pm
        for (int i = 0; i < time_notify.length; i++) {
          if (currentDateTime.hour < time_notify[i]) {
            normalTimesefore10PM(
                reminder, id, reminder.deadline, time_notify[i]);
          }
        }
        //Current time is more than 10 pm
        if (currentDateTime.hour > 22) {
          afterTime10PM(reminder, id, currentDateTime);
        }
      } else {
        for (int i = 0; i < time_notify.length; i++) {
          normalTimesefore10PM(reminder, id, reminder.deadline, time_notify[i]);
        }
      }
    } else if (reminder.deadlineType == 'before') {
      if (deadlineInCurrentWeek) {
        DateTime date = currentDate;

        while (date.difference(reminder.deadline).inDays <= 0) {
          if (currentDate.day == date.day) {
            //Current Time is not less than 10 pm
            for (int i = 0; i < time_notify.length; i++) {
              if (currentDateTime.hour < time_notify[i]) {
                normalTimesefore10PM(reminder, id, date, time_notify[i]);
              }
            }
            //Current time is more than 10 pm
            if (currentDateTime.hour > 22) {
              afterTime10PM(reminder, id, currentDateTime);
            }
          } else {
            for (int i = 0; i < time_notify.length; i++) {
              normalTimesefore10PM(reminder, id, date, time_notify[i]);
            }
          }
          date = date.add(Duration(days: 1));
        }
      } else {
        DateTime date = weekObject
            .weeks[calculateWeekIndex(reminder.deadline, initial) - 1].monday;

        while (date.difference(reminder.deadline).inDays <= 0) {
          if (currentDate.day == date.day) {
            //Current Time is not less than 10 pm
            for (int i = 0; i < time_notify.length; i++) {
              if (currentDateTime.hour < time_notify[i]) {
                normalTimesefore10PM(reminder, id, date, time_notify[i]);
              }
            }
            //Current time is more than 10 pm
            if (currentDateTime.hour > 22) {
              afterTime10PM(reminder, id, currentDateTime);
            }
          } else {
            for (int i = 0; i < time_notify.length; i++) {
              normalTimesefore10PM(reminder, id, date, time_notify[i]);
            }
          }
          date = date.add(Duration(days: 1));
        }
      }
    }
  }

  void normalTimesefore10PM(
      Reminder reminder, NotificationID id, DateTime date, int hour) {
    notify.initializeNotification();

    reminder.notificationIDs ??= [];
    reminder.notificationIDs!.add(id.notificationID!);
    DateTime dateWithTime = DateTime(date.year, date.month, date.day, hour);
    notify.showNotification(
        "Today's Reminders",
        "${reminder.tag1} + ${reminder.tag2}",
        reminder.deadline,
        id.notificationID!);
    id.notificationID = id.notificationID! + 1;
  }

  void afterTime10PM(
      Reminder reminder, NotificationID id, DateTime currentDateTime) {
    notify.initializeNotification();
    reminder.notificationIDs ??= [];
    reminder.notificationIDs!.add(id.notificationID!);
    DateTime dateWithTime = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day, 22);
    notify.showNotification(
        "Today's Reminders",
        "${reminder.tag1} + ${reminder.tag2}",
        reminder.deadline,
        id.notificationID!);
    id.notificationID = id.notificationID! + 1;
  }

  void cancelNotifications(Reminder reminder) {
    if (reminder.deadlineType != "none") {
      for (int i = 0; i < reminder.notificationIDs!.length; i++) {
        notify.cancelNotifications(reminder.notificationIDs![i]);
      }
    }
  }
}
