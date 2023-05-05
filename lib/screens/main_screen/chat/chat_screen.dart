import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusipco_doctor_app/api/firebase_api.dart';
import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/services/main_navigaton_prowider_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/general_info_service.dart';
import 'package:cusipco_doctor_app/widgets/appbar_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user_model.dart';
import 'chat_details_screen.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    print("---------------init state called of profile");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var temp =  UserPrefService.preferences!.getString("userModelDoctor");
    var userDetails = UserModel.fromJson(jsonDecode(temp.toString()));
    var myUserId= userDetails.data!.id.toString();
    final db = FirebaseFirestore.instance;
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
                isShowRightIcon: true,
                onbackPress: () {

                  Navigator.pop(context);

                  // Provider.of<MainNavigationProwider>(context, listen: false)
                  //     .chaneIndexOfNavbar(0);
                },
                title: "Chat with clients",
              )),
          body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('chatList').where('dr_senderid', isEqualTo: myUserId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {

                var snapshotdata = snapshot.data!.docs;
                print("snapshotdata.length ${snapshotdata.length}");

                return ListView.builder(
                    itemCount: snapshotdata.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: InkWell(
                            onTap: (){

                              pushNewScreen(context, screen: ChatDetailsScreen(userDetails: userDetails, chatPersonId: snapshotdata[index]['dr_receiverid'], drname: snapshotdata[index]['client_name']));

                              },
                            child: ListTile(
                              title: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                            NetworkImage("${snapshotdata[index]['client_profile']}"))),
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        snapshotdata[index]['client_name'],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Stack(
                                      children: <Widget>[
                                        new Icon(Icons.message),
                                        new Positioned(  // draw a red marble
                                          top: 0.0,
                                          right: 0.0,
                                          child: new Icon(Icons.brightness_1, size: 8.0,
                                              color: Colors.redAccent),
                                        )
                                      ]
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },);
              }
            },
          ),
        ),
      ),
    );
  }
}
