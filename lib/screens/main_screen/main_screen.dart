import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/global_method.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/notification_backGround/notification_service.dart';
import 'package:healu_doctor_app/screens/main_screen/earnings/earnings_screen.dart';
import 'package:healu_doctor_app/screens/main_screen/home/home_screen.dart';
import 'package:healu_doctor_app/screens/main_screen/profile/profile_screen.dart';
import 'package:healu_doctor_app/screens/main_screen/need_support_screen.dart';
import 'package:healu_doctor_app/screens/main_screen/reviews/review_screen.dart';
import 'package:healu_doctor_app/services/main_navigaton_prowider_service.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _globalscafoldKey = GlobalKey<ScaffoldState>();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");

        checkAppUpdate(context, isShowNormalAlert: false);
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkNotificationPermission(context);
    WidgetsBinding.instance.addObserver(this);
    checkAppUpdate(context, isShowNormalAlert: true);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainNavigationProwider>(
        builder: (context, navProwider, child) {
      return Container(
        color: ThemeClass.safeareBackGround,
        child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                key: _globalscafoldKey,
                extendBodyBehindAppBar: true,
                body: PersistentTabView(
                  context, controller: navProwider.navController,
                  onItemSelected: (item) {},
                  navBarHeight: 70,
                  screens: [
                    HomeScreen(),
                    NeedSupportScreen(),
                    EarningScreen(),
                    ReviewScreen(),
                    profileScreen(),
                  ],
                  items: _navBarsItems(),
                  backgroundColor: ThemeClass.blueColor,
                  padding: const NavBarPadding.only(left: 0, right: 0),
                  stateManagement: false,
                  hideNavigationBarWhenKeyboardShows: true,
                  decoration: NavBarDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    colorBehindNavBar: Colors.white,
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: const ItemAnimationProperties(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: const ScreenTransitionAnimation(
                    animateTabTransition: true,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle
                      .style2, // Choose the nav bar style with this property.
                ))),
      );
    });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            Image.asset(
              "assets/icons/home_white_icon.png",
              height: 30,
              width: 30,
            ),
            const SizedBox(
              height: 3,
            ),
            Transform.translate(
              offset: Offset(0, -2),
              child: Text(
                "Home",
                style: TextStyle(color: ThemeClass.whiteColor, fontSize: 10),
              ),
            )
          ],
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            Image.asset(
              "assets/icons/music.png",
              height: 30,
              width: 30,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              "Need Help",
              style: TextStyle(color: ThemeClass.whiteColor, fontSize: 10),
            )
          ],
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            Image.asset(
              "assets/icons/bottom_icon3.png",
              height: 30,
              width: 30,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              "Earnings",
              style: TextStyle(color: ThemeClass.whiteColor, fontSize: 10),
            )
          ],
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            Image.asset(
              "assets/icons/bottom_icon4.png",
              height: 30,
              width: 30,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              "Reviews",
              style: TextStyle(color: ThemeClass.whiteColor, fontSize: 10),
            )
          ],
        ),
      ),
      PersistentBottomNavBarItem(
        // onPressed: (val) {
        //   pushNewScreen(
        //     context,
        //     screen: profileScreen(),
        //     withNavBar: false,
        //     pageTransitionAnimation: PageTransitionAnimation.cupertino,
        //   );
        // },
        icon: Column(
          children: [
            Image.asset(
              "assets/icons/user_white_icon.png",
              height: 30,
              width: 30,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              "Profile",
              style: TextStyle(color: ThemeClass.whiteColor, fontSize: 10),
            )
          ],
        ),
      ),
    ];
  }
}
