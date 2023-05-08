import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CallingScreen extends StatefulWidget {
  String? channelName;
  String? token;
  bool? isCaller;
  String? drname;

  CallingScreen({
    Key? key,
    this.channelName,
    this.token,
    this.isCaller,
    this.drname,
  }) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {

  String appId = "8ca89082cb3f4b1ba9342d0d9e1389de";

  Widget body = Container();
  bool _localUserJoined = false;
  bool remoteUserJoined = false;
  bool _showStats = false;
  int? _remoteUid;

  // Timer for call (when 40 seconds pass then the user is not responding)
  Timer? callingTimer;
  int callingTimerStart = 40;

  // Timer for call duration (to show the seconds on the screen)
  Timer? callTimeTimer;
  int callTimeTimerStart = 0;

  bool micMuted = false;
  bool camOn = true;

  bool userDeclinedCall = false;


  // Duration counter for the call
  startTimerForCall() {
    const oneSec = Duration(seconds: 1);
    setState(() {
      callingTimerStart = 40;
    });
    callingTimer = Timer.periodic(oneSec, (timer) {
      if (callingTimerStart == 0) {
        setState(() {
          callingTimer!.cancel();
        });
        endCallForCaller();
      } else {
        setState(() {
          callingTimerStart--;
        });
      }
    });
  }

  // End call for the person who called
  endCallForCaller() async {
    Navigator.of(context).pop();
  }

  // Join call requested by other user
  joinCall(String? channelName) async {
    // Get agora token from the server for the requested channel name
    // var tokenRes = await http.get(Uri.parse(
    //   Utils.agoraTokenServerUrl + "?channelName=" + channelName!,
    // ));
    //
    // // Read the token from json response
    // var token = jsonDecode(tokenRes.body);

    // Go to calling screen to call with the current channel name to join other user in the agora channel
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CallingScreen(
            channelName: channelName,
            token: widget.token,
            // User is not caller so he joins channel not create it
            isCaller: false,
          );
        },
      ),
    );
  }


  // Format call time to display it on the screen
  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: [
            body,
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    remoteUserJoined
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "${formatTime(callTimeTimerStart)}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        remoteUserJoined
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10)),
                              backgroundColor: MaterialStateProperty.all(
                                  !micMuted
                                      ? Colors.black.withOpacity(0.5)
                                      : Colors
                                      .black87), // <-- Button color
                              overlayColor: MaterialStateProperty
                                  .resolveWith<Color?>((states) {
                                if (states
                                    .contains(MaterialState.pressed))
                                  return Colors.red; // <-- Splash color
                              }),
                            ),
                            onPressed: () async {
                              setState(() {
                                micMuted = !micMuted;
                              });

                            },
                            child: micMuted
                                ? const Icon(
                              Icons.mic_off,
                              size: 25,
                            )
                                : const Icon(
                              Icons.mic,
                              size: 25,
                            ),
                          ),
                        )
                            : Container(),
                        remoteUserJoined
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(15)),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.red), // <-- Button color
                              overlayColor: MaterialStateProperty
                                  .resolveWith<Color?>((states) {
                                if (states
                                    .contains(MaterialState.pressed)) {
                                  return Colors.red;
                                } // <-- Splash color
                              }),
                            ),
                            onPressed: () async {


                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.call_end,
                              size: 35,
                            ),
                          ),
                        )
                            : Container(),
                        remoteUserJoined
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const CircleBorder()),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10)),
                              backgroundColor: MaterialStateProperty.all(
                                  camOn
                                      ? Colors.black.withOpacity(0.5)
                                      : Colors
                                      .black87), // <-- Button color
                              overlayColor: MaterialStateProperty
                                  .resolveWith<Color?>((states) {
                                if (states
                                    .contains(MaterialState.pressed)) {
                                  return Colors.red;
                                } // <-- Splash color
                              }),
                            ),
                            onPressed: () async {
                              setState(() {
                                camOn = !camOn;
                              });


                            },
                            child: camOn
                                ? const Icon(
                              Icons.videocam,
                              size: 25,
                            )
                                : const Icon(
                              Icons.videocam_off,
                              size: 25,
                            ),
                          ),
                        )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: remoteUserJoined
            ? Container()
            : FloatingActionButton(
          onPressed: () async {
            // TODO: end call here


            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  // Data for request for called person
  static String constructFCMPayload(
      String token, String callername, String channelName) {
    var res = jsonEncode({
      "token": token,
      "notification": {
        "body": "You have a new call from ${callername}.",
        "title": "New Call"
      },
      "priority": "high",
      "data": {
        "status": "done",
        "channel_name": channelName,
        "callerName": callername,
      },
      'to': token,
    });

    print(res.toString());
    return res;
  }



  // Send notification to called person to let him know that there's a call
  sendNotificationToCalledPerson(
      String token, context, String callerEmail) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer AAAA-cWh2ac:APA91bEUC-7CJ46h4SsRBgsfWhUatE0BdlzVQcX3TR-GFeE5OfyjhYgfG09NIbdlyxYwD3kxDKq3Ly-6RiFZBtHm8Hf8fb0dNz4qQGD7_WOIf9pvDljVhPvG5ViFdLh9SofpjG6qI405",
        },
        body: constructFCMPayload(token, callerEmail, widget.channelName!),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

}
