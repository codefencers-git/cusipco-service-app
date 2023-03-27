import 'dart:async';

import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/global_variable_for_show_messge.dart';

import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/models/appointment_detail_model.dart';
import 'package:healu_doctor_app/services/provider_service/appointment_details_service.dart';

import 'package:healu_doctor_app/widgets/button_widget/rounded_button_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AlertDialogForOTPVafication extends StatefulWidget {
  AlertDialogForOTPVafication(
      {Key? key, required this.appointmentDetails, required this.status})
      : super(key: key);

  String status;
  AppointmentDetailData? appointmentDetails;
  @override
  State<AlertDialogForOTPVafication> createState() =>
      _AlertDialogForOTPVaficationState();
}

class _AlertDialogForOTPVaficationState
    extends State<AlertDialogForOTPVafication> {
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeClass.blueColorlight3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      contentPadding: EdgeInsets.all(10),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "OTP Verification",
                style: TextStyle(
                    color: ThemeClass.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _buildOtpTextBox(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ButtonWidget(
                title: "Verify",
                radius: 10,
                heightPadding: 5,
                fontSize: 12,
                color: ThemeClass.blueColor,
                callBack: () {
                  // Navigator.pop(context);

                  _varifyOTP();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildOtpTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Form(
          key: formKey,
          child: PinCodeTextField(
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            length: 4,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            validator: (v) {
              if (v!.length < 4) {
                return GlobalVariableForShowMessage.pleasEenterVaildOTP;
              } else {
                return null;
              }
            },
            errorTextSpace: 25,
            textStyle: TextStyle(
                fontSize: 25,
                color: ThemeClass.blueColor,
                fontWeight: FontWeight.w600),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              fieldOuterPadding: EdgeInsets.all(2),
              fieldHeight: 40,
              fieldWidth: 40,
              selectedFillColor: ThemeClass.whiteColor,
              inactiveFillColor: ThemeClass.whiteColor,
              activeFillColor: ThemeClass.whiteColor,
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              selectedColor: ThemeClass.blueColor.withOpacity(0.2),
            ),
            scrollPadding: EdgeInsets.all(0),
            cursorColor: ThemeClass.blueColor,
            animationDuration: Duration(milliseconds: 300),
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: textEditingController,
            keyboardType: TextInputType.number,
            onCompleted: (v) {
              print("Completed");
            },
            onChanged: (value) {},
            beforeTextPaste: (text) {
              print("Allowing to paste $text");

              return true;
            },
          ),
        ),
      ),
    );
  }

  _varifyOTP() async {
    if (formKey.currentState!.validate()) {
      var res = await AppointmentDetailService().updateAppointmentDetails(
          id: widget.appointmentDetails!.id.toString(),
          status: widget.status,
          otp: textEditingController.text);
      if (res == true) {
        Navigator.pop(context, true);
      }
    }
  }
}
