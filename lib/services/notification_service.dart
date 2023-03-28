import 'package:flutter/material.dart' as colors;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro/provider/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:pomodoro/pages/home.dart';

class NotificationService {
  final notificationService = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    //when app is closed
    final details = await notificationService.getNotificationAppLaunchDetails();
    if (details!.didNotificationLaunchApp) {
      final payload = details.notificationResponse!.payload;
      onNotificationClick.add(payload);
    }

    await notificationService.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<NotificationDetails> breakNotificationDetails() async {
    const focusNotificationSound = 'focus_notification_sound';
    AndroidNotificationDetails breakNotificationDetails =
        const AndroidNotificationDetails('channelid1', 'channenl Name',
            channelDescription: 'describe',
            importance: Importance.max,
            timeoutAfter: 10000,
            sound: RawResourceAndroidNotificationSound(focusNotificationSound));

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(sound: '$focusNotificationSound.wav');

    NotificationDetails notificationDetails = NotificationDetails(
      android: breakNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    return notificationDetails;
  }

  Future<NotificationDetails> focusNotificationDetails() async {
    const breakNotificationSound = 'break_notification_sound';
    AndroidNotificationDetails focusNotificationDetails =
        const AndroidNotificationDetails('channel Id1', 'channenl Name',
            channelDescription: 'describe',
            importance: Importance.max,
            timeoutAfter: 10000,
            sound: RawResourceAndroidNotificationSound(breakNotificationSound));

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      sound: '$breakNotificationSound.wav',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: focusNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    return notificationDetails;
  }

  Future<void> showFocusNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await focusNotificationDetails();
    await notificationService.show(
      id,
      title,
      body,
      details,
    );
  }

  Future<void> showBreakNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await breakNotificationDetails();
    await notificationService.show(
      id,
      title,
      body,
      details,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload!.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
