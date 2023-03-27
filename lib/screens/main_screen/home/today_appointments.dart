import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/global_method.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/models/dashboard_model.dart';
import 'package:healu_doctor_app/screens/main_screen/home/appointment_details_screen.dart';
import 'package:healu_doctor_app/widgets/appbar_widget.dart';
import 'package:healu_doctor_app/widgets/button_widget/rounded_button_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TodayAppointmentScreen extends StatefulWidget {
  TodayAppointmentScreen(
      {Key? key, required this.appointments, required this.isForToday})
      : super(key: key);
  List<Appointment>? appointments;
  bool isForToday;
  @override
  State<TodayAppointmentScreen> createState() => _TodayAppointmentScreenState();
}

class _TodayAppointmentScreenState extends State<TodayAppointmentScreen> {
  @override
  void initState() {
    print("---------------init state called of profile");

    super.initState();
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
                  Navigator.pop(context);
                },
                title: widget.isForToday
                    ? "Today's Appointments"
                    : "Upcoming Appointments",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.appointments!.isEmpty
                        ? Center(
                            child: Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: height * 0.35,
                            ),
                            child: Text("Appointments Not Available"),
                          ))
                        : SizedBox(),
                    ...widget.appointments!
                        .map((e) => _buildAppointmentList(e))
                        .toList(),
                    // ...[1, 2, 3, 4, 5, 4]
                    //     .map((e) => _buildAppointmentList(e))
                    //     .toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildAppointmentList(Appointment appointment) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: ThemeClass.blueColorlight2.withOpacity(0.3),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          _buildFirstRowOfCart(appointment),
          SizedBox(
            height: 15,
          ),
          _buildSecondRowOfCart(appointment)
        ],
      ),
    );
  }

  Row _buildSecondRowOfCart(Appointment appointment) {
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
              Text(getDateFormated(appointment.date.toString()),
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
                Text(time24to12Format(appointment.time.toString()),
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

  Row _buildFirstRowOfCart(Appointment appointment) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
              appointment.image.toString(),
            ),
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
              Text(appointment.title.toString(),
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Text(appointment.modeOfBooking.toString(),
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
                      appoingmentID: appointment.id.toString()),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              }),
        )
      ],
    );
  }
}
