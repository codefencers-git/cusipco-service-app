// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  ReviewModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<ReviewData>? data;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<ReviewData>.from(
                json["data"].map((x) => ReviewData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ReviewData {
  ReviewData(
      {this.id, this.name, this.image, this.review, this.date, this.rating});

  String? id;
  String? name;
  String? image;
  String? review;
  String? date;
  String? rating;
  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        review: json["review"] == null ? null : json["review"],
        date: json["date"] == null ? null : json["date"],
        rating: json["rating"] == null ? null : json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
        "review": review == null ? null : review,
        "date": date == null ? null : date,
        "rating": rating == null ? null : rating,
      };
}
