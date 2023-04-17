import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/models/appointment_detail_model.dart';
import 'package:cusipco_doctor_app/services/provider_service/appointment_details_service.dart';
import 'package:cusipco_doctor_app/widgets/alert_dialog_for_OTP_varification.dart';

import 'package:cusipco_doctor_app/widgets/alert_dialog_for_add_notes.dart';
import 'package:cusipco_doctor_app/widgets/appbar_widget.dart';
import 'package:cusipco_doctor_app/widgets/button_widget/rounded_button_widget.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  AppointmentDetailsScreen({Key? key, required this.appoingmentID})
      : super(key: key);
  String appoingmentID;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  var _futureCall;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    // _futureCall = AppointmentDetailService().getAppointmentDetails();

    checkAppUpdate(context, isShowNormalAlert: false);
    _reloadData();
  }

  _reloadData() {
    setState(() {
      _futureCall = AppointmentDetailService()
          .getAppointmentDetails(widget.appoingmentID);
    });
  }

  takeImage(ImageSource imagesource) async {
    var pickedImage =
        await _picker.pickImage(source: imagesource, imageQuality: 60);
    if (pickedImage != null) {
      var res = await AppointmentDetailService().uploadDocument(
          File(pickedImage.path),
          url: "update-appointment",
          perameterName: "prescription",
          extraPerameter: {"item_id": widget.appoingmentID});

      if (res == true) {
        _reloadData();
      }
    }
  }

  getFilepicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
    );
    if (result != null) {
      print(result.files.first.path);
      var res = await AppointmentDetailService().uploadDocument(
          File(result.files.first.path.toString()),
          url: "update-appointment",
          perameterName: "prescription",
          extraPerameter: {"item_id": widget.appoingmentID});

      if (res == true) {
        _reloadData();
      }
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
                isShowRightIcon: false,
                onbackPress: () {
                  Navigator.pop(context);
                },
                title: "Appointments Details",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: FutureBuilder(
                future: _futureCall,
                builder:
                    (context, AsyncSnapshot<AppointmentDetailData?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return _buildView(snapshot.data);
                      } else {
                        return _buildDataNotFound1("Data Not Found!");
                      }
                    } else if (snapshot.hasError) {
                      return _buildDataNotFound1(snapshot.error.toString());
                    } else {
                      return _buildDataNotFound1("Data Not Found!");
                    }
                  } else {
                    return Container(
                      padding:
                          EdgeInsets.only(top: height / 3, bottom: height / 3),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ThemeClass.blueColor,
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Center _buildDataNotFound1(
    String text,
  ) {
    return Center(child: Text("$text"));
  }

  Stack _buildView(AppointmentDetailData? appointmentDetails) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppointmentData(appointmentDetails),
                _buildPatientInformation(appointmentDetails!.userDetails),
                appointmentDetails.status == "Accepted" ||
                        appointmentDetails.status == "Completed" ||
                        appointmentDetails.status == "AppointmentStart" ||
                        appointmentDetails.status == "AppointmentEnd"
                    ? _buildNotes(appointmentDetails)
                    : SizedBox(),
                appointmentDetails.module.toString() == "Doctor" &&
                        (appointmentDetails.status == "Accepted" ||
                            appointmentDetails.status == "AppointmentStart" ||
                            appointmentDetails.status == "AppointmentEnd")
                    ? _buildPrescriptionUpload(appointmentDetails)
                    : SizedBox(),

                // _buildPrescriptionUpload(appointmentDetails),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),

        // Start AppointMent button
        appointmentDetails.status == "Accepted"
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  child: ButtonWidget(
                      title: "Start Appointment",
                      radius: 10,
                      fontSize: 16,
                      color: ThemeClass.blueColor,
                      callBack: () async {
                        var res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogForOTPVafication(
                              appointmentDetails: appointmentDetails,
                              status: "AppointmentStart",
                            );
                          },
                        );

                        if (res == true) {
                          _reloadData();
                        }
                      }),
                ),
              )
            : SizedBox(),

        // End AppointMent button
        appointmentDetails.status == "AppointmentStart"
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  child: ButtonWidget(
                      title: "End Appointment",
                      radius: 10,
                      fontSize: 16,
                      color: ThemeClass.blueColor,
                      callBack: () async {
                        var res = await AppointmentDetailService()
                            .updateAppointmentDetails(
                                id: appointmentDetails.id.toString(),
                                status: "AppointmentEnd");

                        if (res == true) {
                          _reloadData();
                        }
                      }),
                ),
              )
            : SizedBox(),

        appointmentDetails.status == "AppointmentEnd"
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  child: ButtonWidget(
                      title: "Mark as Complete",
                      radius: 10,
                      fontSize: 16,
                      color: ThemeClass.blueColor,
                      callBack: () async {
                        if (appointmentDetails.module.toString() == "Doctor" &&
                            appointmentDetails.prescription == "") {
                          showToast("Please Upload Document");
                        } else {
                          var res = await AppointmentDetailService()
                              .updateAppointmentDetails(
                                  id: appointmentDetails.id.toString(),
                                  status: "Completed");

                          if (res == true) {
                            _reloadData();
                          }
                        }
                      }),
                ),
              )
            : SizedBox()
      ],
    );
  }

  _buildPrescriptionUpload(AppointmentDetailData? appointmentDetails) {
    if (appointmentDetails!.prescription != "") {
      return Center(
        child: Container(
          child: Text(
            "Prescription Uploaded",
            style: TextStyle(color: ThemeClass.greenColor),
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "Upload Document",
              style: TextStyle(fontSize: 10, color: ThemeClass.greyColor),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ThemeClass.blueColor),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      takeImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: ThemeClass.blueColor,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                              fontSize: 12, color: ThemeClass.blackColor),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  height: 80,
                  child: VerticalDivider(
                    color: ThemeClass.blueColor,
                    width: 5,
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getFilepicker();
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: ThemeClass.blueColor,
                        ),
                        Text(
                          "Upload",
                          style: TextStyle(
                              fontSize: 12, color: ThemeClass.blackColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  _buildNotes(AppointmentDetailData? appointmentDetails) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: ThemeClass.blueColorlight3,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notes",
                style: TextStyle(
                    color: ThemeClass.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              appointmentDetails!.notes == "" &&
                      (appointmentDetails.status == "Accepted" ||
                          appointmentDetails.status == "AppointmentStart" ||
                          appointmentDetails.status == "AppointmentEnd")
                  ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: ThemeClass.blueColor),
                      child: IconButton(
                          onPressed: () async {
                            showAlertDialog(
                                context, "notes", appointmentDetails);
                          },
                          icon: Icon(
                            Icons.add,
                            size: 18,
                            color: ThemeClass.whiteColor,
                          ),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(0)),
                    )
                  : SizedBox()
            ],
          ),
          SizedBox(
            height: appointmentDetails.notes == "" ? 0 : 10,
          ),
          appointmentDetails.notes != ""
              ? Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    appointmentDetails.notes.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String isfornotes,
      AppointmentDetailData? appointmentDetails) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogForAddNotesMeeting(
          isfor: isfornotes,
          appointmentDetails: appointmentDetails,
        );
      },
    );

    if (res == true) {
      _reloadData();
    }
  }

  Container _buildPatientInformation(UserDetails? userDetails) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: ThemeClass.blueColorlight3,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient Information",
            style: TextStyle(
                color: ThemeClass.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 15,
          ),
          _buildPatientInformationFirstRow(
              title: "Name",
              value: userDetails!.name.toString(),
              title1: "DOB",
              value1:
                  convertYYYY_MM_DDtoDD_MM_YYYY(userDetails.dob.toString())),
          Container(
            color: ThemeClass.whiteColor.withOpacity(0.4),
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 1.5,
          ),
          _buildPatientInformationFirstRow(
              title: "Age",
              value: userDetails.age.toString(),
              title1: "Gender",
              value1: userDetails.gender.toString()),
          Container(
            color: ThemeClass.whiteColor.withOpacity(0.4),
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, bottom: 5),
            height: 1.5,
          ),
        ],
      ),
    );
  }

  Row _buildPatientInformationFirstRow(
      {required String title,
      required String title1,
      required String value,
      required String value1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 3,
              ),
              Text(value,
                  style: TextStyle(
                      color: ThemeClass.blueColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title1,
                    style: TextStyle(
                        color: ThemeClass.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                SizedBox(
                  height: 3,
                ),
                Text(value1,
                    style: TextStyle(
                        color: ThemeClass.blueColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _buildAppointmentData(AppointmentDetailData? appointmentDetails) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: ThemeClass.blueColorlight3,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildFirstRowOfCart(appointmentDetails),
          ),
          Container(
            color: ThemeClass.whiteColor.withOpacity(0.4),
            width: double.infinity,
            height: 1.5,
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildSecondRowOfCart(appointmentDetails),
          ),
          appointmentDetails!.status == "Accepted" ||
                  appointmentDetails.status == "Completed" ||
                  appointmentDetails.status == "AppointmentStart" ||
                  appointmentDetails.status == "AppointmentEnd"
              ? _buildMeetingview(appointmentDetails)
              : SizedBox(),
        ],
      ),
    );
  }

  Padding _buildMeetingview(AppointmentDetailData? appointmentDetails) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Meeting URL",
                      style: TextStyle(
                          color: ThemeClass.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: 10,
                  ),
                  appointmentDetails!.meetingUrl.toString() == "" &&
                              appointmentDetails.status == "Accepted" ||
                          appointmentDetails.status == "AppointmentStart"
                      ? Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeClass.blueColor),
                          child: IconButton(
                              onPressed: () async {
                                showAlertDialog(
                                    context, "meeting", appointmentDetails);
                              },
                              icon: Icon(
                                Icons.add,
                                size: 18,
                                color: ThemeClass.whiteColor,
                              ),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(0)),
                        )
                      : SizedBox()
                ],
              ),
              appointmentDetails.meetingUrl.toString() != ""
                  ? InkWell(
                      onTap: () {},
                      child: Text(appointmentDetails.meetingUrl.toString(),
                          style: TextStyle(
                              color: ThemeClass.blueColor,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500)),
                    )
                  : SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  Row _buildSecondRowOfCart(AppointmentDetailData? appointmentDetails) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date",
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Text(getDateFormated(appointmentDetails!.date.toString()),
                  style: TextStyle(
                      color: ThemeClass.blueColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 7),
          color: ThemeClass.greyColor.withOpacity(0.2),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time",
                    style: TextStyle(
                        color: ThemeClass.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                Text(time24to12Format(appointmentDetails.time.toString()),
                    style: TextStyle(
                        color: ThemeClass.blueColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildFirstRowOfCart(AppointmentDetailData? appointmentDetails) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
              appointmentDetails!.image.toString(),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appointmentDetails.title.toString(),
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 3,
              ),
              Text(appointmentDetails.phoneNumber.toString(),
                  style: TextStyle(
                      color: ThemeClass.blueColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: appointmentDetails.status == "New"
              ? Column(
                  children: [
                    ButtonWidget(
                        title: "Accept",
                        color: ThemeClass.greenColor,
                        fontSize: 12,
                        heightPadding: 0,
                        radius: 5,
                        callBack: () async {
                          var res = await AppointmentDetailService()
                              .updateAppointmentDetails(
                                  id: appointmentDetails.id.toString(),
                                  status: "Accepted");

                          if (res == true) {
                            _reloadData();
                          }

                          // var res = await showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialogForOTPVafication(
                          //         appointmentDetails: appointmentDetails);
                          //   },
                          // );

                          // if (res == true) {
                          //   _reloadData();
                          // }

                          // AlertDialogForOTPVafication(
                          //     appointmentDetails: appointmentDetails);
                        }),
                    ButtonWidget(
                        title: "Decline",
                        color: ThemeClass.redColor,
                        fontSize: 12,
                        heightPadding: 0,
                        radius: 5,
                        callBack: () async {
                          var res = await AppointmentDetailService()
                              .updateAppointmentDetails(
                                  id: appointmentDetails.id.toString(),
                                  status: "Rejected");

                          if (res == true) {
                            _reloadData();
                          }
                        })
                  ],
                )
              : appointmentDetails.status == "Accepted" ||
                      appointmentDetails.status == "AppointmentStart" ||
                      appointmentDetails.status == "AppointmentEnd"
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          try {
                            if (!await launchUrl(Uri.parse(
                                "tel://${appointmentDetails.phoneNumber}")))
                              throw 'Could not launch ${appointmentDetails.phoneNumber}';
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: ThemeClass.whiteColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/icons/call_fill.png",
                              height: 30.0,
                              width: 30.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  : appointmentDetails.status == "Rejected" ||
                          appointmentDetails.status == "Completed"
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Text(appointmentDetails.status.toString(),
                              style: TextStyle(
                                  color: appointmentDetails.status == "Rejected"
                                      ? ThemeClass.redColor
                                      : ThemeClass.greenColor)),
                        )
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Text(appointmentDetails.status.toString())),
        )
      ],
    );
  }
}
