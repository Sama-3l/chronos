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
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      int id, String title, String body, DateTime dateTime, int notficationID) async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              importance: Importance.max,
              priority: Priority.max,
              ongoing: true,
              setAsGroupSummary: true,
              icon: '@mipmap/ic_launcher',
              styleInformation: BigTextStyleInformation(
                'Additional Information',
                contentTitle:
                    'This is the expanded text content of the notification.',
                summaryText: 'Chronos',
              )),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }
}
