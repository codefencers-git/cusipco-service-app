// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  UserData? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class UserData {
  UserData({
    this.id,
    this.name,
    this.designation,
    this.profileImage,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.userType,
    this.isAvailable,
    this.notificationStatus,
    this.startTime,
    this.endTime,
    this.status,
    this.consultationCharges,
    this.timings,
    this.timingsOffline,
  });

  String? id;
  String? name;
  String? designation;

  String? consultationCharges;
  String? profileImage;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? userType;
  String? isAvailable;
  String? notificationStatus;
  String? startTime;
  String? endTime;
  String? status;
  Timings? timings;
  Timings? timingsOffline;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        designation: json["designation"] == null ? null : json["designation"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
        email: json["email"] == null ? null : json["email"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        userType: json["user_type"] == null ? null : json["user_type"],
        isAvailable: json["is_available"] == null ? null : json["is_available"],
        notificationStatus: json["notification_status"] == null
            ? null
            : json["notification_status"],
        startTime: json["start_time"] == null ? null : json["start_time"],
        consultationCharges: json["consultation_charges"] == null
            ? null
            : json["consultation_charges"],
        endTime: json["end_time"] == null ? null : json["end_time"],
        status: json["status"] == null ? null : json["status"],
        timings:
            json["timings"] == null ? null : Timings.fromJson(json["timings"]),
        timingsOffline: json["offline_timings"] == null
            ? null
            : Timings.fromJson(json["offline_timings"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "designation": designation == null ? null : designation,
        "profile_image": profileImage == null ? null : profileImage,
        "email": email == null ? null : email,
        "country_code": countryCode == null ? null : countryCode,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "user_type": userType == null ? null : userType,
        "is_available": isAvailable == null ? null : isAvailable,
        "notification_status":
            notificationStatus == null ? null : notificationStatus,
        "start_time": startTime == null ? null : startTime,
        "consultation_charges":
            consultationCharges == null ? null : consultationCharges,
        "end_time": endTime == null ? null : endTime,
        "status": status == null ? null : status,
        "timings": timings == null ? null : timings!.toJson(),
        "offline_timings":
            timingsOffline == null ? null : timingsOffline!.toJson(),
      };
}

class Timings {
  Timings({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  Day? monday;
  Day? tuesday;
  Day? wednesday;
  Day? thursday;
  Day? friday;
  Day? saturday;
  Day? sunday;

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        monday: json["Monday"] == null ? null : Day.fromJson(json["Monday"]),
        tuesday: json["Tuesday"] == null ? null : Day.fromJson(json["Tuesday"]),
        wednesday:
            json["Wednesday"] == null ? null : Day.fromJson(json["Wednesday"]),
        thursday:
            json["Thursday"] == null ? null : Day.fromJson(json["Thursday"]),
        friday: json["Friday"] == null ? null : Day.fromJson(json["Friday"]),
        saturday:
            json["Saturday"] == null ? null : Day.fromJson(json["Saturday"]),
        sunday: json["Sunday"] == null ? null : Day.fromJson(json["Sunday"]),
      );

  Map<String, dynamic> toJson() => {
        "Monday": monday == null ? null : monday!.toJson(),
        "Tuesday": tuesday == null ? null : tuesday!.toJson(),
        "Wednesday": wednesday == null ? null : wednesday!.toJson(),
        "Thursday": thursday == null ? null : thursday!.toJson(),
        "Friday": friday == null ? null : friday!.toJson(),
        "Saturday": saturday == null ? null : saturday!.toJson(),
        "Sunday": sunday == null ? null : sunday!.toJson(),
      };
}

class Day {
  Day({
    this.startTime,
    this.endTime,
    this.startTime2,
    this.endTime2,
  });

  String? startTime;
  String? endTime;
  String? startTime2;
  String? endTime2;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        startTime: json["start_time"] == null ? "" : json["start_time"],
        endTime: json["end_time"] == null ? "" : json["end_time"],
        startTime2: json["start_time_2"] == null ? "" : json["start_time_2"],
        endTime2: json["end_time_2"] == null ? "" : json["end_time_2"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime == null ? null : startTime,
        "end_time": endTime == null ? null : endTime,
        "start_time_2": startTime2 == null ? null : startTime2,
        "end_time_2": endTime2 == null ? null : endTime2,
      };
}
