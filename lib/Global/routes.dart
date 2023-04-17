import 'package:flutter/cupertino.dart';
import 'package:cusipco_doctor_app/screens/authentication/login_screen.dart';
import 'package:cusipco_doctor_app/screens/main_screen/main_screen.dart';
import 'package:cusipco_doctor_app/screens/splash_screen.dart';

class Routes {
  static const String mainRoute = "/main";
  static const String mainRouteforLoading = "/";

  static const String splashRoute = "/splash";
  static const String onBoardingScreen = "/onBoardingScreen";
  static const String loginScreen = "/loginScreen";
  // static const String verifyMobileScreen = "/verifyMobileScreen";
  static const String registerScreen = "/registerScreen";
  static Map<String, Widget Function(BuildContext)> globalRoutes = {
    mainRoute: (context) => MainScreen(),
    loginScreen: (context) => LoginScreen(),
    splashRoute: (context) => SplashScreen(),
  };
}
