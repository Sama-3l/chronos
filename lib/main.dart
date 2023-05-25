// ignore_for_file: prefer_const_constructors

import 'package:chronos/business_logic/blocs/change_color/change_color_bloc.dart';
import 'package:chronos/business_logic/blocs/change_reminder/change_reminders_bloc.dart';
import 'package:chronos/business_logic/blocs/change_topics/change_topics_bloc.dart';
import 'package:chronos/business_logic/blocs/change_week/change_week_bloc.dart';
import 'package:chronos/business_logic/blocs/date_selected/date_selected_bloc.dart';
import 'package:chronos/business_logic/blocs/fix_error/fix_error_bloc.dart';
import 'package:chronos/business_logic/blocs/toggle_buttons/toggle_buttons_bloc.dart';
import 'package:chronos/data/model/color.g.dart';
import 'package:chronos/data/model/dateTime.g.dart';
import 'package:chronos/data/model/hive_reminder.dart';
import 'package:chronos/data/model/hive_topic.dart';
import 'package:chronos/data/model/hive_week.dart';
import 'package:chronos/data/repositories/hive_allReminders.dart';
import 'package:chronos/data/repositories/hive_weeks.dart';
import 'package:chronos/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(DateTimeAdapter());
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(TopicAdapter());
  Hive.registerAdapter(WeekAdapter());
  Hive.registerAdapter(RemindersAdapter());
  Hive.registerAdapter(WeeksAdapter());

  await Hive.initFlutter();
  await Hive.openBox('Database');
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
        BlocProvider(create: (context) => ChangeTopicsBloc()),
        BlocProvider(create: (context) => DateSelectedBloc()),
        BlocProvider(create: (context) => FixErrorBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
