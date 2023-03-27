import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/screens/notification/notification_setting_screen.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AppBarWithTextAndBackWidget extends StatelessWidget {
  const AppBarWithTextAndBackWidget(
      {Key? key,
      required this.title,
      this.isShowRightIcon = false,
      this.isShowBack = false,
      this.isClickOnRightIcon = true,
      required this.onbackPress})
      : super(key: key);
  final bool isShowBack;
  final bool isShowRightIcon;
  final bool isClickOnRightIcon;
  final String title;
  final Function onbackPress;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ThemeClass.blueColor,
      toolbarHeight: 70,
      title: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              if (isShowBack) onbackPress();
            },
            child: isShowBack
                ? Icon(Icons.arrow_back)
                : Image.asset(
                    "assets/images/app_bar_icon.png",
                    height: 40,
                    width: 40,
                  ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
      // actions: [
      //   isShowRightIcon
      //       ? InkWell(
      //           splashFactory: NoSplash.splashFactory,
      //           onTap: () {
      //             if (isClickOnRightIcon) {
      //               pushNewScreen(
      //                 context,
      //                 screen: NotificationSettingScreen(),
      //                 withNavBar: false,
      //                 pageTransitionAnimation:
      //                     PageTransitionAnimation.cupertino,
      //               );
      //             }
      //           },
      //           child: Padding(
      //             padding: const EdgeInsets.only(right: 0),
      //             child: Stack(
      //               children: [
      //                 Align(
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(right: 20),
      //                     child: Image.asset(
      //                       "assets/icons/notifications_none.png",
      //                       height: 25,
      //                       width: 25,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         )
      //       : SizedBox(),
      // ],
    );
  }
}
