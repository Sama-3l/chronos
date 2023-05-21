// ignore_for_file: prefer_const_constructors

import 'package:chronos/business_logic/blocs/change_week/change_week_bloc.dart';
import 'package:chronos/data/model/selectedDay.dart';
import 'package:chronos/data/repositories/hive_weeks.dart';
import 'package:flutter/material.dart';
import 'package:chronos/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

class ListOfWeeks extends StatelessWidget {
  ListOfWeeks(
      {super.key,
      required this.weekObject,
      required this.col,
      required this.selectedDay});

  final Weeks weekObject;
  final PrimaryColors col;
  SelectedDay selectedDay;
  bool changeMonth = false;
  Alignment alignment = Alignment(-1, -1);
  late DateTime monthDateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  changeMonth = true;
                  monthDateTime = weekObject.weeks[index].monday;
                  alignment = Alignment(-1, -1);
                } else {
                  if (weekObject.weeks[index].sunday.month -
                          weekObject.weeks[index].monday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = DateTime(
                        weekObject.weeks[index].monday.year,
                        weekObject.weeks[index].monday.month + 1,
                        weekObject.weeks[index].monday.day);
                    alignment = Alignment(1, -1);
                  } else if (weekObject.weeks[index].sunday.month -
                          weekObject.weeks[index].sunday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = weekObject.weeks[index].monday;
                    alignment = Alignment(-1, -1);
                  } else if (weekObject.weeks[index].monday.month -
                          weekObject.weeks[index - 1].sunday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = weekObject.weeks[index].monday;
                    alignment = Alignment(-1, -1);
                  } else if (weekObject.weeks[index].sunday.month -
                          weekObject.weeks[index - 1].sunday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = weekObject.weeks[index].monday;
                    alignment = Alignment(-1, -1);
                  } else {
                    changeMonth = false;
                  }
                }
                return Padding(
                  padding: EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () {
                      weekObject.weeks[selectedDay.selectedWeekIndex].selected =
                          false;
                      weekObject.weeks[index].selected = true;
                      selectedDay.selectedWeekIndex = index;
                      BlocProvider.of<ChangeWeekBloc>(context)
                          .add(WeekChangeEvent(selectedDay: selectedDay));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: AspectRatio(
                            aspectRatio: 3.85,
                            child: changeMonth
                                ? Align(
                                    alignment: alignment,
                                    child: AutoSizeText(
                                        DateFormat.MMM().format(monthDateTime),
                                        style: GoogleFonts.questrial(
                                            fontSize: 17,
                                            color: col.whiteTextColor)),
                                  )
                                : Container(),
                          ),
                        )),
                        Flexible(
                          child: AspectRatio(
                              aspectRatio: 3.85,
                              child: weekObject.weeks[index].selected
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: col.selectionColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: AutoSizeText(
                                            weekObject.weeks[index].week,
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
                                        child: AutoSizeText(
                                            weekObject.weeks[index].week,
                                            style: GoogleFonts.questrial(
                                                fontSize: 17,
                                                color: col.whiteTextColor)),
                                      ))),
                        ),
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
