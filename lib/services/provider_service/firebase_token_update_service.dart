import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healu_doctor_app/Global/global_method.dart';
import 'package:healu_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:healu_doctor_app/Global/navigation_service.dart';
import 'package:healu_doctor_app/services/http_service.dart';
import 'package:healu_doctor_app/services/provider_service/user_preference_service.dart';

class FirebaseTokenUpdateService {
  updateDeviceData() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      print("firebase token -----------${token}");

      if (Platform.isAndroid) {
        var data = deviceInfoPlugin.androidInfo.then((value) {
          _updateDeviceDataApi(
              model: value.model.toString(),
              token: token.toString(),
              version: value.version.release.toString(),
              deviceType: "Android");
        });
      } else if (Platform.isIOS) {
        var data = deviceInfoPlugin.iosInfo.then((value) {
          _updateDeviceDataApi(
              model: value.model.toString(),
              token: token.toString(),
              version: value.systemVersion.toString(),
              deviceType: "Android");
        });
      }
    } catch (e) {
      print("------while update device data = $e");
    }
  }

  _updateDeviceDataApi({
    required String token,
    required String version,
    required String model,
    required String deviceType,
  }) async {
    try {
      Map<String, String> queryParameters = {
        "device_type": deviceType,
        "notification_type": "Flutter",
        "token": token,
        "uuid": "0",
        "ip": "0",
        "os_version": version,
        "model_name": model,
      };
      var response = await HttpService.httpPost(
        "${HttpService.API_BASE_URL}update-device-details",
        queryParameters,
      );
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
        } else {
          showToast(res['message']);
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        NavigationService().navigatWhenUnautorized();
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
    } finally {}
  }
}
