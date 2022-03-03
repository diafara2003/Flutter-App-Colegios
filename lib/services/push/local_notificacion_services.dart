import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificacionServices {
  static final FlutterLocalNotificationsPlugin _notificacionPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("mipmap/ic_launcher"));

    _notificacionPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      Navigator.of(context).pushNamed(route!);
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              "easyapproach", "easyapproach channel", "this is out channer",
              importance: Importance.max, priority: Priority.high));

      await _notificacionPlugin.show(id, message.notification!.title,
          message.notification!.title, notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }
}
