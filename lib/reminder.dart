
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            child: Text('Set Reminder'),
            onPressed: () async {
              var scheduledNotificationDateTime =
                  DateTime.now().add(Duration(seconds: 5));
              var vibrationPattern = Int64List(4);
              vibrationPattern[0] = 0;
              vibrationPattern[1] = 1000;
              vibrationPattern[2] = 5000;
              vibrationPattern[3] = 2000;

              var androidPlatformChannelSpecifics = AndroidNotificationDetails(
                  'your channel id',
                  'your channel name',
                
                  icon: 'app_icon',
                  sound: RawResourceAndroidNotificationSound('notification'),
                  largeIcon: DrawableResourceAndroidBitmap('app_icon'),
                  vibrationPattern: vibrationPattern,
                  enableLights: true,
                  color: const Color.fromARGB(255, 255, 0, 0),
                  ledColor: const Color.fromARGB(255, 255, 0, 0),
                  ledOnMs: 1000,
                  ledOffMs: 500);
              var iOSPlatformChannelSpecifics =
                  IOSNotificationDetails(sound: 'notification.aiff');
              var platformChannelSpecifics = NotificationDetails(
                  android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
              // ignore: deprecated_member_use
              await flutterLocalNotificationsPlugin.schedule(
                  0,
                  'Reminder',
                  'Don\'t forget to do your activity',
                  scheduledNotificationDateTime,
                  platformChannelSpecifics);
            },
          ),
        ],
      ),
    );
  }
}
