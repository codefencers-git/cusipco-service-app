import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/global_variable_for_show_messge.dart';

import 'package:cusipco_doctor_app/screens/main_screen/earnings/earning_model.dart';
import 'package:cusipco_doctor_app/services/http_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';

class EarningService with ChangeNotifier {
  EarningData? globalEarningData;

  bool isLoadingEarning = false;
  bool isErrorEarning = false;
  String errorMessageEarning = "";

  Future<void> getEarningData({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingEarning = true;
      notifyListeners();
    }

    try {
      var response = await HttpService.httpGet(
          "${HttpService.API_BASE_URL_FOR_AUTH}wallet");
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          var TemporderData = EarningModel.fromJson(res);
          globalEarningData = TemporderData.data;
          isErrorEarning = false;
          errorMessageEarning = "";
          notifyListeners();
          return;
        } else {
          isErrorEarning = true;
          errorMessageEarning = res['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        await UserPrefService().removeToken();
        UserPrefService().navigateTOLogin();
      } else if (response.statusCode == 401) {
        isErrorEarning = true;
        errorMessageEarning = GlobalVariableForShowMessage.internalservererror;
      } else {
        isErrorEarning = true;
        errorMessageEarning =
            GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      isErrorEarning = true;
      if (e is SocketException) {
        errorMessageEarning =
            GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        errorMessageEarning =
            GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        errorMessageEarning = e.toString();
      }
    } finally {
      if (isShowLoading) {
        isLoadingEarning = false;
        notifyListeners();
      }
    }
  }
}
