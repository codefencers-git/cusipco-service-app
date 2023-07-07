import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/routes.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/screens/authentication/login_screen.dart';
import 'package:cusipco_doctor_app/screens/main_screen/earnings/earning_service.dart';
import 'package:cusipco_doctor_app/screens/main_screen/main_screen.dart';
import 'package:cusipco_doctor_app/screens/main_screen/reviews/review_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/dash_board_provider.dart';
import 'package:cusipco_doctor_app/services/provider_service/firebase_token_update_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/general_info_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';

import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      _navigateTo();
    });
  }

  _navigateTo() async {
    try {
      var provider = Provider.of<UserPrefService>(context, listen: false);
      var orderProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      var token = await provider.getToken();
      if (token != null && token != "") {
        try {
          var prov = Provider.of<EarningService>(context, listen: false);
          prov.getEarningData();

          var prov1 = Provider.of<ReviewService>(context, listen: false);
          prov1.getReviews();

          FirebaseTokenUpdateService().updateDeviceData();

          print("token -----------${token}");
          await provider.getUserDataFromApi();
          await orderProvider.getDashBoardData();

          await Provider.of<GeneralInfoService>(context, listen: false)
              .getGeneralInfo();

          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MainScreen()),
            ModalRoute.withName(Routes.mainRoute),
          );
        } catch (e) {
          if (mounted) {
            _navigateToLogin();
          }
        }
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      _navigateToLogin();
    }
  }

  _navigateToLogin() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => LoginScreen()),
      ModalRoute.withName(Routes.loginScreen),
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
          body: Container(
              color: ThemeClass.whiteColor,
              height: height,
              width: width,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/splash_bg1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    child: _buildView(height),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Column _buildView(double height) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.05,
        ),
        Container(
          height: height * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_main_icon.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          height: height * 0.08,
        ),
        Container(
          height: height * 0.30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_icon1.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
