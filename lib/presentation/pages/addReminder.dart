// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_conditional_assignment

import 'package:chronos/algorithms/methods.dart';
import 'package:chronos/algorithms/timeCalc.dart';
import 'package:chronos/algorithms/widgetDecider.dart';
import 'package:chronos/business_logic/blocs/change_reminder/change_reminders_bloc.dart';
import 'package:chronos/data/model/hive_topic.dart';
import 'package:chronos/data/repositories/hive_weeks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../business_logic/blocs/change_color/change_color_bloc.dart';
import '../../business_logic/blocs/change_topics/change_topics_bloc.dart';
import '../../business_logic/blocs/date_selected/date_selected_bloc.dart';
import '../../business_logic/blocs/toggle_buttons/toggle_buttons_bloc.dart';
import '../../constants/colors.dart';
import '../../data/model/hive_reminder.dart';
import '../../data/model/selectedDay.dart';
import '../../data/repositories/hive_allReminders.dart';
import '../widgets/inputField.dart';

class AddReminderDescriptive extends StatefulWidget {
  AddReminderDescriptive(
      {super.key,
      required this.currentReminder,
      required this.selectedDay,
      required this.weekObject,
      required this.initialDate,
      this.reminderIndex = -1,
      this.weekSelectedIndex = -1,
      this.weekReminderIndex = -1});

  Reminders currentReminder;
  SelectedDay selectedDay;
  Weeks weekObject;
  DateTime initialDate;
  int reminderIndex;
  int weekSelectedIndex;
  int weekReminderIndex;

  @override
  State<AddReminderDescriptive> createState() => _AddReminderDescriptiveState();
}

class _AddReminderDescriptiveState extends State<AddReminderDescriptive> {
  @override
  void initState() {
    super.initState();
    if (widget.reminderIndex != -1) {
      editTaskCard = true;
      tag1Controller.text =
          widget.currentReminder.allReminders[widget.reminderIndex].tag1;
      tag2Controller.text =
          widget.currentReminder.allReminders[widget.reminderIndex].tag2;
      // if(widget.currentReminder.allReminders[widget.reminderIndex].topics != null){
      //   for(int i = 0; i < widget.currentReminder.allReminders[widget.reminderIndex].topics!.length; i++){
      //     topicsController[i].text = widget.currentReminder.allReminders[widget.reminderIndex].topics![i].description;
      //   }
      // }
    }
  }

  bool value = false;
  TextEditingController tag1Controller = TextEditingController();
  TextEditingController tag2Controller = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  List<TextEditingController> topicsController = [TextEditingController()];
  Map<int, List<TextEditingController>> subtopicsController = {0: []};
  TagColors col = TagColors();
  Methods func = Methods();
  WidgetDecider wd = WidgetDecider();
  TimeNow time = TimeNow();
  bool editTaskCard = false;
  var db = Hive.box('Database');

  int intDeadlineType = 0;
  final List<bool> isSelected = [true, false, false, false];

  List<Widget> getTopics(BuildContext context) {
    List<Widget> topics = [];

    for (int i = 0; i < topicsController.length; i++) {
      if (i == 0) {
        topics.add(Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InputField(
                    controller: topicsController[0],
                    hintText: 'Add text...',
                    left: 40,
                    right: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                    onPressed: () {
                      subtopicsController[0]!.add(TextEditingController());
                      BlocProvider.of<ChangeTopicsBloc>(context)
                          .add(TopicsChangedEvent());
                    },
                    icon:
                        Icon(Icons.arrow_drop_down_circle_outlined, size: 25)),
              )
            ],
          ),
        ));
      } else {
        topics.add(Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InputField(
                    controller: topicsController[i],
                    hintText: 'Add text...',
                    left: 40,
                    right: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                    onPressed: () {
                      if (subtopicsController[i] == null) {
                        subtopicsController[i] = [];
                      }
                      subtopicsController[i]!.add(TextEditingController());
                      BlocProvider.of<ChangeTopicsBloc>(context)
                          .add(TopicsChangedEvent());
                    },
                    icon:
                        Icon(Icons.arrow_drop_down_circle_outlined, size: 25)),
              )
            ],
          ),
        ));
      }

      if (subtopicsController[i] != null) {
        for (int j = 0; j < subtopicsController[i]!.length; j++) {
          topics.add(Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 5),
                  child: IconButton(
                      onPressed: () {
                        subtopicsController[i]!.removeAt(j);
                        BlocProvider.of<ChangeTopicsBloc>(context)
                            .add(TopicsChangedEvent());
                      },
                      icon: Icon(Icons.delete, size: 25)),
                ),
                Expanded(
                  child: InputField(
                      controller: subtopicsController[i]![j],
                      hintText: '/subtopic',
                      left: 5,
                      right: 15),
                ),
              ],
            ),
          ));
        }
      }
    }

    topicsController.length > 1
        ? topics.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: IconButton(
                    onPressed: () {
                      topicsController.add(TextEditingController());
                      BlocProvider.of<ChangeTopicsBloc>(context)
                          .add(TopicsChangedEvent());
                    },
                    icon: Icon(Icons.add_circle_outline_rounded, size: 28)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, right: 10),
                child: IconButton(
                    onPressed: () {
                      topicsController.removeLast();
                      subtopicsController[topicsController.length] = [];
                      BlocProvider.of<ChangeTopicsBloc>(context)
                          .add(TopicsChangedEvent());
                    },
                    icon: Icon(Icons.delete, size: 28)),
              ),
            ],
          ))
        : topics.add(Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconButton(
                onPressed: () {
                  topicsController.add(TextEditingController());
                  BlocProvider.of<ChangeTopicsBloc>(context)
                      .add(TopicsChangedEvent());
                },
                icon: Icon(Icons.add_circle_outline_rounded, size: 28)),
          ));

    return topics;
  }

  void changeToggleButtons(int index) {
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      isSelected[buttonIndex] = buttonIndex == index;

      if (buttonIndex == 0 && isSelected[buttonIndex] == true) {
        widget
            .currentReminder
            .allReminders[widget.currentReminder.allReminders.length - 1]
            .deadlineType = "none";
      } else if (buttonIndex == 1 && isSelected[buttonIndex] == true) {
        widget
            .currentReminder
            .allReminders[widget.currentReminder.allReminders.length - 1]
            .deadlineType = "thisWeek";
      } else if (buttonIndex == 2 && isSelected[buttonIndex] == true) {
        widget
            .currentReminder
            .allReminders[widget.currentReminder.allReminders.length - 1]
            .deadlineType = "on";
      } else if (buttonIndex == 3 && isSelected[buttonIndex] == true) {
        widget
            .currentReminder
            .allReminders[widget.currentReminder.allReminders.length - 1]
            .deadlineType = "before";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeColorBloc, ChangeColorState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xff1f1f1f),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 75,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 31, color: Colors.white),
              onPressed: () {
                if (widget.reminderIndex == -1) {
                  widget.currentReminder.allReminders
                      .removeAt(widget.currentReminder.allReminders.length - 1);
                }
                Navigator.of(context).pop();
              },
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment(-0.15, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    value == false
                        ? AutoSizeText("Description",
                            minFontSize: 10,
                            maxLines: 1,
                            style: GoogleFonts.questrial(
                                letterSpacing: 0.5,
                                fontSize: 15,
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w600))
                        : AutoSizeText("Description",
                            minFontSize: 10,
                            maxLines: 1,
                            style: GoogleFonts.questrial(
                                letterSpacing: 0.5,
                                fontSize: 15,
                                color: Color(0xffffffff))),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: FlutterSwitch(
                          value: value,
                          width: 70,
                          activeColor: Color(0xff1f1f1f),
                          inactiveColor: Color(0xffffffff),
                          activeToggleColor: Color(0xffffffff),
                          inactiveToggleColor: Color(0xff1f1f1f),
                          activeToggleBorder:
                              Border.all(color: Color(0xff1f1f1f)),
                          switchBorder: Border.all(color: Color(0xffffffff)),
                          onToggle: (val) {
                            setState(() {
                              value = !val;
                            });
                          }),
                    ),
                    value == false
                        ? AutoSizeText("Tags",
                            minFontSize: 10,
                            maxLines: 1,
                            style: GoogleFonts.questrial(
                                letterSpacing: 0.5,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 15,
                                color: Color(0xffffffff)))
                        : AutoSizeText("Tags",
                            minFontSize: 10,
                            maxLines: 1,
                            style: GoogleFonts.questrial(
                                letterSpacing: 0.5,
                                fontSize: 15,
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.delete_rounded,
                      size: 31,
                      color: widget.reminderIndex == -1
                          ? Colors.grey
                          : Colors.white),
                  onPressed: () {
                    if (widget.reminderIndex != -1) {
                      widget.currentReminder.allReminders
                          .removeAt(widget.reminderIndex);
                      widget.weekObject.weeks[widget.weekSelectedIndex]
                          .reminders.allReminders
                          .removeAt(widget.weekReminderIndex);
                      BlocProvider.of<ChangeRemindersBloc>(context)
                          .add(AddRemindersEvent());
                      db.putAll({
                        'reminders': widget.currentReminder,
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget
                              .currentReminder
                              .allReminders[
                                  widget.currentReminder.allReminders.length -
                                      1]
                              .color,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                      child: SingleChildScrollView(child:
                          BlocBuilder<ToggleButtonsBloc, ToggleButtonsState>(
                        builder: (context, state) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 40, left: 17, bottom: 10),
                                      child: AutoSizeText(
                                        "Title",
                                        style: GoogleFonts.questrial(
                                            fontSize: 27,
                                            color: Color(0xff1f1f1f)),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, right: 5, bottom: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Reminder obj = widget.currentReminder
                                              .allReminders[widget
                                                  .currentReminder
                                                  .allReminders
                                                  .length -
                                              1];
                                          List<Topic>? subtopics = [];
                                          obj.tag1 = tag1Controller.text;
                                          obj.tag2 = tag2Controller.text;
                                          obj.subtitle =
                                              subtitleController.text;
                                          tag1Controller.clear();
                                          tag2Controller.clear();
                                          subtitleController.clear();
                                          for (int i = 0;
                                              i < topicsController.length;
                                              i++) {
                                            if (obj.topics == null) {
                                              obj.topics = [];
                                            }
                                            if (subtopicsController[i] !=
                                                null) {
                                              for (int j = 0;
                                                  j <
                                                      subtopicsController[i]!
                                                          .length;
                                                  j++) {
                                                subtopics.add(Topic(
                                                    description:
                                                        subtopicsController[i]![
                                                                j]
                                                            .text));
                                              }
                                            }
                                            obj.topics!.add(Topic(
                                                description:
                                                    topicsController[i].text,
                                                subTopics: subtopics));
                                            topicsController[i].clear();
                                          }
                                          if (obj.deadlineType == 'none') {
                                            for (int i = 0;
                                                i <
                                                    widget.weekObject.weeks
                                                        .length;
                                                i++) {
                                              widget.weekObject.weeks[i]
                                                  .reminders.allReminders
                                                  .add(obj);
                                            }
                                          } else {
                                            widget
                                                .weekObject
                                                .weeks[func.calculateWeekIndex(
                                                        obj.deadline,
                                                        widget.initialDate) -
                                                    1]
                                                .reminders
                                                .allReminders
                                                .add(obj);
                                          }
                                          BlocProvider.of<ChangeRemindersBloc>(
                                                  context)
                                              .add(AddRemindersEvent());
                                          db.putAll({
                                            'reminders': widget.currentReminder,
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                            width: 65,
                                            height: 65,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Color(0xffffffff),
                                                  width: 2),
                                              color: Color(0xffffffff),
                                            ),
                                            child: Icon(Icons.done_rounded,
                                                size: 45)),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: InputField(
                                      controller: tag1Controller,
                                      hintText: 'Tag 1',
                                      left: 20,
                                      right: 20),
                                ),
                                InputField(
                                    controller: tag2Controller,
                                    hintText: 'Tag 2',
                                    left: 20,
                                    right: 20),
                                Padding(
                                  padding: EdgeInsets.only(top: 60),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 17, bottom: 10),
                                        child: Text(
                                          "/subtitle:",
                                          style: GoogleFonts.questrial(
                                              fontSize: 27,
                                              color: Color(0xff1f1f1f)),
                                        ),
                                      ),
                                      Expanded(
                                        child: InputField(
                                            controller: subtitleController,
                                            hintText: '/subtitle',
                                            left: 10,
                                            right: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                BlocBuilder<ChangeTopicsBloc,
                                    ChangeTopicsState>(
                                  builder: (context, state) {
                                    return Column(children: getTopics(context));
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40, left: 17, bottom: 10),
                                  child: AutoSizeText(
                                    "Color Select",
                                    style: GoogleFonts.questrial(
                                        fontSize: 27, color: Color(0xff1f1f1f)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                      children: wd.getColors(
                                          widget.currentReminder.allReminders[
                                              widget.currentReminder
                                                      .allReminders.length -
                                                  1],
                                          col,
                                          context)),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 60),
                                    child: ToggleButtons(
                                      isSelected: isSelected,
                                      selectedColor: Color(0xffffffff),
                                      fillColor: Color(0xff1f1f1f),
                                      onPressed: (int index) {
                                        changeToggleButtons(index);
                                        BlocProvider.of<ToggleButtonsBloc>(
                                                context)
                                            .add(ButtonToggleEvent());
                                      },
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70) /
                                              4,
                                          child: Center(
                                            child: Text(
                                              "None",
                                              style: GoogleFonts.questrial(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70) /
                                              4,
                                          child: Center(
                                            child: Text(
                                              "In Week",
                                              style: GoogleFonts.questrial(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70) /
                                              4,
                                          child: Center(
                                            child: Text(
                                              "On",
                                              style: GoogleFonts.questrial(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70) /
                                              4,
                                          child: Center(
                                            child: Text(
                                              "Before",
                                              style: GoogleFonts.questrial(
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                func.checkOnOrBefore(widget.currentReminder)
                                    ? BlocBuilder<DateSelectedBloc,
                                        DateSelectedState>(
                                        builder: (context, state) {
                                          return Padding(
                                              padding: EdgeInsets.only(
                                                  top: 25,
                                                  left: 60,
                                                  right: 60,
                                                  bottom: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  time.selectDate(
                                                      context,
                                                      widget.initialDate,
                                                      widget.currentReminder,
                                                      widget.selectedDay);
                                                },
                                                child: AspectRatio(
                                                  aspectRatio: 5,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff1f1f1f),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5,
                                                                  right: 5),
                                                          child: AutoSizeText(
                                                            func.getSelectedDate(
                                                                widget
                                                                    .selectedDay
                                                                    .selectedDay),
                                                            maxLines: 1,
                                                            style: GoogleFonts
                                                                .questrial(
                                                                    fontSize:
                                                                        20,
                                                                    color: Color(
                                                                        0xffffffff)),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ));
                                        },
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 20))
                              ]);
                        },
                      ))),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
