import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/models/dashboard_model.dart';
import 'package:cusipco_doctor_app/models/user_model.dart';
import 'package:cusipco_doctor_app/notification_backGround/notifiction_listner.dart';
import 'package:cusipco_doctor_app/screens/main_screen/home/appointment_details_screen.dart';
import 'package:cusipco_doctor_app/screens/main_screen/home/appointment_filter_screen.dart';
import 'package:cusipco_doctor_app/services/provider_service/dash_board_provider.dart';
import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';
import 'package:cusipco_doctor_app/widgets/appbar_widget.dart';
import 'package:cusipco_doctor_app/widgets/button_widget/rounded_button_widget.dart';
import 'package:cusipco_doctor_app/widgets/dash_board_cart.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {

    _tabController = TabController(length: 2, vsync: this);
    _startStream();
    super.initState();
  }

  _startStream() {
    try {
      // NotificationListner().notificationStreamListner(context);
    } catch (e) {
      print("----dashboard ---$e");
    }
  }

  @override
  void dispose() {
    // AwesomeNotifications().createdSink.close();
    // AwesomeNotifications().displayedSink.close();
    // AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  Future _reFreshData() async {
    var dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);

    return await dashboardProvider.getDashBoardData();
  }

  var boxes = [
    HomeGridModel(
        image: "assets/icons/calender_icon_1.png",
        title: "08",
        subTitle: "Today's Appointments"),
    HomeGridModel(
        image: "assets/icons/calender_icon_2.png",
        title: "22",
        subTitle: "Upcoming Appointments")
  ];

  _buildTopBox(DashBoardData? globalDashboardData) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      crossAxisCount: 2,
      childAspectRatio: 2 / 1.6,
      children: boxes.map((e) {
        if (boxes.indexOf(e) == 0) {
          return DashBoardCArd(
              data: e,
              appointment: globalDashboardData!.todayAppointments,
              isForToday: true);
        } else {
          return DashBoardCArd(
              data: e,
              appointment: globalDashboardData!.upcomingAppointments,
              isForToday: false);
        }
      }).toList(),
    );
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
                  isShowBack: false,
                  isShowRightIcon: true,
                  chatOption: true,
                  onbackPress: () {},
                  title: "",
                )),
            body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: RefreshIndicator(
                  displacement: 40,
                  onRefresh: () {
                    return _reFreshData();
                  },
                  child: _buildConditionView()),
            ),
          ),
        ));
  }

  _buildConditionView() {
    return Consumer<DashboardProvider>(
        builder: (context, prowiderDashboard, child) {
      if (prowiderDashboard.isErrorDashBoard == true) {
        return _buildNoDataFound(
            context, prowiderDashboard.errorMessageDashBoard);
      } else {
        return _buildView(prowiderDashboard.globalDashboardData);
      }
    });
  }

  SingleChildScrollView _buildNoDataFound(BuildContext context, String text) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.5),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Padding _buildView(DashBoardData? globalDashboardData) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<UserPrefService>(builder: (context, prowiderUser, child) {
              if (prowiderUser.isHasErrorProfileData == true) {
                return _buildNoDataFound(
                    context, prowiderUser.errorMSGProfileData);
              } else {
                return _buildDoctorProfile(prowiderUser.globleUserModel!.data);
              }
            }),
            SizedBox(
              height: 15,
            ),
            _buildTopBox(globalDashboardData!),
            _buildTitle("Appointments"),
            ...globalDashboardData.appointments!
                .map((e) => _buildAppointmentList(e))
                .toList(),
            globalDashboardData.appointments == 0
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  )
                : SizedBox(
                    height: 0,
                  ),
            globalDashboardData.appointments == 1
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  )
                : SizedBox(
                    height: 0,
                  ),
          ],
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
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mode of Booking",
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Text(appointment.modeOfBooking.toString(),
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
                      color: ThemeClass.blueColor3,
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
                      color: ThemeClass.blueColor3,
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
            ],
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

  _buildTitle(String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
          child: Text(
            value,
            style: TextStyle(
                color: ThemeClass.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: () {
            pushNewScreen(
              context,
              screen: AppointmentFilterScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Text(
            "View All",
            style: TextStyle(
                fontSize: 12,
                color: ThemeClass.blueColor3,
                fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  Container _buildDoctorProfile(UserData? data) {
    return Container(
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              ThemeClass.blueColor,
              ThemeClass.blueColor3,
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(data!.profileImage.toString()),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.name.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ThemeClass.whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      data.designation.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ThemeClass.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ))
          ],
        ));
  }
}

class HomeGridModel {
  String image;
  String subTitle;
  String title;

  HomeGridModel({
    required this.image,
    required this.title,
    required this.subTitle,
  });
}
