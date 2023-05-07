// ignore_for_file: prefer_const_constructors

import 'package:chronos/algorithms/methods.dart';
import 'package:chronos/algorithms/timeCalc.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/constants/icons.dart';
import 'package:chronos/data/model/reminder.dart';
import 'package:chronos/data/model/selectedDay.dart';
import 'package:chronos/data/model/week.dart';
import 'package:chronos/data/repositories/allReminders.dart';
import 'package:chronos/data/repositories/weeks.dart';
import 'package:chronos/presentation/widgets/daysOfWeek.dart';
import 'package:chronos/presentation/widgets/listOfWeeks.dart';
import 'package:chronos/presentation/widgets/taskCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';

import '../business_logic/blocs/bloc/change_week_bloc.dart';
import 'widgets/eachDay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  PrimaryColors col = PrimaryColors();
  TimeNow time = TimeNow();
  TagColors tag = TagColors();
  Weeks weekObject = Weeks();
  Reminders? allReminders;
  Methods func = Methods();

  List<Widget> taskList = [];
  int weekSelectedIndex = 0;
  bool sliverPersistentHeader = false;
  List<Widget> weekDays = [];
  List<String> selectedDays = [];

  late SelectedDay selectedDay;
  late int initialWeekIndex;

  DateTime todayDateTimeObject =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void initialize() {
    weekObject = time.initializeWeeks(todayDateTimeObject);
    initialWeekIndex = weekSelectedIndex;
    selectedDay = SelectedDay(
        selectedDay: todayDateTimeObject, selectedWeekIndex: weekSelectedIndex);
    weekObject.weeks[weekSelectedIndex].selected = true;
    // taskList.add(TaskCard(tagColor: tag.darkPurpleTag));
    // taskList.add(TaskCard(tagColor: tag.lightGreenTag));
    // taskList.add(TaskCard(tagColor: tag.blueTag));
    // taskList.add(TaskCard(tagColor: tag.blueTag));
    // taskList.add(TaskCard(tagColor: tag.blueTag));
    // taskList.add(TaskCard(tagColor: tag.blueTag));
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          sliverPersistentHeader = false;
        });
      } else {
        setState(() {
          sliverPersistentHeader = true;
        });
      }
    });
    weekDays = func.selectedWeek(
        selectedDay, weekObject, weekSelectedIndex, selectedDay);
    allReminders = Reminders(allReminders: [
      Reminder(
          isDescriptive: true,
          tag1: "Financial",
          tag2: "Exchange",
          deadline: DateTime(2023, 5, 2),
          color: tag.darkPurpleTag),
      Reminder(
          isDescriptive: true,
          tag1: "Assignment",
          tag2: "Heat",
          deadline: DateTime(2023, 5, 2),
          color: tag.lightGreenTag)
    ]);

    for (int i = 0; i < allReminders!.allReminders.length; i++) {
      if (weekObject
              .weeks[func.calculateWeekIndex(
                  allReminders!.allReminders[i].deadline,
                  weekObject.weeks[0].sunday)]
              .reminders ==
          null) {
        weekObject
                .weeks[func.calculateWeekIndex(
                    allReminders!.allReminders[i].deadline,
                    weekObject.weeks[0].sunday)]
                .reminders =
            Reminders(allReminders: [allReminders!.allReminders[i]]);
      } else {
        weekObject
            .weeks[func.calculateWeekIndex(
                allReminders!.allReminders[i].deadline,
                weekObject.weeks[0].sunday)]
            .reminders!
            .allReminders
            .add(allReminders!.allReminders[i]);
      }
    }
    print(weekObject
        .weeks[
            func.calculateWeekIndex(DateTime.now(), weekObject.weeks[0].sunday)]
        .monday);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeWeekBloc, ChangeWeekState>(
      builder: (context, state) {
        if (state is WeekChangeState) {
          selectedDay = state.selectedDay!;
          weekSelectedIndex = selectedDay.selectedWeekIndex;
          weekDays = func.selectedWeek(
              state.selectedDay, weekObject, weekSelectedIndex, selectedDay);
          taskList =
              func.currentDayTasks(weekObject, weekSelectedIndex, selectedDay);
        }
        return Scaffold(
            backgroundColor: col.appColor,
            appBar: AppBar(
                title: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                          DateFormat.MMMMd().format(selectedDay.selectedDay),
                          style: GoogleFonts.questrial(
                              fontSize: 19, color: col.whiteTextColor)),
                    ),
                    Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                          color: col.dotColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    TextButton(
                      onPressed: () {
                        weekObject.weeks[selectedDay.selectedWeekIndex]
                            .selected = false;
                        selectedDay.selectedDay = todayDateTimeObject;
                        selectedDay.selectedWeekIndex = initialWeekIndex;
                        weekObject.weeks[initialWeekIndex].selected = true;
                        selectedDay.selectedWeekIndex = initialWeekIndex;
                        BlocProvider.of<ChangeWeekBloc>(context)
                            .add(WeekChangeEvent(selectedDay: selectedDay));
                      },
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                            func.checkTodayStatus(
                                selectedDay, todayDateTimeObject),
                            style: GoogleFonts.questrial(
                                fontSize: 19,
                                color: col.whiteTextColor.withOpacity(0.7))),
                      ),
                    ),
                    Expanded(child: Container())
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 15),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: col.whiteFieldColor,
                          borderRadius: BorderRadius.circular(70)),
                    ),
                  ),
                ],
                toolbarHeight: 100,
                elevation: 0,
                backgroundColor: Colors.transparent),
            body: CustomScrollView(controller: _controller, slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: col.appColor,
                elevation: 0,
                toolbarHeight: 70,
                titleSpacing: 0,
                title: ListOfWeeks(
                    weekObject: weekObject, col: col, selectedDay: selectedDay),
              ),
              SliverPersistentHeader(
                  pinned: sliverPersistentHeader,
                  delegate: DayOfWeek(
                      thisWeek: weekDays,
                      currentWeekMap: weekObject.weeks[weekSelectedIndex],
                      maxheight: MediaQuery.of(context).size.height * 0.2,
                      minheight: MediaQuery.of(context).size.height * 0.13)),
              SliverFixedExtentList(
                  delegate: SliverChildListDelegate(taskList),
                  itemExtent: MediaQuery.of(context).size.height * 0.28)
            ]),
            floatingActionButton: SizedBox(
                height: MediaQuery.of(context).size.height * 0.088,
                width: MediaQuery.of(context).size.height * 0.088,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        backgroundColor: col.primaryTextColor),
                    onPressed: () {},
                    child: Iconify(addReminder,
                        size: MediaQuery.of(context).size.height * 0.08))));
      },
    );
  }
}
