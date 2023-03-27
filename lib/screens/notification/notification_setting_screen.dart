import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/services/provider_service/user_preference_service.dart';
import 'package:healu_doctor_app/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class NotificationSettingScreen extends StatefulWidget {
  NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _notification = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                isShowBack: true,
                isShowRightIcon: false,
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: "Notification",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeClass.greyLightColor.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Push Notification"),
                        Consumer<UserPrefService>(
                            builder: (context, userProwider, child) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: FlutterSwitch(
                              width: 45.0,
                              height: 22.0,
                              toggleSize: 17.0,
                              value: userProwider.globleUserModel!.data!
                                      .notificationStatus ==
                                  "1",
                              borderRadius: 20.0,
                              padding: 3,
                              activeColor: ThemeClass.blueColor,
                              inactiveColor: ThemeClass.greyLightColor,
                              showOnOff: false,
                              onToggle: (val) {
                                userProwider.updateNotificationStatu(
                                    val == true ? "1" : "0");
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
