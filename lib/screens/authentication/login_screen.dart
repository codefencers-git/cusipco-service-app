import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:cusipco_doctor_app/Global/routes.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/screens/main_screen/earnings/earning_service.dart';
import 'package:cusipco_doctor_app/screens/main_screen/main_screen.dart';
import 'package:cusipco_doctor_app/screens/main_screen/reviews/review_service.dart';
import 'package:cusipco_doctor_app/services/http_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/dash_board_provider.dart';
import 'package:cusipco_doctor_app/services/provider_service/firebase_token_update_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/general_info_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';
import 'package:cusipco_doctor_app/widgets/button_widget/rounded_button_widget.dart';
import 'package:cusipco_doctor_app/widgets/text_boxes/text_box_with_sufix.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirstSubmit = true;
  bool _isObcs = true;
  _togglePassword() {
    setState(() {
      _isObcs = !_isObcs;
    });
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.4,
                      child: _buildHeaderImage(height),
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    _buildView(),
                    SizedBox(
                      height: height * 0.1,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container _buildView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        autovalidateMode: !isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: ThemeClass.blueColor),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Phone Number or Email",
              controllers: _emailController,
              icon: "assets/icons/user_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Phone Number or Email";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFiledWidget(
              backColor: ThemeClass.whiteDarkColor,
              hinttext: "Password",
              isObcurs: _isObcs,
              oniconTap: () {
                _togglePassword();
              },
              controllers: _passwordController,
              icon: _isObcs
                  ? "assets/icons/lock_icon.png"
                  : "assets/icons/unlock_icon.png",
              validator: (value) {
                if (value!.isEmpty) {
                  return GlobalVariableForShowMessage.EmptyErrorMessage +
                      "Password";
                } else if (value.length < 6) {
                  return GlobalVariableForShowMessage.passwordshoudbeatleat;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
                isLoading: isLoading,
                title: "Login",
                color: ThemeClass.blueColor,
                callBack: () {
                  // Navigator.pushAndRemoveUntil<void>(
                  //   context,
                  //   MaterialPageRoute<void>(
                  //       builder: (BuildContext context) => MainScreen()),
                  //   ModalRoute.withName(Routes.mainRoute),
                  // );
                  setState(() {
                    isFirstSubmit = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    _loginUser();
                  }
                }),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildHeaderImage(double height) {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(0.0, -40),
          child: Container(
            height: height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_top_background.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.07),
            child: Container(
              height: height * 0.15,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash_header_icon.png"),
                  // fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _loginUser() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var mapData = Map<String, dynamic>();
      mapData['username'] = _emailController.text.toString().trim();
      mapData['password'] = _passwordController.text.toString().trim();
      mapData['device_token'] = "0";
      mapData['device_type'] = Platform.isAndroid ? "android" : "ios";

      try {
        var response = await HttpService.httpPostWithoutToken(
            "${HttpService.API_BASE_URL}login", mapData);

        if (response.statusCode == 201 || response.statusCode == 200) {
          var res = jsonDecode(response.body);

          if (res['success'].toString() == "1" &&
              res['status'].toString() == "200") {
            var prowider = Provider.of<UserPrefService>(context, listen: false);
            var orderProvider =
                Provider.of<DashboardProvider>(context, listen: false);

            await prowider.setToken(res['data']['token']);
            var prov = Provider.of<EarningService>(context, listen: false);
            prov.getEarningData();

            var prov1 = Provider.of<ReviewService>(context, listen: false);
            prov1.getReviews();
            await prowider.getUserDataFromApi();
            await orderProvider.getDashBoardData();

            await Provider.of<GeneralInfoService>(context, listen: false)
                .getGeneralInfo();
            FirebaseTokenUpdateService().updateDeviceData();

            showToast(res['message']);
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => MainScreen()),
              ModalRoute.withName(Routes.mainRoute),
            );
          } else if (res['status'].toString() == "202") {
            showToast(res['message']);
          } else {
            showToast(res['message']);
          }
        } else {
          showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
        }
      } catch (e) {
        if (e is SocketException) {
          showToast(GlobalVariableForShowMessage.socketExceptionMessage);
        } else if (e is TimeoutException) {
          showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
        } else {
          showToast(e.toString());
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
