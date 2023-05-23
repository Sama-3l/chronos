import 'package:chronos/data/model/selectedDay.dart';
import 'package:flutter/material.dart';

import '../../data/model/hive_reminder.dart';

class PopUp extends StatelessWidget {
  PopUp({super.key, required this.reminder, required this.selectedDay});

  Reminder reminder;
  SelectedDay selectedDay;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: reminder.tag1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: reminder.color,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(reminder.tag1),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        maxLines: 8,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'Write a note...',
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );;
  }
}