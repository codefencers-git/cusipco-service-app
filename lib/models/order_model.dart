// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  String? success;
  String? status;
  String? message;
  List<OrderData>? data;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        success: json["success"] == null ? null : json["success"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<OrderData>.from(
                json["data"].map((x) => OrderData.fromJson(x))),
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

class OrderData {
  OrderData({
    this.id,
    this.customOrderId,
    this.status,
    this.paymentStatus,
    this.statusLable,
    this.itemTotal,
    this.restaurantName,
    this.grandTotal,
    this.createdAt,
  });

  String? id;
  String? customOrderId;
  String? status;
  String? paymentStatus;
  String? statusLable;
  String? itemTotal;
  String? restaurantName;
  String? grandTotal;
  String? createdAt;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json["id"] == null ? null : json["id"],
        customOrderId:
            json["custom_order_id"] == null ? null : json["custom_order_id"],
        status: json["status"] == null ? null : json["status"],
        paymentStatus:
            json["payment_status"] == null ? null : json["payment_status"],
        statusLable: json["status_lable"] == null ? null : json["status_lable"],
        itemTotal: json["item_total"] == null ? null : json["item_total"],
        restaurantName:
            json["restaurant_name"] == null ? null : json["restaurant_name"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "custom_order_id": customOrderId == null ? null : customOrderId,
        "status": status == null ? null : status,
        "payment_status": paymentStatus == null ? null : paymentStatus,
        "status_lable": statusLable == null ? null : statusLable,
        "item_total": itemTotal == null ? null : itemTotal,
        "restaurant_name": restaurantName == null ? null : restaurantName,
        "grand_total": grandTotal == null ? null : grandTotal,
        "created_at": createdAt == null ? null : createdAt,
      };
}
