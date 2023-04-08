// ignore_for_file: prefer_const_constructors

import 'package:chronos/algorithms/timeCalc.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/selectedDay.dart';
import 'package:chronos/data/model/week.dart';
import 'package:chronos/data/repositories/weeks.dart';
import 'package:chronos/presentation/widgets/daysOfWeek.dart';
import 'package:chronos/presentation/widgets/listOfWeeks.dart';
import 'package:chronos/presentation/widgets/taskCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

import '../business_logic/blocs/bloc/change_week_bloc.dart';
import 'widgets/eachDay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PrimaryColors col = PrimaryColors();
  TimeNow time = TimeNow();
  TagColors tag = TagColors();

  Weeks weekObject = Weeks();
  List<Widget> taskList = [];
  int weekSelectedIndex = 0;
  final ScrollController _controller = ScrollController();
  bool sliverPersistentHeader = false;
  List<Widget> weekDays = [];
  List<String> selectedDays = [];

  late SelectedDay selectedDay;
  late int initialWeekIndex;

  void selectedWeek(SelectedDay? setDay) {
    weekDays = [];
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
  }

  @override
  void initState() {
    super.initState();
    weekObject = time.initializeWeeks(DateTime.now().year);
    for (int i = 0; i < weekObject.weeks.length; i++) {
      if (weekObject.weeks[i].monday.compareTo(DateTime.now()) <= 0 &&
          weekObject.weeks[i].sunday.compareTo(DateTime.now()) >= 0) {
        weekObject.weeks[i].selected = true;
        weekSelectedIndex = i;
      }
    }
    initialWeekIndex = weekSelectedIndex;
    selectedDay = SelectedDay(
        selectedDay: DateTime.now(), selectedWeekIndex: weekSelectedIndex);
    taskList.add(TaskCard(tagColor: tag.darkPurpleTag));
    taskList.add(TaskCard(tagColor: tag.lightGreenTag));
    taskList.add(TaskCard(tagColor: tag.blueTag));
    taskList.add(TaskCard(tagColor: tag.blueTag));
    taskList.add(TaskCard(tagColor: tag.blueTag));
    taskList.add(TaskCard(tagColor: tag.blueTag));
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
    selectedWeek(selectedDay);
  }

  String checkTodayStatus() {
    if (selectedDay.selectedDay.difference(DateTime.now()).inDays == 0) {
      return "Today";
    } else {
      return "Selected";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeWeekBloc, ChangeWeekState>(
      builder: (context, state) {
        if (state is WeekChangeState) {
          selectedDay = state.selectedDay!;
          weekSelectedIndex = selectedDay.selectedWeekIndex;
          selectedWeek(state.selectedDay);
        }
        return Scaffold(
            backgroundColor: col.appColor,
            appBar: AppBar(
                title: Row(
                  children: [
                    AutoSizeText(
                        DateFormat.MMMMd().format(selectedDay.selectedDay),
                        minFontSize: 12,
                        style: GoogleFonts.questrial(
                            fontSize: 23, color: col.whiteTextColor)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            color: col.dotColor,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        weekObject.weeks[selectedDay.selectedWeekIndex]
                            .selected = false;
                        selectedDay.selectedDay = DateTime.now();
                        selectedDay.selectedWeekIndex = initialWeekIndex;
                        weekObject.weeks[initialWeekIndex].selected = true;
                        selectedDay.selectedWeekIndex = initialWeekIndex;
                        BlocProvider.of<ChangeWeekBloc>(context)
                            .add(WeekChangeEvent(selectedDay: selectedDay));
                      },
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(checkTodayStatus(),
                            style: GoogleFonts.questrial(
                              fontSize: 23,
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
            floatingActionButton: FloatingActionButton(onPressed: () {}));
      },
    );
  }
}
