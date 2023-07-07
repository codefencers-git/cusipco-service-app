import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key,  this.roomId, this.type}) : super(key: key);
  final String? roomId;
  final String? type;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  final String localUserID = Random().nextInt(10000).toString();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("WidgetType:::"+widget.type.toString());
    var appId = 794102158;
    var appSign = "f2245167c805c2151a9014e9a2664cf0a4dfe397b8f16144d0386ed7dd5641fa";
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: appId,
        appSign: appSign,
        userID: localUserID,
        userName: "user_$localUserID",
        callID: widget.roomId.toString(),
        config: widget.type == "Audio" ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall() : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..onOnlySelfInRoom = (context) {
            Navigator.of(context).pop();
          },
      ),
    );
  }
}

