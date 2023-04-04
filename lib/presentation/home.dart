// ignore_for_file: prefer_const_constructors

import 'package:chronos/algorithms/timeCalc.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/presentation/widgets/dayOfWeek.dart';
import 'package:chronos/presentation/widgets/taskCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PrimaryColors col = PrimaryColors();
  TimeNow time = TimeNow();
  TagColors tag = TagColors();

  List<Widget> children = [
    Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return AspectRatio(
                aspectRatio: 3.85, child: Container(color: Colors.white));
          }),
    )
  ];

  List<Map<String, dynamic>> weeks = [];
  List<Widget> taskList = [];

  ScrollController _controller = ScrollController();
  bool sliverPersistentHeader = false;

  @override
  void initState() {
    super.initState();
    weeks = time.initializeWeeks(DateTime.now().year);
    for (int i = 0; i < weeks.length; i++) {
      if (weeks[i]['monday'].compareTo(DateTime.now()) <= 0 &&
          weeks[i]['sunday'].compareTo(DateTime.now()) >= 0) {
        weeks[i]['selected'] = true;
      }
      print(weeks[i]);
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: col.appColor,
        appBar: AppBar(
            title: Row(
              children: [
                AutoSizeText("March 23",
                    minFontSize: 12,
                    style: GoogleFonts.questrial(
                        fontSize: 23, color: col.whiteTextColor)),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                        color: col.dotColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                AutoSizeText("Today",
                    minFontSize: 12,
                    style: GoogleFonts.questrial(
                        fontSize: 23,
                        color: col.whiteTextColor.withOpacity(0.7))),
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
            title: Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: SizedBox(
                  height: 52,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: AspectRatio(
                              aspectRatio: 3.85,
                              child: weeks[index]['selected']
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: col.selectionColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: Text('${weeks[index]['week']}',
                                            style: GoogleFonts.questrial(
                                                fontSize: 17,
                                                color: col.primaryTextColor)),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: col.whiteTextColor),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text('${weeks[index]['week']}',
                                            style: GoogleFonts.questrial(
                                                fontSize: 17,
                                                color: col.whiteTextColor)),
                                      ))),
                        );
                      })),
            ),
          ),
          SliverPersistentHeader(
              pinned: sliverPersistentHeader,
              delegate: DayOfWeek(
                  maxheight: MediaQuery.of(context).size.height * 0.2,
                  minheight: MediaQuery.of(context).size.height * 0.13)),
          SliverFixedExtentList(
              delegate: SliverChildListDelegate(taskList),
              itemExtent: MediaQuery.of(context).size.height * 0.28)
        ]),
        floatingActionButton: FloatingActionButton(onPressed: () {}));
  }
}
