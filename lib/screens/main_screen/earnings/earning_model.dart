// To parse this JSON data, do
//
//     final earningModel = earningModelFromJson(jsonString);

import 'dart:convert';

EarningModel earningModelFromJson(String str) =>
    EarningModel.fromJson(json.decode(str));

String earningModelToJson(EarningModel data) => json.encode(data.toJson());

class EarningModel {
  EarningModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  EarningData? data;

  factory EarningModel.fromJson(Map<String, dynamic> json) => EarningModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : EarningData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class EarningData {
  EarningData({
    this.balance,
    this.history,
  });

  String? balance;
  List<History>? history;

  factory EarningData.fromJson(Map<String, dynamic> json) => EarningData(
        balance: json["balance"] == null ? null : json["balance"],
        history: json["history"] == null
            ? null
            : List<History>.from(
                json["history"].map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "balance": balance == null ? null : balance,
        "history": history == null
            ? null
            : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class History {
  History({
    this.id,
    this.title,
    this.balance,
    this.type,
    this.status,
    this.date,
    this.time,
  });

  String? id;
  String? title;
  String? balance;
  String? type;
  String? status;
  String? date;
  String? time;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        balance: json["balance"] == null ? null : json["balance"],
        type: json["type"] == null ? null : json["type"],
        status: json["status"] == null ? null : json["status"],
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "balance": balance == null ? null : balance,
        "type": type == null ? null : type,
        "status": status == null ? null : status,
        "date": date == null ? null : date,
        "time": time == null ? null : time,
      };
}
