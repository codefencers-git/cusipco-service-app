import 'dart:io';

import 'package:flutter/material.dart';

import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/services/provider_service/user_preference_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileService {
  Future<Null> cropImage(XFile? file, context) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: file!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            activeControlsWidgetColor: Colors.green,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      var userprovider = Provider.of<UserPrefService>(context, listen: false);
      userprovider.uploadImage(croppedFile,
          url: "update_profilePicture", perameterName: "image");
    }
  }

  Row buildTimerHeader() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text("Slots Availability",
              style: TextStyle(
                  color: ThemeClass.blackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 1,
          child: Text("  ",
              style: TextStyle(
                  color: ThemeClass.greyColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(" Morning Slots",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              Divider(height: 7),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text("Start Time",
                          style: TextStyle(
                              color: ThemeClass.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text("End Time",
                          style: TextStyle(
                              color: ThemeClass.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text("  ",
              style: TextStyle(
                  color: ThemeClass.greyColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(" Evening Slots",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ThemeClass.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              Divider(height: 7),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text("Start Time",
                          style: TextStyle(
                              color: ThemeClass.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text("End Time",
                          style: TextStyle(
                              color: ThemeClass.blackColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
