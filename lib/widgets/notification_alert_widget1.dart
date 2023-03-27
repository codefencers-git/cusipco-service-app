import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/screens/main_screen/home/appointment_details_screen.dart';
import 'package:healu_doctor_app/services/provider_service/dash_board_provider.dart';
import 'package:healu_doctor_app/widgets/button_widget/rounded_button_widget.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class NotificationAlertWidget1 extends StatefulWidget {
  NotificationAlertWidget1(
      {Key? key, required this.isSound, required this.title, required this.id})
      : super(key: key);
  final String isSound;
  String title;
  String id;
  @override
  State<NotificationAlertWidget1> createState() =>
      _NotificationAlertWidget1State();
}

class _NotificationAlertWidget1State extends State<NotificationAlertWidget1> {
  @override
  void initState() {
    // TODO: implement initState

    if (widget.isSound == "true") {
      _startVibrate();
    }

    super.initState();
  }

  _startVibrate() async {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 1, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
    Vibration.vibrate(pattern: [
      500,
      500,
      500,
      500,
      500,
      500,
      500,
      500,
    ], repeat: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 100,
                child: Lottie.asset('assets/animation/alert_animation.json')),
            Container(
              width: MediaQuery.of(context).size.width - 60,
              decoration: BoxDecoration(
                  color: ThemeClass.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.title.toString(),
                    style:
                        TextStyle(fontSize: 16, color: ThemeClass.blackColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MinButton(
                          title: "View Order",
                          color: ThemeClass.greenColor,
                          heightPadding: 0,
                          fontSize: 10,
                          callBack: () {
                            _stopRingtoneAndVibration();
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentDetailsScreen(
                                  appoingmentID: widget.id,
                                ),
                              ),
                            );
                          }),
                      SizedBox(
                        width: 5,
                      ),
                      MinButton(
                          title: "Close",
                          color: Colors.red,
                          heightPadding: 0,
                          fontSize: 10,
                          callBack: () {
                            _stopRingtoneAndVibration();
                            Navigator.pop(context);
                          }),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  _stopRingtoneAndVibration() async {
    if (widget.isSound == "true") {
      FlutterRingtonePlayer.stop();
      Vibration.cancel();
    } else {
      AwesomeNotifications().cancel(1);
    }
    var dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);

    dashboardProvider.getDashBoardData(isShowLoading: false);
  }
}
