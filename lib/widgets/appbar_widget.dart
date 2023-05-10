import 'dart:convert';

import 'package:cusipco_doctor_app/screens/main_screen/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/screens/notification/notification_setting_screen.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../screens/main_screen/chat/AgoraTokenModel.dart';
import '../screens/video/video_screen.dart';
import '../screens/video/video_service.dart';
import '../services/http_service.dart';

class AppBarWithTextAndBackWidget extends StatelessWidget {
  const AppBarWithTextAndBackWidget(
      {Key? key,
      required this.title,
      this.isShowRightIcon = false,
      this.isShowBack = false,
      this.chatOption = false,
        this.audiovideo = false,
        this.userId  ,
        this.isClickOnRightIcon = true,
      required this.onbackPress})
      : super(key: key);
  final bool isShowBack;
  final bool isShowRightIcon;
  final bool isClickOnRightIcon;
  final String title;
  final String? userId;
  final bool? chatOption;
  final bool? audiovideo;
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
          chatOption == true ? InkWell(
              onTap: (){
                pushNewScreen(
                  context,
                  screen: ChatScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Icon(Icons.chat)) : Container()
        ],
      ),
        actions: [
          audiovideo == true
              ? Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () {
                        getAgoraToken(  userId.toString(), "Audio", context: context).then((value) {
                          pushNewScreen(context,
                              screen: VideoScreen(
                                type: "Audio",
                                  roomId: value!.data.call_room));
                        });
                      },
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ))),
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () {
                        getAgoraToken(  userId.toString(), "Video", context: context).then((value) {
                          pushNewScreen(context,
                              screen: VideoScreen(
                                  type: "Video",
                                  roomId: value!.data.call_room));
                        });
                      },
                      child: Icon(
                        Icons.video_call,
                        color: Colors.white,
                      ))),
            ],
          )
              : SizedBox()

        ],

    );
  }
}