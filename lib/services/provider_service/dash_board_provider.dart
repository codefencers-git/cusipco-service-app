import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:healu_doctor_app/Global/global_method.dart';
import 'package:healu_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:healu_doctor_app/models/dashboard_model.dart';
import 'package:healu_doctor_app/services/http_service.dart';
import 'package:healu_doctor_app/services/provider_service/user_preference_service.dart';

class DashboardProvider with ChangeNotifier {
  DashBoardData? globalDashboardData;

  bool isLoadingDashBoard = false;
  bool isErrorDashBoard = false;
  String errorMessageDashBoard = "";

  Future<void> getDashBoardData({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingDashBoard = true;
      notifyListeners();
    }

    try {
      var response =
          await HttpService.httpGet("${HttpService.API_BASE_URL}dashboard");
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          var TemporderData = DashboardModel.fromJson(res);
          globalDashboardData = TemporderData.data;
          isErrorDashBoard = false;
          errorMessageDashBoard = "";
          notifyListeners();
          return;
        } else {
          isErrorDashBoard = true;
          errorMessageDashBoard = res['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        await UserPrefService().removeToken();
        UserPrefService().navigateTOLogin();
      } else if (response.statusCode == 401) {
        isErrorDashBoard = true;
        errorMessageDashBoard =
            GlobalVariableForShowMessage.internalservererror;
      } else {
        isErrorDashBoard = true;
        errorMessageDashBoard =
            GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      isErrorDashBoard = true;
      if (e is SocketException) {
        errorMessageDashBoard =
            GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        errorMessageDashBoard =
            GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        errorMessageDashBoard = e.toString();
      }
    } finally {
      if (isShowLoading) {
        isLoadingDashBoard = false;
        notifyListeners();
      }
    }
  }
}
