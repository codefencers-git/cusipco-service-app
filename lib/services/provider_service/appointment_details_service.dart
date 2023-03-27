import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:healu_doctor_app/Global/global_method.dart';
import 'package:healu_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:healu_doctor_app/Global/navigation_service.dart';
import 'package:healu_doctor_app/models/appointment_detail_model.dart';
import 'package:healu_doctor_app/models/appointment_list_model.dart';
import 'package:healu_doctor_app/services/http_service.dart';
import 'package:healu_doctor_app/services/provider_service/user_preference_service.dart';

class AppointmentDetailService with ChangeNotifier {
  AppointmentDetailData? globalDashboardData;

  bool isLoadingDashBoard = false;
  bool isErrorDashBoard = false;
  String errorMessageDashBoard = "";

  Future<AppointmentDetailData?> getAppointmentDetails(
      String appoingmentID) async {
    try {
      var response = await HttpService.httpGet(
        HttpService.API_BASE_URL + "appointment/${appoingmentID}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          AppointmentDetailModel data = AppointmentDetailModel.fromJson(body);
          print(data.data);
          return data.data;
        } else {
          throw body['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else if (response.statusCode == 500) {
        throw GlobalVariableForShowMessage.internalservererror;
      } else {
        throw GlobalVariableForShowMessage.internalservererror;
      }
    } catch (e) {
      if (e is SocketException) {
        throw GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        throw GlobalVariableForShowMessage.timeoutExceptionMessage;
        ;
      } else {
        throw e.toString();
      }
    }
  }

  Future updateAppointmentDetails({
    required String id,
    String? notes,
    String? meetingUrl,
    String? status,
    String? otp,
  }) async {
    EasyLoading.show();
    try {
      Map<String, dynamic> queryParameters = {
        "item_id": "${id}",
      };

      if (notes != null) {
        queryParameters.addAll({"notes": notes});
      }

      if (meetingUrl != null) {
        queryParameters.addAll({"meeting_url": meetingUrl});
      }
      if (status != null) {
        queryParameters.addAll({"status": status});
      }
      if (otp != null) {
        queryParameters.addAll({"otp": otp});
      }

      var response = await HttpService.httpPost(
          HttpService.API_BASE_URL + "update-appointment", queryParameters);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          showToast(body['message'].toString());
          return true;
        } else {
          throw body['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else if (response.statusCode == 500) {
        showToast(GlobalVariableForShowMessage.internalservererror);
      } else {
        showToast(GlobalVariableForShowMessage.internalservererror);
      }
    } catch (e) {
      if (e is SocketException) {
        showToast(GlobalVariableForShowMessage.socketExceptionMessage);
      } else if (e is TimeoutException) {
        showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
        ;
      } else {
        showToast(e.toString());
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  uploadDocument(
    File ImagePAth, {
    required url,
    required String perameterName,
    Map<String, dynamic>? extraPerameter,
  }) async {
    EasyLoading.show();
    try {
      Map<String, dynamic> data = extraPerameter != null ? extraPerameter : {};
      var response = await HttpService.httpPostWithImageUpload(
          HttpService.API_BASE_URL + url, ImagePAth, data,
          peramterName: perameterName);
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = json.decode(response.body);
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(body['message'].toString());
          return true;
        } else {
          showToast(body['message'].toString());
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else if (response.statusCode == 500) {
        showToast(GlobalVariableForShowMessage.internalservererror);
      } else {
        showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
      }
    } catch (e) {
      if (e is SocketException) {
        showToast(GlobalVariableForShowMessage.socketExceptionMessage);
      } else if (e is TimeoutException) {
        showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
        ;
      } else {
        showToast(e.toString());
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<List<AppointmetListData>?> getAppointmentList(String status) async {
    try {
      Map<String, dynamic> queryParameters = {
        "status": "$status",
      };

      var response = await HttpService.httpPost(
          HttpService.API_BASE_URL + "appointments", queryParameters);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'].toString() == "1" &&
            body['status'].toString() == "200") {
          AppointmentListModel data = AppointmentListModel.fromJson(body);
          print(data.data);
          return data.data;
        } else {
          throw body['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
      } else if (response.statusCode == 500) {
        showToast(GlobalVariableForShowMessage.internalservererror);
      } else {
        showToast(GlobalVariableForShowMessage.internalservererror);
      }
    } catch (e) {
      if (e is SocketException) {
        showToast(GlobalVariableForShowMessage.socketExceptionMessage);
      } else if (e is TimeoutException) {
        showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
        ;
      } else {
        showToast(e.toString());
      }
    }
  }
}
