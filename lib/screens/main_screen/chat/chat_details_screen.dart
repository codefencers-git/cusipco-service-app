import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusipco_doctor_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/widgets/appbar_widget.dart';
import '../../../services/http_service.dart';
import '../../../services/provider_service/user_preference_service.dart';
import 'AgoraTokenModel.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String? chatPersonId;
  final String? chatPersonImage;
  final String? chatPersonName;
  final UserModel? userDetails;
  final String? drname;
  final QueryDocumentSnapshot<Object?>? doc;

  ChatDetailsScreen(
      {Key? key, this.chatPersonId, this.chatPersonImage, this.chatPersonName, this.userDetails, this.doc, this.drname})
      : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var messageInputController = TextEditingController();
    final db = FirebaseFirestore.instance;
    var temp =  UserPrefService.preferences!.getString("userModelDoctor");
    var userDetails = UserModel.fromJson(jsonDecode(temp.toString()));
    var myUserId= userDetails.data!.id.toString();
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(65.0),
                child: AppBarWithTextAndBackWidget(
                  audiovideo: true,
                  isShowBack: true,
                  isShowRightIcon: true,
                  userId: widget.chatPersonId,
                  onbackPress: () {
                    Navigator.pop(context);
                    // Provider.of<MainNavigationProwider>(context, listen: false)
                    //     .chaneIndexOfNavbar(0);
                  },
                  title: widget.drname.toString(),
                  // title: "suraj",
                )),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    // stream: db
                    //     .collection('bucket_$myUserId')
                    // .orderBy('sent_time', descending: true)
                    //     .snapshots(),

                    stream: FirebaseFirestore.instance.collection('chatList').doc("bucket_${myUserId+widget.chatPersonId.toString()}").collection('chat').orderBy('sent_time', descending: true).snapshots(),

                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          physics: BouncingScrollPhysics(),
                            reverse: true,
                            children: snapshot.data!.docs.map((doc) {
                              return Container(
                                  padding: EdgeInsets.only(
                                      left: 14, right: 14, top: 10, bottom: 10),
                                  child: Align(
                                    alignment: (doc["receiver"] ==
                                            "$myUserId"
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (doc["sender"] ==
                                            widget.chatPersonId.toString()
                                            ? Colors.grey.shade200
                                            : Colors.blue[200]),
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        doc["message"],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ));
                            }).toList());
                      }
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageInputController,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              sendMessage(
                                  messageInputController.text,
                                  widget.chatPersonId.toString(),
                                  myUserId,
                                  widget.chatPersonId.toString(),
                                  userDetails.data!.profileImage.toString(),
                                  userDetails.data!.name.toString(),
                              );
                              messageInputController.clear();
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.blue,
                            ))
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}

void sendMessage(String message, String userId, String myId, String receiverId, dr_profileImage, dr_name) {
  String currentTimestamp = DateTime.now().toString();
  Map<String, dynamic> messageRow = {
    "sender": myId,
    "sent_time": currentTimestamp,
    "receiver": receiverId,
    "type": "sender",
    "message": message
  };

  // FirebaseFirestore.instance
  //     .collection("bucket_$myId")
  //     .doc(currentTimestamp)
  //     .set(messageRow);

  FirebaseFirestore.instance.collection('chatList').doc("bucket_${myId+receiverId}").collection('chat')
  .doc(currentTimestamp).set(messageRow);

  FirebaseFirestore.instance.collection('chatList').doc("bucket_${myId+receiverId}").update({
    "dr_profileimage" : dr_profileImage,
    "dr_name": dr_name,
    "dr_senderid" : myId,
    "dr_receiverid" : receiverId,
    "client_receiverid" : myId,
    "client_senderid" : receiverId,
  });
}



