import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/appbar_widget.dart';

const String appId = "8ca89082cb3f4b1ba9342d0d9e1389de";

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key, required this.token, required this.channelName})
      : super(key: key);

  String token, channelName;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

int uid = 0; // uid of the local user

class _VideoScreenState extends State<VideoScreen> {
  late final AgoraClient client;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: appId,
        channelName: widget.channelName,
        tempToken: widget.token,
        uid: uid,
      ),
    );

    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(65.0),
            child: AppBarWithTextAndBackWidget(
              onbackPress: () {
                client.release();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              title: "Video Call",
            )),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                client: client,
                onDisconnect: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
