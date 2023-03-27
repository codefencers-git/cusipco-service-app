import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/services/provider_service/general_info_service.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

String time24to12Format(String time) {
  if (time.toLowerCase().contains("pm") || time.toLowerCase().contains("am")) {
    return time;
  } else {
    int h = int.parse(time.split(":").first);
    int m = int.parse(time.split(":").last.split(" ").first);
    String send = "";
    if (h > 12) {
      var temp = h - 12;
      send =
          "0$temp:${m.toString().length == 1 ? "0" + m.toString() : m.toString()} " +
              "PM";
    } else {
      send =
          "$h:${m.toString().length == 1 ? "0" + m.toString() : m.toString()}  " +
              "AM";
    }
    return send;
  }
}

String time12to24Format(String time) {
  if (time.toLowerCase().contains("pm") || time.toLowerCase().contains("am")) {
    DateTime date = DateFormat.jm().parse(time);
    return DateFormat("HH:mm").format(date);
  } else {
    return time;
  }
}

Widget buildIOSSwitch(bool value, ValueChanged<bool>? onChanged) =>
    Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
          thumbColor: Colors.white,
          trackColor: ThemeClass.greyColor.withOpacity(0.5),
          activeColor: ThemeClass.blueColor,
          value: value,
          onChanged: onChanged),
    );

showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
  );
}

getFilterdedColor(String value) {
  if (value == "Delivered") {
    return ThemeClass.greenColor;
  } else if (value == "Canceled" || value == "Rejected") {
    return ThemeClass.redColor;
  } else {
    return ThemeClass.orangeColor;
  }
}

getFilterdedColor2(String value) {
  if (value == "Accepted" || value == "Preparing" || value == "Dispatched") {
    return ThemeClass.orangeColor;
  } else if (value == "Delivered") {
    return ThemeClass.greenColor;
  } else {
    return ThemeClass.redColor;
  }
}

getOrderDetailsStaus(String value) {
  if (value == "Accepted" || value == "Preparing" || value == "Dispatched") {
    return "view_order_for_pickup";
  } else if (value == "Out-For-Delivery") {
    return "view_order_for_complete";
    // after that it will got to map screen and complete order
  } else {
    return "order_compeleted";
  }
}

getDateFormated(String date) {
  try {
    var tdate = DateTime.parse(date);
    var dateNumber = DateFormat.d().format(tdate);
    var datemonh = DateFormat.yMMM().format(tdate);
    return dateNumber + "" + " " + datemonh;
  } catch (e) {
    return date;
  }
}

String convertYYYY_MM_DDtoDD_MM_YYYY(String date) {
  var temp = date.split("-");
  try {
    return temp[2] + "-" + temp[1] + "-" + temp[0];
  } catch (e) {
    return date;
  }
}

String convertDD_MM_YYYYtoYYYY_MM_DD(String date) {
  var temp = date.split("-");

  try {
    return temp[0] + "-" + temp[1] + "-" + temp[2];
  } catch (e) {
    return date;
  }
}

checkAppUpdate(BuildContext context, {required bool isShowNormalAlert}) async {
  var generalProw = Provider.of<GeneralInfoService>(context, listen: false);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  int? _versionFromAPI = Platform.isAndroid
      ? getExtendedVersionNumber(
          generalProw.generalInfoData!.appoinmentApp!.appVersion.toString())
      : getExtendedVersionNumber(
          generalProw.generalInfoData!.appoinmentApp!.appVersionIos.toString());

  int? _versionFromAPIForceUpdate = getExtendedVersionNumber(generalProw
      .generalInfoData!.appoinmentApp!.forceUpdateVersion
      .toString());

  int? _appversion = getExtendedVersionNumber(version);

  String _appLink = Platform.isAndroid
      ? generalProw.generalInfoData!.appoinmentApp!.playstoreUrl.toString()
      : generalProw.generalInfoData!.appoinmentApp!.appstoreUrl.toString();

  if (_versionFromAPI != null &&
      _versionFromAPIForceUpdate != null &&
      _appversion != null) {
    //
    // check force update
    if (_versionFromAPIForceUpdate > _appversion) {
      var res = await _updateAlert(context, true);
      if (res != null && res == true) {
        _openBrowser(_appLink);
      }
    }
    //
    // check normal update
    else if (_versionFromAPI > _appversion) {
      if (isShowNormalAlert) {
        var res = await _updateAlert(context, false);
        if (res) {
          _openBrowser(_appLink);
        }
      }
    } else {
      print("--------------  app is upto date   -------------");
    }
  } else {
    print("--------------  version is not formated   -------------");
  }
}

Future _updateAlert(BuildContext context, bool isForce) {
  return showDialog(
    barrierDismissible: !isForce,
    context: context,
    builder: (BuildContext context1) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(!isForce);
        },
        child: AlertDialog(
          title: Text('New Version Available.'),
          content: Text('Please update the application'),
          actions: [
            !isForce
                ? TextButton(
                    child: Text("Remind me later"),
                    onPressed: () {
                      Navigator.pop(context1, false);
                    },
                  )
                : SizedBox(),
            TextButton(
              child: Text("Update"),
              onPressed: () {
                Navigator.pop(context1, true);
              },
            )
          ],
        ),
      );
    },
  );
}

Future<void> _openBrowser(String url) async {
  if (url == null || url == "") {
    showToast("Update link is not available");
  } else {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}

int? getExtendedVersionNumber(String version) {
  try {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  } catch (e) {
    return null;
  }
}
