import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  static void func(NotificationResponse no) {}

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      .new();

  static Future<void> localNotificationsInit() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: func,
      onDidReceiveNotificationResponse: func,
    );
  }

  static Future<void> setshadualedNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int min,
  }) async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        '$id$title',
        '$title Scheduled',
        priority: Priority.high,
        importance: Importance.max,
      ),
    );
    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    final currentTime = tz.TZDateTime.now(tz.local);
    log(currentTime.toString());
    if (currentTime.isAfter(
      tz.TZDateTime(
        tz.local,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        hour,
        min,
      ),
    )) {
      currentTime.add(Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime(
        tz.local,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        hour,
        min,
      ),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> deleteNotificationById(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
