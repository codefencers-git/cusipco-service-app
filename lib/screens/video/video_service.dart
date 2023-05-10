import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../services/http_service.dart';
import '../main_screen/chat/AgoraTokenModel.dart';

Future<AgoraTokenModel?> getAgoraToken(String callToId, String type,
    {required BuildContext context}) async {
  try {

    var url = "http://cusipco.codefencers.com/api/take-a-call";
    // UserModel? model = await UserPrefService().getUserData();
    // String phone = model.data!.phoneNumber.toString();

    Map<dynamic, dynamic> data = {
      'call_to': callToId,
      'type': type,
    };

    var response =
    await HttpService.httpPost(url, data );

    if (response.statusCode == 200) {
      AgoraTokenModel agoraTokenModel =
      AgoraTokenModel.fromJson(jsonDecode(response.body));
      print("AGORA ROOM : ${agoraTokenModel.data.call_type}");
      return agoraTokenModel;
    }
  } catch (e) {
    debugPrint(e.toString());
  } finally {
  }
}