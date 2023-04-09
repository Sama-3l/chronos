import 'package:chronos/business_logic/blocs/bloc/change_week_bloc.dart';
import 'package:chronos/constants/colors.dart';
import 'package:chronos/data/model/selectedDay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Day extends StatelessWidget {
  Day(
      {super.key,
      required this.index,
      required this.date,
      required this.selected,
      required this.dateTime,
      required this.selectedDay});

  PrimaryColors col = PrimaryColors();
  int index;
  String date;
  bool selected;
  DateTime dateTime;
  SelectedDay? selectedDay;

  final List<String> days = ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    return selected
        ? SizedBox(
            height: (MediaQuery.of(context).size.width - 30) / 7,
            width: (MediaQuery.of(context).size.width - 30) / 7,
            child: TextButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: col.primaryTextColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60))),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: AutoSizeText(days[index],
                          // minFontSize: 2,
                          maxFontSize: 13,
                          style:
                              GoogleFonts.questrial(color: col.whiteTextColor)),
                    ),
                    AutoSizeText(date,
                        // minFontSize: 12,
                        maxFontSize: 23,
                        style: GoogleFonts.questrial(color: col.whiteTextColor))
                  ]),
            ))
        : SizedBox(
            height: (MediaQuery.of(context).size.width - 30) / 7,
            width: (MediaQuery.of(context).size.width - 30) / 7,
            child: TextButton(
              onPressed: () {
                selectedDay!.selectedDay = dateTime;
                BlocProvider.of<ChangeWeekBloc>(context)
                    .add(WeekChangeEvent(selectedDay: selectedDay));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60))),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: AutoSizeText(days[index],
                          // minFontSize: 2,
                          maxFontSize: 13,
                          style: GoogleFonts.questrial(
                              color: col.primaryTextColor)),
                    ),
                    AutoSizeText(date,
                        // minFontSize: 12,
                        maxFontSize: 23,
                        style:
                            GoogleFonts.questrial(color: col.primaryTextColor))
                  ]),
            ),
          );
  }
}
