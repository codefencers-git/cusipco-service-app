import 'package:flutter/material.dart';

import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/screens/main_screen/home/appointment_list_widget.dart';

import 'package:healu_doctor_app/widgets/appbar_widget.dart';
import 'package:healu_doctor_app/widgets/button_widget/rounded_button_widget.dart';

class AppointmentFilterScreen extends StatefulWidget {
  AppointmentFilterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AppointmentFilterScreen> createState() =>
      _AppointmentFilterScreenState();
}

class _AppointmentFilterScreenState extends State<AppointmentFilterScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    print("---------------init state called of profile");

    super.initState();
  }

  late TabController _tabBarController;

  List _manuList = ["Open", "Accepted", "Pending", "Completed", "Rejected"];

  bool isfirstInitialize = false;
  int selectedIndex = 0;
  initaLizeTabControoler() {
    if (!isfirstInitialize) {
      _tabBarController = TabController(length: _manuList.length, vsync: this);
      _tabBarController.addListener(() {
        setState(() {
          selectedIndex = _tabBarController.index;

          isfirstInitialize = true;
        });
      });
    }
  }

  _loadData() {}

  @override
  Widget build(BuildContext context) {
    initaLizeTabControoler();
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
                title: "Appointments",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: DefaultTabController(
              length: _manuList.length,
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabBarController,
                      children: [
                        ..._manuList
                            .map((e) => AppointmentListWidget(
                                  status: e,
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  setIndex(value) {
    setState(() {
      selectedIndex = value;
    });
  }

  List<Widget> buildMenu() {
    var tabs = _manuList.map((e) {
      int index1 = _manuList.indexOf(e);
      return _buildButtonListTile(e, index1);
    }).toList();

    return tabs;
  }

  Padding _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TabBar(
        controller: _tabBarController,
        onTap: (value) {
          setIndex(value);
        },
        indicatorPadding: EdgeInsets.only(bottom: 2, left: 6, right: 6),
        indicator: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                side: BorderSide(color: ThemeClass.blueColor)),
            color: ThemeClass.blueColor),
        padding: EdgeInsets.all(20),
        labelColor: ThemeClass.blackColor,
        physics: BouncingScrollPhysics(),
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 7),
        tabs: buildMenu(),
      ),
    );
  }

  AnimatedContainer _buildButtonListTile(String title, int index) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      decoration: BoxDecoration(
          color: index == _tabBarController.index
              ? ThemeClass.blueColor
              : ThemeClass.whiteColor,
          border: Border.all(
              color: index == _tabBarController.index
                  ? Colors.transparent
                  : ThemeClass.blueColor),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Center(
        child: Text(title,
            style: TextStyle(
              fontSize: 12,
              color: index == _tabBarController.index
                  ? ThemeClass.whiteColor
                  : ThemeClass.blackColor,
            )),
      ),
    );
  }
}
