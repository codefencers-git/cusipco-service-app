import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cusipco_doctor_app/Global/navigation_service.dart';
import 'package:cusipco_doctor_app/Global/routes.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/firebase_options.dart';
import 'package:cusipco_doctor_app/notification_backGround/notification_service.dart';
import 'package:cusipco_doctor_app/notification_backGround/notifiction_listner.dart';
import 'package:cusipco_doctor_app/screens/main_screen/earnings/earning_service.dart';
import 'package:cusipco_doctor_app/screens/main_screen/reviews/review_service.dart';
import 'package:cusipco_doctor_app/services/main_navigaton_prowider_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/dash_board_provider.dart';
import 'package:cusipco_doctor_app/services/provider_service/general_info_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/indexChangesService.dart';
import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';

import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.black, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationListner().initializeNotification();

  await Firebase.initializeApp(
    name: 'Cusipco',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  configLoading();
  makeListnerNotification();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  print('----------andling a background message: ${message.messageId}');

  if (message.data != null) {
    if (message.data['alert_type'] != null &&
        message.data['alert_type'] == "Call") {
      if (message.data['token'] != null) {
        createVideoCallNotification(
          isSound: "true",
          callRoom: message.data['call_room'],
          callType: message.data['alert_type'],
          callToken: message.data['token'],
          message: message.data['message'],
          title: message.data['title'],
          id: message.data['user_id'],
        );
      } else {
        createSimpleNotification(
            id: message.data['type_id'],
            title: message.data['title'],
            message: message.data['message']);
      }
    }
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.white
    ..textColor = Colors.yellow
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainNavigationProwider>(
          create: (_) => MainNavigationProwider(),
        ),
        ChangeNotifierProvider<UserPrefService>(
          create: (_) => UserPrefService(),
        ),
        ChangeNotifierProvider<GeneralInfoService>(
          create: (_) => GeneralInfoService(),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(),
        ),
        ChangeNotifierProvider<CheckIndexChange>(
          create: (_) => CheckIndexChange(),
        ),
        ChangeNotifierProvider<EarningService>(
          create: (_) => EarningService(),
        ),
        ChangeNotifierProvider<ReviewService>(
          create: (_) => ReviewService(),
        )
      ],
      child: MaterialApp(
          title: 'Cusipco Services',
          debugShowCheckedModeBanner: false,
          theme: ThemeClass.themeData,
          routes: Routes.globalRoutes,
          initialRoute: Routes.splashRoute,
          builder: EasyLoading.init(),
          navigatorKey: navigationService.navigationKey),
    );
  }
}
