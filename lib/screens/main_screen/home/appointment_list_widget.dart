import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/models/appointment_list_model.dart';
import 'package:cusipco_doctor_app/screens/main_screen/home/appointment_details_screen.dart';
import 'package:cusipco_doctor_app/services/provider_service/appointment_details_service.dart';
import 'package:cusipco_doctor_app/widgets/button_widget/rounded_button_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AppointmentListWidget extends StatefulWidget {
  AppointmentListWidget({Key? key, required this.status}) : super(key: key);
  String status;
  @override
  State<AppointmentListWidget> createState() => _AppointmentListWidgetState();
}

class _AppointmentListWidgetState extends State<AppointmentListWidget> {
  var _futureCall;
  @override
  void initState() {
    super.initState();
    // _futureCall = AppointmentDetailService().getAppointmentDetails();
    _reloadData();
  }

  _reloadData() {
    setState(() {
      _futureCall = AppointmentDetailService()
          .getAppointmentList(widget.status == "Open" ? "New" : widget.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: _futureCall,
        builder: (context, AsyncSnapshot<List<AppointmetListData>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data!.isNotEmpty) {
                  return _buildView(snapshot.data);
                } else {
                  return _buildDataNotFound1("Data Not Found!");
                }
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
              padding: EdgeInsets.only(top: height / 3, bottom: height / 3),
              child: Center(
                child: CircularProgressIndicator(
                  color: ThemeClass.blueColor,
                ),
              ),
            );
          }
        });
  }

  SingleChildScrollView _buildView(List<AppointmetListData>? appintmentList) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...appintmentList!
              .map(
                (e) => _buildAppointmentList(e),
              )
              .toList()
        ],
      ),
    );
  }

  Center _buildDataNotFound1(
    String text,
  ) {
    return Center(child: Text("$text"));
  }

  Container _buildAppointmentList(AppointmetListData appotinment) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15, left: 15, right: 15),
      decoration: BoxDecoration(
        color: ThemeClass.blueColorlight3,
        boxShadow: [
          BoxShadow(
            color: ThemeClass.blackColor.withOpacity(0.6),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 5.0,
            spreadRadius: -5.0,
          ),
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          _buildFirstRowOfCart(appotinment),
          SizedBox(
            height: 15,
          ),
          _buildSecondRowOfCart(appotinment)
        ],
      ),
    );
  }

  Row _buildSecondRowOfCart(AppointmetListData appotinment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                  getDateFormated(
                    appotinment.date.toString(),
                  ),

                  // "05th Dec 2021",
                  style: TextStyle(
                      color: ThemeClass.blueColor,
                      fontSize: 10,
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
                Text(
                    time24to12Format(
                      appotinment.time.toString(),
                    ),
                    // "10:30 AM",
                    style: TextStyle(
                        color: ThemeClass.blueColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildFirstRowOfCart(AppointmetListData appotinment) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                appotinment.image.toString(),
              )
              // "https://images.unsplash.com/photo-1499887142886-791eca5918cd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHVzZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"),
              ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appotinment.title.toString(),
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Text(appotinment.phoneNumber.toString(),
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
          child: ButtonWidget(
              title: "View Details",
              color: ThemeClass.blueColor,
              fontSize: 12,
              heightPadding: 0,
              radius: 5,
              callBack: () {
                pushNewScreen(
                  context,
                  screen: AppointmentDetailsScreen(
                      appoingmentID: appotinment.id.toString()),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }),
        )
      ],
    );
  }
}
