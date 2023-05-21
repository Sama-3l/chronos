// ignore_for_file: prefer_const_constructors

import 'package:chronos/business_logic/blocs/change_color/change_color_bloc.dart';
import 'package:chronos/business_logic/blocs/change_reminder/change_reminders_bloc.dart';
import 'package:chronos/business_logic/blocs/change_topics/change_topics_bloc.dart';
import 'package:chronos/business_logic/blocs/change_week/change_week_bloc.dart';
import 'package:chronos/business_logic/blocs/toggle_buttons/toggle_buttons_bloc.dart';
import 'package:chronos/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChangeWeekBloc()),
        BlocProvider(create: (context) => ChangeRemindersBloc()),
        BlocProvider(create: (context) => ChangeColorBloc()),
        BlocProvider(create: (context) => ToggleButtonsBloc()),
        BlocProvider(create: (context) => ChangeTopicsBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
