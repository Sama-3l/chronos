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

class ListOfWeeks extends StatefulWidget {
  ListOfWeeks(
      {super.key,
      required this.weekObject,
      required this.col,
      required this.selectedDay,
      required this.controller,
      required this.weekSelectedIndex});

  final Weeks weekObject;
  final PrimaryColors col;
  SelectedDay selectedDay;
  ScrollController controller;
  int weekSelectedIndex;

  @override
  State<ListOfWeeks> createState() => _ListOfWeeksState();
}

class _ListOfWeeksState extends State<ListOfWeeks> {
  bool changeMonth = false;

  Alignment alignment = Alignment(-1, -1);

  late DateTime monthDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.animateTo((MediaQuery.of(context).size.height * 0.1 * 0.5 * 3.85 - 8) * widget.weekSelectedIndex,
          duration: Duration(milliseconds: 700), curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListView.builder(
              controller: widget.controller,
              scrollDirection: Axis.horizontal,
              itemCount: widget.weekObject.weeks.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  changeMonth = true;
                  monthDateTime = widget.weekObject.weeks[index].monday;
                  alignment = Alignment(-1, -1);
                } else {
                  if (widget.weekObject.weeks[index].sunday.month -
                          widget.weekObject.weeks[index].monday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = DateTime(
                        widget.weekObject.weeks[index].monday.year,
                        widget.weekObject.weeks[index].monday.month + 1,
                        widget.weekObject.weeks[index].monday.day);
                    alignment = Alignment(1, -1);
                  } else if (widget.weekObject.weeks[index].sunday.month -
                          widget.weekObject.weeks[index].sunday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = widget.weekObject.weeks[index].monday;
                    alignment = Alignment(-1, -1);
                  } else if (widget.weekObject.weeks[index].monday.month -
                          widget.weekObject.weeks[index - 1].sunday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = widget.weekObject.weeks[index].monday;
                    alignment = Alignment(-1, -1);
                  } else if (widget.weekObject.weeks[index].sunday.month -
                          widget.weekObject.weeks[index - 1].sunday.month !=
                      0) {
                    changeMonth = true;
                    monthDateTime = widget.weekObject.weeks[index].monday;
                    alignment = Alignment(-1, -1);
                  } else {
                    changeMonth = false;
                  }
                }
                return Padding(
                  padding: EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () {
                      widget
                          .weekObject
                          .weeks[widget.selectedDay.selectedWeekIndex]
                          .selected = false;
                      widget.weekObject.weeks[index].selected = true;
                      widget.selectedDay.selectedWeekIndex = index;
                      BlocProvider.of<ChangeWeekBloc>(context).add(
                          WeekChangeEvent(selectedDay: widget.selectedDay));
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
                                            color: widget.col.whiteTextColor)),
                                  )
                                : Container(),
                          ),
                        )),
                        Flexible(
                          child: AspectRatio(
                              aspectRatio: 3.85,
                              child: widget.weekObject.weeks[index].selected
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: widget.col.selectionColor,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: AutoSizeText(
                                            widget.weekObject.weeks[index].week,
                                            style: GoogleFonts.questrial(
                                                fontSize: 17,
                                                color: widget
                                                    .col.primaryTextColor)),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: widget.col.whiteTextColor),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: AutoSizeText(
                                            widget.weekObject.weeks[index].week,
                                            style: GoogleFonts.questrial(
                                                fontSize: 17,
                                                color:
                                                    widget.col.whiteTextColor)),
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
