import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:cusipco_doctor_app/models/general_info_model.dart';
import 'package:cusipco_doctor_app/services/http_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/user_preference_service.dart';

class GeneralInfoService with ChangeNotifier {
  GeneralInformation? generalInfoData;
  bool isLoading = false;
  bool isError = false;
  String errorMessage = "";
  Future<void> getGeneralInfo() async {
    isLoading = true;
    notifyListeners();
    try {
      var response = await HttpService.httpGetWithoutTokenForCustomer(
        "${HttpService.API_BASE_URL_FOR_AUTH}get_general_info",
      );
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          var TemporderData = GeneralInformationModel.fromJson(res);
          generalInfoData = TemporderData.data;

          isError = false;
          errorMessage = "";

          notifyListeners();
          return;
        } else {
          isError = true;
          errorMessage = GlobalVariableForShowMessage.somethingwentwongMessage;
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        await UserPrefService().removeToken();
        UserPrefService().navigateTOLogin();
      } else if (response.statusCode == 401) {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.internalservererror;
      } else {
        isError = true;
        errorMessage = GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      isError = true;
      if (e is SocketException) {
        errorMessage = GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        errorMessage = GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        errorMessage = e.toString();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
