import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/models/dashboard_model.dart';
import 'package:cusipco_doctor_app/screens/main_screen/home/home_screen.dart';
import 'package:cusipco_doctor_app/screens/main_screen/home/today_appointments.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DashBoardCArd extends StatelessWidget {
  DashBoardCArd(
      {Key? key,
      required this.data,
      required this.isForToday,
      required this.appointment})
      : super(key: key);

  HomeGridModel data;
  bool isForToday;
  List<Appointment>? appointment;
  @override
  Widget build(BuildContext context) {
    // final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: ThemeClass.blueColor),
      child: InkWell(
        onTap: () {
          pushNewScreen(
            context,
            screen: TodayAppointmentScreen(
              isForToday: isForToday,
              appointments: appointment,
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          appointment!.length.toString(),
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: ThemeClass.whiteColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        data.image,
                      ),
                    ),
                  ],
                ),
                Text(
                  data.subTitle,
                  maxLines: 2,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: ThemeClass.whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )
              ]),
        ),
      ),
    );
  }
}
