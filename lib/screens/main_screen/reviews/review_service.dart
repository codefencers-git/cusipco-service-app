import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:healu_doctor_app/Global/global_method.dart';
import 'package:healu_doctor_app/Global/global_variable_for_show_messge.dart';

import 'package:healu_doctor_app/screens/main_screen/earnings/earning_model.dart';
import 'package:healu_doctor_app/screens/main_screen/reviews/review_model.dart';
import 'package:healu_doctor_app/services/http_service.dart';
import 'package:healu_doctor_app/services/provider_service/user_preference_service.dart';

class ReviewService with ChangeNotifier {
  List<ReviewData>? globalReviewData;

  bool isLoadingReview = false;
  bool isErrorReview = false;
  String errorMessageReview = "";

  Future<void> getReviews({bool isShowLoading = true}) async {
    if (isShowLoading) {
      isLoadingReview = true;
      notifyListeners();
    }

    try {
      var response =
          await HttpService.httpGet("${HttpService.API_BASE_URL}my-reviews");
      var res = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (res['success'].toString() == "1" &&
            res['status'].toString() == "200") {
          var TemporderData = ReviewModel.fromJson(res);
          globalReviewData = TemporderData.data;
          isErrorReview = false;
          errorMessageReview = "";
          notifyListeners();
          return;
        } else {
          isErrorReview = true;
          errorMessageReview = res['message'].toString();
        }
      } else if (response.statusCode == 401) {
        showToast(GlobalVariableForShowMessage.unauthorizedUser);
        await UserPrefService().removeUserData();
        await UserPrefService().removeToken();
        UserPrefService().navigateTOLogin();
      } else if (response.statusCode == 401) {
        isErrorReview = true;
        errorMessageReview = GlobalVariableForShowMessage.internalservererror;
      } else {
        isErrorReview = true;
        errorMessageReview =
            GlobalVariableForShowMessage.somethingwentwongMessage;
      }
    } catch (e) {
      isErrorReview = true;
      if (e is SocketException) {
        errorMessageReview =
            GlobalVariableForShowMessage.socketExceptionMessage;
      } else if (e is TimeoutException) {
        errorMessageReview =
            GlobalVariableForShowMessage.timeoutExceptionMessage;
      } else {
        errorMessageReview = e.toString();
      }
    } finally {
      if (isShowLoading) {
        isLoadingReview = false;
        notifyListeners();
      }
    }
  }
}
