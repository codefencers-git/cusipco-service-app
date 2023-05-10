// To parse this JSON data, do
//
//     final commonModel = commonModelFromJson(jsonString);

import 'dart:convert';

AgoraTokenModel commonModelFromJson(String str) =>
    AgoraTokenModel.fromJson(json.decode(str));

String commonModelToJson(AgoraTokenModel data) => json.encode(data.toJson());

class AgoraTokenModel {
  AgoraTokenModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  String success;
  String status;
  String message;
  Data data;

  factory AgoraTokenModel.fromJson(Map<String, dynamic> json) =>
      AgoraTokenModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.call_room,
    required this.call_type,
  });

  String call_room;
  String call_type;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    call_room: json["call_room"],
    call_type: json["call_type"],
  );

  Map<String, dynamic> toJson() => {
    "call_room": call_room,
    "call_type": call_type,
  };
}
