// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chronos/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/services/notification.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  PrimaryColors col = PrimaryColors();

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('All notifications cancelled'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: col.appColor,
        body: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, bottom: 140),
              child: AutoSizeText(DateFormat.yMMMMd().format(DateTime.now()),
                  minFontSize: 27,
                  style: GoogleFonts.questrial(
                      fontSize: 32, color: col.whiteTextColor)),
            ),
            Container(
              height: 1,
              color: col.whiteTextColor,
            ),
            TextButton(
              onPressed: () {
                showSnackbar(context);
                // NotificationService notify = NotificationService();
                // notify.cancelAll();
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText("Cancel All Notifications",
                          minFontSize: 15,
                          style: GoogleFonts.questrial(
                              fontSize: 21,
                              color: col.whiteTextColor,
                              letterSpacing: -1.5)),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5, left: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                          "Turns off notifications on all the reminders set",
                          minFontSize: 7,
                          style: GoogleFonts.questrial(
                              fontSize: 17,
                              color: col.whiteTextColor.withOpacity(0.6),
                              letterSpacing: -0.5)),
                    )),
              ]),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, left: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText("App Version",
                      minFontSize: 15,
                      style: GoogleFonts.questrial(
                          fontSize: 21,
                          color: col.whiteTextColor,
                          letterSpacing: -1.5)),
                )),
            Padding(
                padding: EdgeInsets.only(top: 5, left: 25, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText("v1.0.0",
                      minFontSize: 7,
                      style: GoogleFonts.questrial(
                          fontSize: 17,
                          color: col.whiteTextColor.withOpacity(0.6),
                          letterSpacing: -0.5)),
                ))
          ]),
        ));
  }
}
