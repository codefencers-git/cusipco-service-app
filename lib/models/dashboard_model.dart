// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  DashBoardData? data;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : DashBoardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class DashBoardData {
  DashBoardData({
    this.todayAppointments,
    this.upcomingAppointments,
    this.appointments,
  });

  List<Appointment>? todayAppointments;
  List<Appointment>? upcomingAppointments;
  List<Appointment>? appointments;

  factory DashBoardData.fromJson(Map<String, dynamic> json) => DashBoardData(
        todayAppointments: json["today_appointments"] == null
            ? null
            : List<Appointment>.from(
                json["today_appointments"].map((x) => Appointment.fromJson(x))),
        upcomingAppointments: json["upcoming_appointments"] == null
            ? null
            : List<Appointment>.from(json["upcoming_appointments"]
                .map((x) => Appointment.fromJson(x))),
        appointments: json["appointments"] == null
            ? null
            : List<Appointment>.from(
                json["appointments"].map((x) => Appointment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "today_appointments": todayAppointments == null
            ? null
            : List<dynamic>.from(todayAppointments!.map((x) => x.toJson())),
        "upcoming_appointments": upcomingAppointments == null
            ? null
            : List<dynamic>.from(upcomingAppointments!.map((x) => x.toJson())),
        "appointments": appointments == null
            ? null
            : List<dynamic>.from(appointments!.map((x) => x.toJson())),
      };
}

class Appointment {
  Appointment({
    this.id,
    this.image,
    this.title,
    this.subTitle,
    this.notes,
    this.meetingUrl,
    this.date,
    this.time,
    this.status,
    this.modeOfBooking,
    this.phoneNumber,
  });

  String? id;
  String? image;
  String? title;
  String? subTitle;
  String? notes;
  String? meetingUrl;
  String? date;
  String? time;
  String? status;
  String? modeOfBooking;
  String? phoneNumber;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        subTitle: json["sub_title"] == null ? null : json["sub_title"],
        notes: json["notes"] == null ? null : json["notes"],
        meetingUrl: json["meeting_url"] == null ? null : json["meeting_url"],
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
        status: json["status"] == null ? null : json["status"],
        modeOfBooking:
            json["mode_of_booking"] == null ? null : json["mode_of_booking"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "sub_title": subTitle == null ? null : subTitle,
        "notes": notes == null ? null : notes,
        "meeting_url": meetingUrl == null ? null : meetingUrl,
        "date": date == null ? null : date,
        "time": time == null ? null : time,
        "status": status == null ? null : status,
        "mode_of_booking": modeOfBooking == null ? null : modeOfBooking,
        "phone_number": phoneNumber == null ? null : phoneNumber,
      };
}
