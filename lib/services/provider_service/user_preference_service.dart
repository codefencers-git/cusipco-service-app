import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:cusipco_doctor_app/Global/navigation_service.dart';
import 'package:cusipco_doctor_app/Global/routes.dart';
import 'package:cusipco_doctor_app/models/user_model.dart';
import 'package:cusipco_doctor_app/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefService with ChangeNotifier {
  static SharedPreferences? preferences;

  UserModel? globleUserModel;
  String? token;

  bool isloadingProfileData = false;
  bool isHasErrorProfileData = false;
  String errorMSGProfileData = "";

  Future<void> setUserData({required UserModel? userModel}) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setString('userModelDoctor', jsonEncode(userModel));
    globleUserModel = userModel;

    notifyListeners();
  }

  Future<void> setToken(value) async {
    preferences = await SharedPreferences.getInstance();
    preferences!.setString('tokenDoctor', value);
    token = value;
    notifyListeners();
    return;
  }

  Future<String?> getToken() async {
    preferences = await SharedPreferences.getInstance();
    var data = preferences!.getString('tokenDoctor');
    return data;
  }

  Future<void> removeToken() async {
    preferences = await SharedPreferences.getInstance();
    preferences!.remove('tokenDoctor');
    notifyListeners();
  }

  Future<UserModel> getUserData() async {
    preferences = await SharedPreferences.getInstance();
    var temp = preferences!.getString("userModelDoctor");
    var dataToRetun = UserModel.fromJson(jsonDecode(temp.toString()));
    globleUserModel = dataToRetun;
    notifyListeners();

    return dataToRetun;
  }

  Future<void> removeUserData() async {
    preferences = await SharedPreferences.getInstance();
    preferences!.remove('userModelDoctor');
  }

  Future getUserDataFromApi() async {
    try {
      var response =
          await HttpService.httpGet("${HttpService.API_BASE_URL}get_myProfile");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);

        if (body['success'] == "1" && body['status'] == "200") {
          UserModel data = UserModel.fromJson(body);
          setUserData(userModel: data);
          isHasErrorProfileData = false;
          errorMSGProfileData = "";
          globleUserModel = data;
          notifyListeners();
          return;
        } else {
          isHasErrorProfileData = true;
          errorMSGProfileData = body['message'].toString();
          // throw (body['message']);
        }
      } else if (response.statusCode == 401) {
        await removeUserData();
        NavigationService().navigatWhenUnautorized();
        throw "";
      } else {
        isHasErrorProfileData = true;
        // throw ("internal servier error");
        errorMSGProfileData = "internal servier error";
      }
    } catch (e) {
      if (e is SocketException) {
        isHasErrorProfileData = true;
        //showToast(GlobalVariableForShowMessage.socketExceptionMessage);
        errorMSGProfileData =
            GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        isHasErrorProfileData = true;
        // showToast(GlobalVariableForShowMessage.timeoutExceptionMessage);
        errorMSGProfileData =
            GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        isHasErrorProfileData = true;
        // showToast(e.toString());
        errorMSGProfileData = e.toString();
      }
    } finally {
      notifyListeners();
    }
  }

  updateNotificationStatu(String status) async {
    EasyLoading.show();
    try {
      Map<String, dynamic> queryParameters = {
        "via_nitification": status == "1" ? 1 : 0
      };
      var response = await HttpService.httpPost(
          "${HttpService.API_BASE_URL}save_generalSettings", queryParameters);
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(GlobalVariableForShowMessage.statusUdated);
          globleUserModel!.data!.notificationStatus = status;
          notifyListeners();
          return;
        } else {
          showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await removeUserData();
        await removeToken();
        navigateTOLogin();
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
      EasyLoading.dismiss();
    }
  }

  updateUserStatus(String status) async {
    EasyLoading.show();
    try {
      Map<String, String> queryParameters = {"is_available": status};
      var response = await HttpService.httpPost(
          "${HttpService.API_BASE_URL}update-availability", queryParameters);
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(GlobalVariableForShowMessage.statusUdated);
          globleUserModel!.data!.isAvailable = status;
          notifyListeners();
          return;
        } else {
          showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await removeUserData();
        await removeToken();
        navigateTOLogin();
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
      EasyLoading.dismiss();
    }
  }

  updateUserAllData(data) async {
    EasyLoading.show();
    try {
      var response = await HttpService.httpPost(
          "${HttpService.API_BASE_URL}updateProfile", data);
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          // globleUserModel!.data!.statusUser = status;
          notifyListeners();

          UserModel data = UserModel.fromJson(res);
          setUserData(userModel: data);
          globleUserModel = data;
          notifyListeners();
          showToast(GlobalVariableForShowMessage.profileUdated);
          return;
        } else {
          showToast(res['message'].toString());
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await removeUserData();
        await removeToken();
        navigateTOLogin();
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
      EasyLoading.dismiss();
    }
  }

  uploadImage(
    ImagePAth, {
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
          showToast(GlobalVariableForShowMessage.profileUdated);

          UserModel data = UserModel.fromJson(body);
          setUserData(userModel: data);
          globleUserModel = data;
          notifyListeners();
          return;
        } else {
          showToast(body['message'].toString());
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await removeUserData();
        await removeToken();
        navigateTOLogin();
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
      } else {
        showToast(e.toString());
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  logout() async {
    EasyLoading.show();

    try {
      var response =
          await HttpService.httpGet("${HttpService.API_BASE_URL}logout");
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          showToast(GlobalVariableForShowMessage.logoutSuccess);
          navigateTOLogin();
        } else {
          showToast(GlobalVariableForShowMessage.somethingwentwongMessage);
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await removeUserData();
        await removeToken();
        navigateTOLogin();
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
      EasyLoading.dismiss();
    }
  }

  navigateTOLogin() {
    Navigator.pushNamedAndRemoveUntil(
        navigationService.navigationKey.currentContext!,
        Routes.loginScreen,
        (route) => false);
  }
}
