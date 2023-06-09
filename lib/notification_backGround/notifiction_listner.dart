import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/navigation_service.dart';
import 'package:healu_doctor_app/screens/main_screen/home/appointment_details_screen.dart';
import 'package:healu_doctor_app/widgets/notification_alert_widget1.dart';

class NotificationListner {
  initializeNotification() {
    AwesomeNotifications().initialize(
        "",
        [
          NotificationChannel(
              channelGroupKey: 'category_tests',
              channelKey: 'call_channel',
              channelName: 'Calls Channel',
              channelDescription: 'Channel with call ringtone',
              defaultColor: Color(0xFF9D50DD),
              importance: NotificationImportance.Max,
              ledColor: Colors.white,
              channelShowBadge: true,
              locked: true,
              defaultRingtoneType: DefaultRingtoneType.Ringtone),
        ],
        debug: true);
  }

  notificationStreamListner(context) {
    AwesomeNotifications().createdStream.listen((receivedNotification) {
      String? createdSourceText = AwesomeAssertUtils.toSimpleEnumString(
          receivedNotification.createdSource);
      ;
    });

    AwesomeNotifications().displayedStream.listen((receivedNotification) {
      String? createdSourceText = AwesomeAssertUtils.toSimpleEnumString(
          receivedNotification.createdSource);
    });

    AwesomeNotifications().dismissedStream.listen((receivedAction) {
      String? dismissedSourceText = AwesomeAssertUtils.toSimpleEnumString(
          receivedAction.dismissedLifeCycle);
    });

    AwesomeNotifications().actionStream.listen((receivedAction) {
      print(receivedAction);
      if (receivedAction.channelKey == 'call_channel') {
        switch (receivedAction.buttonKeyPressed) {
          case 'REJECT':
            AwesomeNotifications().cancel(1);
            break;

          case 'ACCEPT':
            AwesomeNotifications().cancel(1);
            Navigator.push(
              navigationService.navigationKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => AppointmentDetailsScreen(
                        appoingmentID: receivedAction.payload!['id'].toString(),
                      )),
            );
            break;

          default:
            _showAlertOrder(
              isSound: "false",
              id: receivedAction.payload!['id'].toString(),
              title: receivedAction.title.toString(),
            );

            // var adsad = receivedAction.;
            Future.delayed(Duration(seconds: 30), () {
              AwesomeNotifications().cancel(1);
            });
            break;
        }
        return;
      }
    });
  }

  closeStream() {
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
  }
}

_showAlertOrder({
  required String isSound,
  required String id,
  required String title,
}) {
  showDialog(
    context: navigationService.navigationKey.currentContext!,
    builder: (BuildContext context) {
      return NotificationAlertWidget1(
        isSound: isSound,
        id: id,
        title: title,
      );
    },
  );
}

makeListnerNotification() {
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
    print("---------${message}");

    print(message.data);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data != null) {
      if (message.data['alert_type'] != null &&
          message.data['alert_type'] == "Call") {
        _showAlertOrder(
            isSound: "true",
            id: message.data['type_id'],
            title: message.data['title']);
      }
    }
  });
}
