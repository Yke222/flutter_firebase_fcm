import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      flutterLocalNotificationPlugin();

  static BuildContext myContext;
  static void initNotification(BuildContext context) {
    myContext = context;
    var initAndroid = AndroidInitializationSettings("@mimap/ic_launcher");

    var initIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initSettings =
        InitializationSettings(android: initAndroid, iOS: initIOS);

    flutterLocalNotificationPlugin.initalize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint("Notification payload: $payload");
    }
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    showDialog(
      context: myContext,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              print("Clicked on notification");
            },
          )
        ],
      ),
    );
  }
}
