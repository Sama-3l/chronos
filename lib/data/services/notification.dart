// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance', 'reminders',
      groupId: "Reminders");

  Future<void> initializeNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notifychronos');
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body,
      DateTime dateTime, int notificationID) async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationID,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              importance: Importance.max,
              priority: Priority.max,
              setAsGroupSummary: true,
              icon: '@drawable/notifychronos',
              styleInformation: BigTextStyleInformation(
                body,
              )),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  void cancelNotifications(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelAll(){
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
