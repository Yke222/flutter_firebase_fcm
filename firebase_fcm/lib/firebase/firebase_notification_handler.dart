import 'dart:io';

import 'package:firebase_fcm/firebase/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  BuildContext myContext;

  void setupFirebase(BuildContext buildContext) {
    _firebaseMessaging = FirebaseMessaging();
    NotificationHandler.initNotification(buildContext);
    firebaseCloudMessagingListener(buildContext);

    myContext = buildContext;
  }

  void firebaseCloudMessagingListener(BuildContext context) {
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((event) {
      debugPrint("Settings registered $event");
    });

    _firebaseMessaging.getToken().then((value) => debugPrint("Token: $value"));

    _firebaseMessaging
        .subscribeToTopic("dev_test")
        .whenComplete(() => debugPrint("Subscribed"));

    Future.delayed(Duration(seconds: 1), () {
      _firebaseMessaging.configure(
        onBackgroundMessage:
            Platform.isIOS ? null : fcmBackgroundMessageHandler,
        onMessage: (Map<String, dynamic> message) async {
          // Fire when message is received from firebase.
          if (Platform.isAndroid) {
            showNotification(message['data']['title'], message['data']['body']);
          } else if (Platform.isIOS) {
            showNotification(message['notification']['title'],
                message['notification']['body']);
          }
        },
        onResume: (Map<String, dynamic> message) async {
          // Fire when app is oppened from notification
          if (Platform.isIOS) {
            showDialog(
              context: myContext,
              builder: (context) => CupertinoAlertDialog(
                title: Text(message['title']),
                content: Text(message['body']),
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
        },
        onLaunch: (Map<String, dynamic> message) async {
          if (Platform.isIOS) {
            showDialog(
              context: myContext,
              builder: (context) => CupertinoAlertDialog(
                title: Text(message['title']),
                content: Text(message['body']),
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
        },
      );
    });
  }

  static Future fcmBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    dynamic data = message['data'];
    showNotification(data['title'], data['body']);

    return Future<void>.value();
  }

  static void showNotification(title, body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "com.example.firebase_fcm",
      "channel",
      "channel description",
      autoCancel: false,
      ongoing: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await NotificationHandler.flutterLocalNotificationPlugin
        .show(0, title, body, platformChannelSpecifics, payload: "My Payload");
  }
}
