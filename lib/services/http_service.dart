import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:healu_doctor_app/Global/global_variable_for_show_messge.dart';
import 'package:http_parser/http_parser.dart';

import 'package:healu_doctor_app/services/provider_service/user_preference_service.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HttpService {
  static const String API_BASE_URL_FOR_AUTH =
      "http://admin.healuconsultancy.com/api/customer/";

  static const String API_BASE_URL =
      "http://admin.healuconsultancy.com/api/management/";

  static const String GOOGLE_API_KEY =
      "AIzaSyB07GK4in7QPDNP7W-0GWkUEcp6KtPB28A";

  static Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "Request-From": Platform.isAndroid ? "Android" : "Ios",
    // HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.acceptLanguageHeader: 'en'
  };

  static Future<Response> httpGetWithoutToken(String url) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      return http.get(
        Uri.parse(url),
        headers: requestHeaders,
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpGetWithoutTokenForCustomer(String url) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      return http.get(
        Uri.parse(url),
        headers: requestHeaders,
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpGet(String url) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      var token = await UserPrefService().getToken();

      print(url);
      print(token);

      return http.get(
        Uri.parse(url),
        headers: requestHeaders
          ..addAll({
            'Authorization': 'Bearer $token',
          }),
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpPost(
    String url,
    dynamic data,
  ) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      var token = await UserPrefService().getToken();
      print(url);
      print(data);
      print(token);
      return http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: requestHeaders
          ..addAll({
            'Authorization': 'Bearer $token',
          }),
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpPostWithImageUpload(
      String url, File? imageFile, Map<String, dynamic> queryParameters,
      {required String peramterName}) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      try {
        var request3 = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );
        request3.headers.addAll(requestHeaders);

        request3.files.add(await http.MultipartFile.fromPath(
          peramterName,
          "${imageFile!.path}",
          contentType: MediaType('image', 'jpg'),
        ));

        queryParameters.forEach((key, value) {
          request3.fields[key] = value;
        });

        StreamedResponse res3 = await request3.send();
        var response = await http.Response.fromStream(
          res3,
        );

        return response;
      } catch (e) {
        print(e.toString());

        rethrow;
      }
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }

  static Future<Response> httpPostWithoutToken(String url, dynamic data) async {
    bool isHasConnection = await InternetConnectionChecker().hasConnection;

    if (isHasConnection) {
      debugPrint("___________ => $url");
      return http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: requestHeaders,
      );
    } else {
      throw GlobalVariableForShowMessage.internetNotConneted;
    }
  }
}
