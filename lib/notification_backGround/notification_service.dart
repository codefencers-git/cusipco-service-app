import 'dart:io';

import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart'
    hide AwesomeDateUtils;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
  );
}

Future<void> createSimpleNotification({
  required String id,
  required String title,
  required String message,
}) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "call_channel",
        title: title,
        body: message,
        payload: {"id": id},
        autoDismissible: false,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true,
        fullScreenIntent: true,
        category: NotificationCategory.Call,
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'ACCEPT',
            label: 'View Order',
            color: Colors.green.withOpacity(0.7),
            autoDismissible: true),
        NotificationActionButton(
            key: 'REJECT',
            label: 'Close',
            isDangerousOption: true,
            autoDismissible: true),
      ]);

  Future.delayed(Duration(seconds: 30), () {
    AwesomeNotifications().cancel(1);
  });
}

Future<void> createVideoCallNotification({
  required String id,
  required String isSound,
  required String callRoom,
  required String callToken,
  required String message,
  required String title,
}) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "video_call_channel",
        title: title,
        body: message,
        payload: {
          "id": id,
          "isSound": isSound,
          "callRoom": callRoom,
          "callToken": callToken,
          "message": message,
          "title": title,
        },
        autoDismissible: false,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true,
        fullScreenIntent: true,
        category: NotificationCategory.Call,
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'ACCEPT',
            label: 'Accept',
            color: Colors.green.withOpacity(0.7),
            autoDismissible: true),
        NotificationActionButton(
            key: 'REJECT',
            label: 'Reject',
            isDangerousOption: true,
            autoDismissible: true),
      ]);

  Future.delayed(Duration(seconds: 30), () {
    AwesomeNotifications().cancel(1);
  });
}

Future<String> getPlatformVersion() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    return 'Android-$sdkInt';
  }

  if (Platform.isIOS) {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    var systemName = iosInfo.systemName;
    var version = iosInfo.systemVersion;
    return '$systemName-$version';
  }

  return 'unknow';
}

checkNotificationPermission(context) {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Allow notification"),
                content: Text("Our app would like to send you notification"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Don't Allow")),
                  TextButton(
                      onPressed: () {
                        AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((value) => Navigator.pop(context));
                      },
                      child: Text("Allow"))
                ],
              ));
    }
  });
}
