// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_conditional_assignment

import 'package:chronos/algorithms/methods.dart';
import 'package:chronos/algorithms/timeCalc.dart';
import 'package:chronos/algorithms/widgetDecider.dart';
import 'package:chronos/business_logic/blocs/change_reminder/change_reminders_bloc.dart';
import 'package:chronos/business_logic/blocs/fix_error/fix_error_bloc.dart';
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
import '../../data/model/notificationID.dart';
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
      this.weekReminderIndex = -1,
      this.edit = false,
      required this.id});

  Reminders currentReminder;
  SelectedDay selectedDay;
  Weeks weekObject;
  DateTime initialDate;
  int reminderIndex;
  int weekSelectedIndex;
  int weekReminderIndex;
  bool edit;
  NotificationID id;

  @override
  State<AddReminderDescriptive> createState() => _AddReminderDescriptiveState();
}

class _AddReminderDescriptiveState extends State<AddReminderDescriptive> {
  @override
  void initState() {
    super.initState();
    tag1Controller.addListener(() {
      _onTextChanged(tag1Controller);
      if (submitReady !=
          func.checkBeforeSubmission(tag1Controller, tag2Controller)) {
        submitReady =
            func.checkBeforeSubmission(tag1Controller, tag2Controller);
        BlocProvider.of<FixErrorBloc>(context).add(ErrorChangeEvent());
      }
    });
    tag2Controller.addListener(() {
      _onTextChanged(tag2Controller);
      if (submitReady !=
          func.checkBeforeSubmission(tag1Controller, tag2Controller)) {
        submitReady =
            func.checkBeforeSubmission(tag1Controller, tag2Controller);
        BlocProvider.of<FixErrorBloc>(context).add(ErrorChangeEvent());
      }
    });
    subtitleController.addListener(() {
      _onTextChanged(subtitleController);
    });

    if (widget.edit) {
      Reminder obj = widget.currentReminder.allReminders[widget.reminderIndex];
      originalDeadlineType = obj.deadlineType;
      editTaskCard = true;
      tag1Controller.text = obj.tag1;
      tag2Controller.text = obj.tag2;
      late int index;
      if (obj.deadlineType == 'none') {
        index = 0;
      } else if (obj.deadlineType == 'thisWeek') {
        index = 1;
      } else if (obj.deadlineType == 'on') {
        index = 2;
      } else {
        index = 3;
      }

      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }

      if (widget.currentReminder.allReminders[widget.reminderIndex].topics !=
          null) {
        for (int i = 0;
            i <
                widget.currentReminder.allReminders[widget.reminderIndex]
                    .topics!.length;
            i++) {
          if (topicsController.length - 1 != i) {
            topicsController.add(TextEditingController());
          }
          topicsController[i].text = widget.currentReminder
              .allReminders[widget.reminderIndex].topics![i].description;
          if (widget.currentReminder.allReminders[widget.reminderIndex]
              .topics![i].subTopics!.isNotEmpty) {
            for (int j = 0;
                j <
                    widget.currentReminder.allReminders[widget.reminderIndex]
                        .topics![i].subTopics!.length;
                j++) {
              if (subtopicsController[i] == null) {
                subtopicsController.addAll({i: []});
              }
              subtopicsController[i]!.add(TextEditingController());
              subtopicsController[i]![j].text = widget
                  .currentReminder
                  .allReminders[widget.reminderIndex]
                  .topics![i]
                  .subTopics![j]
                  .description;
            }
          }
        }
      }
    }
  }

  bool value = false;
  ScrollController controller = ScrollController();
  TextEditingController tag1Controller = TextEditingController();
  TextEditingController tag2Controller = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  List<TextEditingController> topicsController = [];
  Map<int, List<TextEditingController>> subtopicsController = {};
  TagColors col = TagColors();
  Methods func = Methods();
  WidgetDecider wd = WidgetDecider();
  TimeNow time = TimeNow();
  bool editTaskCard = false;
  var db = Hive.box('Database');
  bool submitReady = false;
  String? originalDeadlineType;

  int intDeadlineType = 0;
  final List<bool> isSelected = [true, false, false, false];

  void _onTextChanged(TextEditingController _textEditingController) {
    final text = _textEditingController.text;
    final sanitizedText = text.replaceAll(' ', ''); // Remove spaces

    if (text != sanitizedText) {
      final cursorPosition = _textEditingController.selection.baseOffset -
          (text.length - sanitizedText.length);
      _textEditingController.value = TextEditingValue(
        text: sanitizedText,
        selection: TextSelection.collapsed(offset: cursorPosition),
      );
    }
  }

  List<Widget> getTopics(BuildContext context) {
    List<Widget> topics = [];

    for (int i = 0; i < topicsController.length; i++) {
      if (i == 0) {
        topics.add(Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: () {
                      topicsController.removeAt(0);
                      subtopicsController[0] = [];
                      BlocProvider.of<ChangeTopicsBloc>(context)
                          .add(TopicsChangedEvent());
                    },
                    icon: Icon(Icons.delete, size: 25)),
              ),
              Expanded(
                child: InputField(
                    controller: topicsController[0],
                    hintText: 'Add text...',
                    left: 5,
                    right: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                    onPressed: () {
                      if (subtopicsController[0] == null) {
                        subtopicsController[0] = [];
                      }
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
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: () {
                      topicsController.removeAt(i);
                      subtopicsController[i] = [];
                      BlocProvider.of<ChangeTopicsBloc>(context)
                          .add(TopicsChangedEvent());
                    },
                    icon: Icon(Icons.delete, size: 25)),
              ),
              Expanded(
                child: InputField(
                    controller: topicsController[i],
                    hintText: 'Add text...',
                    left: 5,
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
                      isSubTopic: true,
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

    topics.add(Padding(
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
        widget.currentReminder.allReminders[widget.reminderIndex].deadlineType =
            "none";
      } else if (buttonIndex == 1 && isSelected[buttonIndex] == true) {
        widget.currentReminder.allReminders[widget.reminderIndex].deadlineType =
            "thisWeek";
      } else if (buttonIndex == 2 && isSelected[buttonIndex] == true) {
        widget.currentReminder.allReminders[widget.reminderIndex].deadlineType =
            "on";
      } else if (buttonIndex == 3 && isSelected[buttonIndex] == true) {
        widget.currentReminder.allReminders[widget.reminderIndex].deadlineType =
            "before";
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
                if (!widget.edit) {
                  widget.currentReminder.allReminders
                      .removeAt(widget.reminderIndex);
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
                      color: !widget.edit ? Colors.grey : Colors.white),
                  onPressed: () {
                    if (widget.edit) {
                      if (originalDeadlineType == 'none') {
                        func.deleteAllNone(
                            widget.currentReminder,
                            widget.weekObject,
                            widget.currentReminder
                                .allReminders[widget.reminderIndex]);
                      } else {
                        widget.weekObject.weeks[widget.weekSelectedIndex]
                            .reminders.allReminders
                            .removeAt(widget.weekReminderIndex);
                      }
                      func.cancelNotifications(widget
                          .currentReminder.allReminders[widget.reminderIndex]);
                      widget.currentReminder.allReminders
                          .removeAt(widget.reminderIndex);
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
                          color: widget.currentReminder
                              .allReminders[widget.reminderIndex].color,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                  Scaffold(
                    resizeToAvoidBottomInset: true,
                    backgroundColor: Colors.transparent,
                    body: Padding(
                        padding:
                            EdgeInsets.only(right: 15, left: 15, bottom: 20),
                        child: SingleChildScrollView(
                            controller: controller,
                            child: BlocBuilder<ToggleButtonsBloc,
                                ToggleButtonsState>(
                              builder: (context, state) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 40, left: 17, bottom: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                AutoSizeText(
                                                  "Title",
                                                  style: GoogleFonts.questrial(
                                                      fontSize: 27,
                                                      color: Color(0xff1f1f1f)),
                                                ),
                                                AutoSizeText(
                                                  "(Suggesting that you fill this)",
                                                  style: GoogleFonts.questrial(
                                                      fontSize: 2,
                                                      color: Color(0xff1f1f1f)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, right: 5, bottom: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (widget.edit) {
                                                  if (originalDeadlineType ==
                                                      'none') {
                                                    func.deleteAllNone(
                                                        widget.currentReminder,
                                                        widget.weekObject,
                                                        widget.currentReminder
                                                                .allReminders[
                                                            widget
                                                                .reminderIndex]);
                                                  }
                                                }
                                                func.submit(
                                                    widget.currentReminder,
                                                    widget.reminderIndex,
                                                    submitReady,
                                                    tag1Controller,
                                                    tag2Controller,
                                                    subtitleController,
                                                    topicsController,
                                                    subtopicsController,
                                                    widget.edit,
                                                    widget.weekObject,
                                                    widget.initialDate,
                                                    context,
                                                    db,
                                                    widget.weekSelectedIndex,
                                                    widget.id);
                                                Navigator.of(context).pop();
                                              },
                                              child: BlocBuilder<FixErrorBloc,
                                                  FixErrorState>(
                                                builder: (context, state) {
                                                  return Container(
                                                      width: 65,
                                                      height: 65,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: submitReady
                                                            ? Color(0xffffffff)
                                                            : Color(0xffdadada),
                                                      ),
                                                      child: Icon(
                                                          Icons.done_rounded,
                                                          size: 45));
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
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
                                                  controller:
                                                      subtitleController,
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
                                          return widget
                                                      .currentReminder
                                                      .allReminders[
                                                          widget.reminderIndex]
                                                      .topics ==
                                                  null
                                              ? Center(
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children:
                                                          getTopics(context)),
                                                )
                                              : Column(
                                                  children: getTopics(context));
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 40, left: 17, bottom: 10),
                                        child: AutoSizeText(
                                          "Color Select",
                                          style: GoogleFonts.questrial(
                                              fontSize: 27,
                                              color: Color(0xff1f1f1f)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                            children: wd.getColors(
                                                widget.currentReminder
                                                        .allReminders[
                                                    widget.reminderIndex],
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
                                              BlocProvider.of<
                                                          ToggleButtonsBloc>(
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
                                                    style:
                                                        GoogleFonts.questrial(
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
                                                    style:
                                                        GoogleFonts.questrial(
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
                                                    style:
                                                        GoogleFonts.questrial(
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
                                                    style:
                                                        GoogleFonts.questrial(
                                                            fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      func.checkOnOrBefore(
                                              widget.currentReminder)
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
                                                        if (widget.edit) {
                                                          time.editDate(
                                                              context,
                                                              widget
                                                                  .initialDate,
                                                              widget
                                                                  .currentReminder,
                                                              widget
                                                                  .selectedDay);
                                                        } else {
                                                          time.selectDate(
                                                              context,
                                                              widget
                                                                  .initialDate,
                                                              widget
                                                                  .currentReminder,
                                                              widget
                                                                  .selectedDay);
                                                        }
                                                      },
                                                      child: AspectRatio(
                                                        aspectRatio: 5,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xff1f1f1f),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    AutoSizeText(
                                                                  widget.edit
                                                                      ? func.getSelectedDate(widget
                                                                          .currentReminder
                                                                          .allReminders[widget
                                                                              .reminderIndex]
                                                                          .deadline)
                                                                      : func.getSelectedDate(widget
                                                                          .selectedDay
                                                                          .selectedDay),
                                                                  maxLines: 1,
                                                                  style: GoogleFonts.questrial(
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
                                              padding:
                                                  EdgeInsets.only(bottom: 20))
                                    ]);
                              },
                            ))),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
