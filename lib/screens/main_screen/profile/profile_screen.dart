import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/screens/main_screen/profile/profile_service.dart';
import 'package:cusipco_doctor_app/services/main_navigaton_prowider_service.dart';

import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';
import 'package:cusipco_doctor_app/widgets/appbar_widget.dart';
import 'package:cusipco_doctor_app/widgets/button_widget/button_outLine.dart';
import 'package:cusipco_doctor_app/widgets/button_widget/rounded_button_widget.dart';
import 'package:cusipco_doctor_app/widgets/text_boxes/text_box_with_sufix.dart';

import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class profileScreen extends StatefulWidget {
  profileScreen({Key? key}) : super(key: key);

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  TextEditingController _designationController = TextEditingController();
  TextEditingController _consultationChargeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;

  File? ImagePAth;

  bool _isEnable = true;
  String? _profileImage = "";
  final ImagePicker _picker = ImagePicker();

  bool isDoctor = false;
  // bool isTherapy = false;
  // time table variable declration

  List<SlotTime> times = [
    SlotTime(
        day: "Sunday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Monday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Tuesday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Wednesday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Thursday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Friday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Saturday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
  ];

  List<SlotTime> offlineTimes = [
    SlotTime(
        day: "Offline_Sunday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Offline_Monday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Offline_Tuesday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Offline_Wednesday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Offline_Thursday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Offline_Friday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
    SlotTime(
        day: "Offline_Saturday",
        isEnable: false,
        morningStartTime: "",
        eveningEndTime: "",
        eveningStartTime: "",
        morningEndTime: ""),
  ];
// --------------------  morning time ------------------

  _setToggleValue(String day, bool val, bool isOnline) {
    if (isOnline) {
      var list = times.where((element) => element.day == day).first;

      list.isEnable = val;
      var index = times.indexOf(list);
      setState(() {
        times[index] = list;
      });
    } else {
      var list = offlineTimes.where((element) => element.day == day).first;

      list.isEnable = val;
      var index = offlineTimes.indexOf(list);
      setState(() {
        offlineTimes[index] = list;
      });
    }
  }

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  takeImage(ImageSource imagesource) async {
    var pickedImage = await _picker.pickImage(source: imagesource);
    if (pickedImage != null) {
      ProfileService().cropImage(pickedImage, context);
    }
  }

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
                isShowRightIcon: true,
                onbackPress: () {
                  Provider.of<MainNavigationProwider>(context, listen: false)
                      .chaneIndexOfNavbar(0);
                },
                title: "My Profile",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: !isFirstSubmit
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeClass.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: ThemeClass.greyColor.withOpacity(0.2),
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                _buildCircleImage(),
                                SizedBox(
                                  height: 20,
                                ),
                                // _buildOnOFF(),
                                // SizedBox(
                                //   height: 20,
                                // ),
                                _buildTextTitle("Name"),
                                TextFiledWidget(
                                  backColor: ThemeClass.whiteDarkColor,
                                  hinttext: "Full Name",
                                  controllers: _nameController,
                                  icon: "assets/icons/user_icon.png",
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return GlobalVariableForShowMessage
                                              .EmptyErrorMessage +
                                          "Full Name";
                                    }
                                  },
                                ),
                                _buildTextTitle("Email Address"),
                                TextFiledWidget(
                                  hinttext: "Email Address",
                                  backColor: ThemeClass.whiteDarkColor,
                                  controllers: _emailController,
                                  isReadOnly: true,
                                  icon: "assets/icons/email_icon.png",
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return GlobalVariableForShowMessage
                                              .EmptyErrorMessage +
                                          "Email address";
                                    } else if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return GlobalVariableForShowMessage
                                          .pleasEenterVaildEmail;
                                    }
                                  },
                                ),
                                isDoctor
                                    ? _buildTextTitle("Designation")
                                    : SizedBox(),
                                isDoctor
                                    ? TextFiledWidget(
                                        backColor: ThemeClass.whiteDarkColor,
                                        hinttext: "Designation",
                                        controllers: _designationController,
                                        icon: "assets/icons/star_user.png",
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return GlobalVariableForShowMessage
                                                    .EmptyErrorMessage +
                                                "Designation";
                                          }
                                        },
                                      )
                                    : SizedBox(),
                                isDoctor
                                    ? _buildTextTitle("Consultation Charges")
                                    : SizedBox(),
                                isDoctor
                                    ? TextFiledWidget(
                                        backColor: ThemeClass.whiteDarkColor,
                                        hinttext: "Consultation Charges",
                                        controllers:
                                            _consultationChargeController,
                                        icon: "assets/icons/rupee_icon.png",
                                        isNumber: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return GlobalVariableForShowMessage
                                                    .EmptyErrorMessage +
                                                "Consultation Charges";
                                          }
                                        },
                                      )
                                    : SizedBox(),
                                _buildTextTitle("Phone Number"),
                                TextFiledWidget(
                                  backColor: ThemeClass.whiteDarkColor,
                                  hinttext: "Phone Number",
                                  controllers: _phoneController,
                                  icon: "assets/icons/telephone_icon.png",
                                  isNumber: true,
                                  isReadOnly: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return GlobalVariableForShowMessage
                                              .EmptyErrorMessage +
                                          "Phone Number";
                                    } else if (value.length != 10) {
                                      return GlobalVariableForShowMessage
                                          .phoneNumberinvalied;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isDoctor == true
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Online Slots",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                _buildTimeSlot(height, true),
                              ],
                            )
                          : _buildTimeSlot(height, true),
                      isDoctor == true
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Offline Slots",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                _buildTimeSlot(height, false),
                              ],
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 15),
                        child: _buildbottombottom(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildTimeSlot(double height, bool isOnline) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: height - 100,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              ProfileService().buildTimerHeader(),
              SizedBox(
                height: 10,
              ),
              isOnline == true
                  ? getList(times, true)
                  : getList(offlineTimes, false),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column getList(List<SlotTime> times, bool isOnline) {
    return Column(
        children: times
            .map(
              (e) => _buildTimerListvalue(
                day: e.day,
                isOnline: isOnline,
                isSelected: e.isEnable,
                morningStartTime:
                    e.morningStartTime == "" ? "Select" : e.morningStartTime,
                morningEndTime:
                    e.morningEndTime == "" ? "Select" : e.morningEndTime,
                eveningStartTime:
                    e.eveningStartTime == "" ? "Select" : e.eveningStartTime,
                eveningEndTime:
                    e.eveningEndTime == "" ? "Select" : e.eveningEndTime,
              ),
            )
            .toList());
  }

  Padding _buildTimerListvalue({
    required String day,
    required bool isSelected,
    required bool isOnline,
    required String morningStartTime,
    required String morningEndTime,
    required String eveningStartTime,
    required String eveningEndTime,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 0, right: 10),
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    toggleSize: 17.0,
                    value: isSelected,
                    borderRadius: 20.0,
                    padding: 3,
                    activeColor: ThemeClass.blueColor,
                    inactiveColor: ThemeClass.greyLightColor,
                    showOnOff: false,
                    onToggle: (val) {
                      _setToggleValue(day, val, isOnline);
                    },
                  ),
                ),
                Expanded(
                  child: Text(day.replaceAll("Offline_", ""),
                      style: TextStyle(
                          color: ThemeClass.greyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(" : ",
                style: TextStyle(
                    color: ThemeClass.greyColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () async {
                if (isSelected == true) {
                  // Morning start  Slot

                  if (morningStartTime == "Select") {
                    _selectOpeningAndClosingTime(context,
                        day: day,
                        isStart: true,
                        isMorning: true,
                        isOnline: isOnline);
                  } else {
                    var value = await showAlertDialog(context);
                    if (value == true) {
                      _selectOpeningAndClosingTime(context,
                          day: day,
                          isStart: true,
                          isMorning: true,
                          isOnline: isOnline);
                    } else if (value == false) {
                      _disSelectSlot(context,
                          day: day,
                          isStart: true,
                          isMorning: true,
                          isOnline: isOnline);
                    }
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeClass.whiteDarkColor,
                  border: Border.all(
                      color: isSelected == true
                          ? ThemeClass.greyColor
                          : ThemeClass.greyColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                      child: Text(morningStartTime,
                          style: TextStyle(
                              letterSpacing: 1,
                              color: ThemeClass.greyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500))),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  // Morning end  Slot

                  if (isSelected == true) {
                    if (morningEndTime == "Select") {
                      _selectOpeningAndClosingTime(context,
                          day: day,
                          isStart: false,
                          isMorning: true,
                          isOnline: isOnline);
                    } else {
                      var value = await showAlertDialog(context);
                      if (value == true) {
                        _selectOpeningAndClosingTime(context,
                            day: day,
                            isStart: false,
                            isMorning: true,
                            isOnline: isOnline);
                      } else if (value == false) {
                        _disSelectSlot(context,
                            day: day,
                            isStart: false,
                            isMorning: true,
                            isOnline: isOnline);
                      }
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeClass.whiteDarkColor,
                    border: Border.all(
                        color: isSelected == true
                            ? ThemeClass.greyColor
                            : ThemeClass.greyColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                        child: Text(morningEndTime,
                            style: TextStyle(
                                letterSpacing: 1,
                                color: ThemeClass.greyColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500))),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text("  ",
                style: TextStyle(
                    color: ThemeClass.greyColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  // Evening Start  Slot

                  if (isSelected == true) {
                    if (eveningStartTime == "Select") {
                      _selectOpeningAndClosingTime(context,
                          day: day,
                          isStart: true,
                          isMorning: false,
                          isOnline: isOnline);
                    } else {
                      var value = await showAlertDialog(context);
                      if (value == true) {
                        _selectOpeningAndClosingTime(context,
                            day: day,
                            isStart: true,
                            isMorning: false,
                            isOnline: isOnline);
                      } else if (value == false) {
                        _disSelectSlot(context,
                            day: day,
                            isStart: true,
                            isMorning: false,
                            isOnline: isOnline);
                      }
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeClass.whiteDarkColor,
                    border: Border.all(
                        color: isSelected == true
                            ? ThemeClass.greyColor
                            : ThemeClass.greyColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                        child: Text(eveningStartTime,
                            style: TextStyle(
                                letterSpacing: 1,
                                color: ThemeClass.greyColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500))),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () async {
                  // Evening End Slot

                  if (isSelected == true) {
                    if (eveningEndTime == "Select") {
                      _selectOpeningAndClosingTime(context,
                          day: day,
                          isStart: false,
                          isMorning: false,
                          isOnline: isOnline);
                    } else {
                      var value = await showAlertDialog(context);
                      if (value == true) {
                        _selectOpeningAndClosingTime(context,
                            day: day,
                            isStart: false,
                            isMorning: false,
                            isOnline: isOnline);
                      } else if (value == false) {
                        _disSelectSlot(context,
                            day: day,
                            isStart: false,
                            isMorning: false,
                            isOnline: isOnline);
                      }
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeClass.whiteDarkColor,
                    border: Border.all(
                        color: isSelected == true
                            ? ThemeClass.greyColor
                            : ThemeClass.greyColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                        child: Text(eveningEndTime,
                            style: TextStyle(
                                letterSpacing: 1,
                                color: ThemeClass.greyColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500))),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildOnOFF() {
    return Container(
      child: Consumer<UserPrefService>(builder: (context, userProwider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Offline",
              style: TextStyle(color: ThemeClass.blackColor),
            ),
            buildIOSSwitch(
              userProwider.globleUserModel!.data!.isAvailable.toString() == "1",
              (value) {
                try {
                  userProwider.updateUserStatus(value == true ? "1" : "0");
                } catch (e) {
                  showToast(e.toString());
                }
              },
            ),
            Text("Online"),
          ],
        );
      }),
    );
  }

  _updateUserAllData() {
    var userprovider = Provider.of<UserPrefService>(context, listen: false);
    Map<String, String> queryParameters = {
      "name": _nameController.text,
    };
    print(times);

    try {
      // check validation for online slot
      times.forEach((e) {
        if (e.isEnable) {
          if (e.morningStartTime == "" &&
              e.morningEndTime == "" &&
              e.eveningStartTime == "" &&
              e.eveningEndTime == "") {
            validation("Please Select ${e.day}'s Slot");
            return;
          }

          if (!(e.morningStartTime == "" && e.morningEndTime == "")) {
            if (e.morningStartTime == "") {
              validation("Please Select ${e.day}'s morning start time");
              return;
            } else if (e.morningEndTime == "") {
              validation("Please Select ${e.day}'s morning end time");
              return;
            }
          }

          if (!(e.eveningStartTime == "" && e.eveningEndTime == "")) {
            if (e.eveningStartTime == "") {
              validation("Please Select ${e.day}'s evening start time");
              return;
            } else if (e.eveningEndTime == "") {
              validation("Please Select ${e.day}'s evening end time");
              return;
            }
          }

          String sendData = "";

          if (e.morningStartTime != "" && e.morningEndTime != "") {
            sendData = e.morningStartTime + "|" + e.morningEndTime;
          }

          sendData += ",";

          if (e.eveningStartTime != "" && e.eveningStartTime != "") {
            sendData += e.eveningStartTime + "|" + e.eveningEndTime;
          }

          queryParameters.addAll({e.day: sendData});
        } else {
          queryParameters.addAll({e.day: ""});
        }
      });

      if (isDoctor == true) {
        offlineTimes.forEach((e) {
          if (e.isEnable) {
            if (e.morningStartTime == "" &&
                e.morningEndTime == "" &&
                e.eveningStartTime == "" &&
                e.eveningEndTime == "") {
              validation(
                  "Please Select ${e.day.replaceAll("Offline_", "")}'s Offline Slot");
              return;
            }

            if (!(e.morningStartTime == "" && e.morningEndTime == "")) {
              if (e.morningStartTime == "") {
                validation(
                    "Please Select ${e.day.replaceAll("Offline_", "")}'s morning Offline start time");
                return;
              } else if (e.morningEndTime == "") {
                validation(
                    "Please Select ${e.day.replaceAll("Offline_", "")}'s morning Offline end time");
                return;
              }
            }

            if (!(e.eveningStartTime == "" && e.eveningEndTime == "")) {
              if (e.eveningStartTime == "") {
                validation(
                    "Please Select ${e.day.replaceAll("Offline_", "")}'s evening Offline start time");
                return;
              } else if (e.eveningEndTime == "") {
                validation(
                    "Please Select ${e.day.replaceAll("Offline_", "")}'s evening Offline end time");
                return;
              }
            }

            String sendData = "";

            if (e.morningStartTime != "" && e.morningEndTime != "") {
              sendData = e.morningStartTime + "|" + e.morningEndTime;
            }

            sendData += ",";

            if (e.eveningStartTime != "" && e.eveningStartTime != "") {
              sendData += e.eveningStartTime + "|" + e.eveningEndTime;
            }

            queryParameters.addAll({e.day: sendData});
          } else {
            queryParameters.addAll({e.day: ""});
          }
        });
      }

      print("----------------------donee");
      var userprovider = Provider.of<UserPrefService>(context, listen: false);

      if (isDoctor) {
        queryParameters.addAll({
          "designation": _designationController.text,
          "consultation_charges": _consultationChargeController.text,
        });
      }
      print(queryParameters);

      userprovider.updateUserAllData(queryParameters);
    } catch (e) {
      showToast(e.toString());
    }
  }

  validation(msg) {
    throw msg;
  }

  _disSelectSlot(
    BuildContext context, {
    required String day,
    required bool isStart,
    required bool isMorning,
    required bool isOnline,
  }) {
    if (isOnline) {
      // for online
      var list = times.where((element) => element.day == day).first;

      var timeToStore = "";

      if (isMorning) {
        list.morningStartTime = timeToStore;
      } else {
        list.eveningStartTime = timeToStore;
      }

      if (isMorning) {
        list.morningEndTime = timeToStore;
      } else {
        list.eveningEndTime = timeToStore;
      }

      var index = times.indexOf(list);

      setState(() {
        times[index] = list;
      });
    } else {
      // for offline
      var list = offlineTimes.where((element) => element.day == day).first;

      var timeToStore = "";

      if (isMorning) {
        list.morningStartTime = timeToStore;
      } else {
        list.eveningStartTime = timeToStore;
      }

      if (isMorning) {
        list.morningEndTime = timeToStore;
      } else {
        list.eveningEndTime = timeToStore;
      }

      var index = offlineTimes.indexOf(list);

      setState(() {
        offlineTimes[index] = list;
      });
    }
  }

  Row _buildbottombottom() {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
              fontSize: 14,
              title: "Update Profile",
              heightPadding: 10,
              isLoading: false,
              color: ThemeClass.blueColor,
              callBack: () async {
                _updateUserAllData();
              }),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: OutlineButtonWidget(
              fontSize: 14,
              title: "Logout",
              heightPadding: 10,
              isLoading: false,
              color: ThemeClass.blueColor,
              callBack: () async {
                var res = await showAlertDialogLogout(context);
                if (res == true) {
                  _logout();
                }
              }),
        )
      ],
    );
  }

  Future<void> _selectOpeningAndClosingTime(
    BuildContext context, {
    required String day,
    required bool isStart,
    required bool isOnline,
    required bool isMorning,
  }) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: ThemeClass.blueColor, // <-- SEE HERE
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: ThemeClass.blueColor, // button text color
                  ),
                ),
              ),
              child: child!,
            ));
      },
    );

    if (isOnline) {
      //  for online

      if (pickedTime != null && pickedTime != TimeOfDay.now()) {
        var list = times.where((element) => element.day == day).first;

        var timeToStore =
            "${pickedTime.hour.toString().length > 1 ? pickedTime.hour : "0" + pickedTime.hour.toString()}:${pickedTime.minute.toString().length > 1 ? pickedTime.minute : "0" + pickedTime.minute.toString()}";

        if (isStart) {
          if (isMorning) {
            list.morningStartTime = timeToStore;
          } else {
            list.eveningStartTime = timeToStore;
          }
        } else {
          if (isMorning) {
            list.morningEndTime = timeToStore;
          } else {
            list.eveningEndTime = timeToStore;
          }
        }

        var index = times.indexOf(list);

        setState(() {
          times[index] = list;
        });
      }
    } else {
      //  for off online
      if (pickedTime != null && pickedTime != TimeOfDay.now()) {
        var list = offlineTimes.where((element) => element.day == day).first;

        var timeToStore =
            "${pickedTime.hour.toString().length > 1 ? pickedTime.hour : "0" + pickedTime.hour.toString()}:${pickedTime.minute.toString().length > 1 ? pickedTime.minute : "0" + pickedTime.minute.toString()}";

        if (isStart) {
          if (isMorning) {
            list.morningStartTime = timeToStore;
          } else {
            list.eveningStartTime = timeToStore;
          }
        } else {
          if (isMorning) {
            list.morningEndTime = timeToStore;
          } else {
            list.eveningEndTime = timeToStore;
          }
        }

        var index = offlineTimes.indexOf(list);

        setState(() {
          offlineTimes[index] = list;
        });
      }
    }
  }

  Center _buildCircleImage() {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(400.0),
              child: ImagePAth != null
                  ? Image.file(
                      File(
                        ImagePAth!.path,
                      ),
                      fit: BoxFit.cover,
                    )
                  : Consumer<UserPrefService>(
                      builder: (context, userProwider, child) {
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        errorWidget: (cn, tx, sd) {
                          return Center(
                            child: Icon(Icons.network_wifi_rounded),
                          );
                        },
                        imageUrl: userProwider
                            .globleUserModel!.data!.profileImage
                            .toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: InkWell(
                onTap: () {
                  _showImagePicker(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: ThemeClass.blueColor, shape: BoxShape.circle),
                  height: 30,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 15,
                  ),
                  width: 30,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _buildTextTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 15, left: 15),
      child: Text(
        title,
        style: TextStyle(fontSize: 10, color: ThemeClass.greyDarkColor),
      ),
    );
  }

  void _showImagePicker(
    context,
  ) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: ThemeClass.blueColor,
                      ),
                      title: Text('Photo Library'),
                      onTap: () {
                        takeImage(
                          ImageSource.gallery,
                        );

                        Navigator.of(bc).pop();
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: ThemeClass.blueColor,
                    ),
                    title: Text('Camera'),
                    onTap: () {
                      takeImage(
                        ImageSource.camera,
                      );
                      Navigator.of(bc).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _logout() async {
    var userProv = Provider.of<UserPrefService>(context, listen: false);
    try {
      userProv.logout();
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonWidget(
                title: "Update Slot",
                callBack: () {
                  Navigator.pop(context1, true);
                },
                color: ThemeClass.greenColor,
              ),
              SizedBox(
                height: 10,
              ),
              ButtonWidget(
                title: "Disable Slot",
                callBack: () {
                  Navigator.pop(context1, false);
                },
                color: ThemeClass.redColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Future showAlertDialogLogout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text('Confirmation.'),
          content: Text('Are you sure to Logout?'),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context1, false);
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context1, true);
              },
            )
          ],
        );
      },
    );
  }

  _initializeData() {
    var userprovider = Provider.of<UserPrefService>(context, listen: false);
    _nameController.text = userprovider.globleUserModel!.data!.name.toString();
    _emailController.text =
        userprovider.globleUserModel!.data!.email.toString();

    _phoneController.text =
        userprovider.globleUserModel!.data!.phoneNumber.toString();

    _designationController.text =
        userprovider.globleUserModel!.data!.designation.toString();

    _consultationChargeController.text =
        userprovider.globleUserModel!.data!.consultationCharges.toString();

    _profileImage = userprovider.globleUserModel!.data!.profileImage.toString();

    isDoctor =
        userprovider.globleUserModel!.data!.userType == "Doctor" ? true : false;

    // isTherapy = userprovider.globleUserModel!.data!.userType == "Therapy"
    //     ? true
    //     : false;

    //  for online

    List<DayTimeSlot> timeList = userprovider.globleUserModel!.data!.timings!
        .toJson()
        .entries
        .map((entry) {
      if (entry.value == null) {
        return DayTimeSlot(
          day: entry.key,
          isEmpty: entry.value == null,
        );
      } else {
        if (entry.value['start_time'].toString() == "" &&
            entry.value['end_time'].toString() == "" &&
            entry.value['start_time_2'].toString() == "" &&
            entry.value['end_time_2'].toString() == "") {
          return DayTimeSlot(
            day: entry.key,
            isEmpty: true,
          );
        } else {
          return DayTimeSlot(
            day: entry.key,
            isEmpty: false,
            morningStartTime: entry.value['start_time'].toString(),
            morningEndTime: entry.value['end_time'].toString(),
            eveningStartTime: entry.value['start_time_2'].toString(),
            eveningEndTime: entry.value['end_time_2'].toString(),
          );
        }
      }
    }).toList();

    timeList.forEach((item) {
      if (!item.isEmpty) {
        var list = times.where((element) => element.day == item.day).first;
        list.isEnable = true;
        list.morningStartTime = item.morningStartTime;
        list.morningEndTime = item.morningEndTime;
        list.eveningStartTime = item.eveningStartTime;
        list.eveningEndTime = item.eveningEndTime;

        var index = times.indexOf(list);
        setState(() {
          times[index] = list;
        });
      }
    });

    if (isDoctor == true) {
      //  check condition for offline
      List<DayTimeSlot> timeList2 = userprovider
          .globleUserModel!.data!.timingsOffline!
          .toJson()
          .entries
          .map((entry) {
        if (entry.value == null) {
          return DayTimeSlot(
            day: entry.key,
            isEmpty: entry.value == null,
          );
        } else {
          if (entry.value['start_time'].toString() == "" &&
              entry.value['end_time'].toString() == "" &&
              entry.value['start_time_2'].toString() == "" &&
              entry.value['end_time_2'].toString() == "") {
            return DayTimeSlot(
              day: entry.key,
              isEmpty: true,
            );
          } else {
            return DayTimeSlot(
              day: entry.key,
              isEmpty: false,
              morningStartTime: entry.value['start_time'].toString(),
              morningEndTime: entry.value['end_time'].toString(),
              eveningStartTime: entry.value['start_time_2'].toString(),
              eveningEndTime: entry.value['end_time_2'].toString(),
            );
          }
        }
      }).toList();

      timeList2.forEach((item) {
        if (!item.isEmpty) {
          var list = times.where((element) => element.day == item.day).first;
          list.isEnable = true;
          list.morningStartTime = item.morningStartTime;
          list.morningEndTime = item.morningEndTime;
          list.eveningStartTime = item.eveningStartTime;
          list.eveningEndTime = item.eveningEndTime;

          var index = times.indexOf(list);
          setState(() {
            offlineTimes[index] = list;
          });
        }
      });
    }

    setState(() {});
  }
}

class SlotTime {
  SlotTime({
    required this.isEnable,
    required this.day,
    required this.morningStartTime,
    required this.morningEndTime,
    required this.eveningStartTime,
    required this.eveningEndTime,
  });

  bool isEnable;
  String day;
  String morningStartTime;
  String morningEndTime;
  String eveningStartTime;
  String eveningEndTime;
}

class DayTimeSlot {
  DayTimeSlot({
    required this.day,
    required this.isEmpty,
    this.morningStartTime = "",
    this.morningEndTime = "",
    this.eveningStartTime = "",
    this.eveningEndTime = "",
  });

  bool isEmpty;
  String day;
  String morningStartTime;
  String morningEndTime;
  String eveningStartTime;
  String eveningEndTime;
}
