import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusipco_doctor_app/api/firebase_api.dart';
import 'package:cusipco_doctor_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/services/main_navigaton_prowider_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/general_info_service.dart';
import 'package:cusipco_doctor_app/widgets/appbar_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/provider_service/user_preference_service.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String? chatPersonId;
  final String? chatPersonImage;
  final String? chatPersonName;
  final UserModel? userDetails;
  final QueryDocumentSnapshot<Object?>? doc;
  ChatDetailsScreen(
      {Key? key, this.chatPersonId, this.chatPersonImage, this.chatPersonName, this.userDetails, this.doc})
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
                  isShowBack: true,
                  isShowRightIcon: true,
                  onbackPress: () {
                    Provider.of<MainNavigationProwider>(context, listen: false)
                        .chaneIndexOfNavbar(0);
                  },
                  title: widget.doc!["name"].toString(),
                )),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('bucket_$myUserId')
                    .orderBy('sent_time', descending: true)

                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
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
                              sendMessage(messageInputController.text,
                                  widget.chatPersonId.toString(), myUserId, widget.chatPersonId.toString());
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

void sendMessage(String message, String userId, String myId, String receiverId) {
  String currentTimestamp = DateTime.now().toString();
  Map<String, dynamic> messageRow = {
    "sender": myId,
    "sent_time": currentTimestamp,
    "receiver": receiverId,
    "type": "sender",
    "message": message
  };
  FirebaseFirestore.instance
      .collection("bucket_$myId")
      .doc(currentTimestamp)
      .set(messageRow);
}
