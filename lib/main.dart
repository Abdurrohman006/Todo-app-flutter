import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/material.dart';
import 'package:todo_app/task_list_screen.dart';

void main() {
  AwesomeNotifications().initialize("defaultIcon", [
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'scheduled_channel',
      defaultColor: Colors.teal,
      channelDescription: '',
      importance: NotificationImportance.High,
      channelShowBadge: true,
    )
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}
