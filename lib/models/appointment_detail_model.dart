// To parse this JSON data, do
//
//     final appointmentDetailModel = appointmentDetailModelFromJson(jsonString);

import 'dart:convert';

AppointmentDetailModel appointmentDetailModelFromJson(String str) =>
    AppointmentDetailModel.fromJson(json.decode(str));

String appointmentDetailModelToJson(AppointmentDetailModel data) =>
    json.encode(data.toJson());

class AppointmentDetailModel {
  AppointmentDetailModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  AppointmentDetailData? data;

  factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : AppointmentDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class AppointmentDetailData {
  AppointmentDetailData({
    this.id,
    this.image,
    this.title,
    this.phoneNumber,
    this.subTitle,
    this.notes,
    this.meetingUrl,
    this.date,
    this.time,
    this.modeOfBooking,
    this.status,
    this.prescription,
    this.module,
    this.userDetails,
  });

  String? id;
  String? image;
  String? title;
  String? phoneNumber;
  String? subTitle;
  String? notes;
  String? meetingUrl;
  String? date;
  String? time;
  String? module;
  String? modeOfBooking;
  String? status;
  String? prescription;
  UserDetails? userDetails;

  factory AppointmentDetailData.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailData(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        subTitle: json["sub_title"] == null ? null : json["sub_title"],
        notes: json["notes"] == null ? null : json["notes"],
        meetingUrl: json["meeting_url"] == null ? null : json["meeting_url"],
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
        module: json["module"] == null ? null : json["module"],
        modeOfBooking:
            json["mode_of_booking"] == null ? null : json["mode_of_booking"],
        status: json["status"] == null ? null : json["status"],
        prescription:
            json["prescription"] == null ? null : json["prescription"],
        userDetails: json["user_details"] == null
            ? null
            : UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "sub_title": subTitle == null ? null : subTitle,
        "notes": notes == null ? null : notes,
        "meeting_url": meetingUrl == null ? null : meetingUrl,
        "date": date == null ? null : date,
        "time": time == null ? null : time,
        "module": module == null ? null : module,
        "mode_of_booking": modeOfBooking == null ? null : modeOfBooking,
        "status": status == null ? null : status,
        "prescription": prescription == null ? null : prescription,
        "user_details": userDetails == null ? null : userDetails!.toJson(),
      };
}

class UserDetails {
  UserDetails({
    this.name,
    this.dob,
    this.age,
    this.gender,
  });

  String? name;
  String? dob;
  String? age;
  String? gender;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        name: json["name"] == null ? null : json["name"],
        dob: json["dob"] == null ? null : json["dob"],
        age: json["age"] == null ? null : json["age"],
        gender: json["gender"] == null ? null : json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "dob": dob == null ? null : dob,
        "age": age == null ? null : age,
        "gender": gender == null ? null : gender,
      };
}
