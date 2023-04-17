import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/global_method.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/models/appointment_detail_model.dart';
import 'package:cusipco_doctor_app/services/provider_service/appointment_details_service.dart';
import 'package:cusipco_doctor_app/widgets/button_widget/rounded_button_widget.dart';
import 'package:cusipco_doctor_app/widgets/text_boxes/text_box_normal.dart';

class AlertDialogForAddNotesMeeting extends StatefulWidget {
  AlertDialogForAddNotesMeeting(
      {Key? key, required this.isfor, required this.appointmentDetails})
      : super(key: key);
  String isfor;
  AppointmentDetailData? appointmentDetails;
  @override
  State<AlertDialogForAddNotesMeeting> createState() =>
      _AlertDialogForAddNotesMeetingState();
}

class _AlertDialogForAddNotesMeetingState
    extends State<AlertDialogForAddNotesMeeting> {
  final TextEditingController _notesController = TextEditingController();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.isfor == "notes"
                        ? "Add Notes"
                        : widget.isfor == "meeting"
                            ? "Add Meeting URL"
                            : "Add OTP",
                    style: TextStyle(
                        color: ThemeClass.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.close),
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextBoxSimpleWidgetFOrAlert(
              hinttext: widget.isfor == "notes"
                  ? "add notes"
                  : widget.isfor == "meeting"
                      ? "add Meeting URL"
                      : "Enter OTP",
              radius: 10,
              controllers: _notesController,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ButtonWidget(
                title: "Submit",
                radius: 10,
                heightPadding: 5,
                fontSize: 12,
                color: ThemeClass.blueColor,
                callBack: () {
                  // Navigator.pop(context);

                  _updateData();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _updateData() async {
    if (_notesController.text.isEmpty) {
      showToast("Please fill value");
    } else {
      if (widget.isfor == "notes") {
        var res = await AppointmentDetailService().updateAppointmentDetails(
            id: widget.appointmentDetails!.id.toString(),
            // status: widget.appointmentDetails!.status,
            notes: _notesController.text);
        if (res == true) {
          Navigator.pop(context, true);
        }
      } else if (widget.isfor == "meeting") {
        var res = await AppointmentDetailService().updateAppointmentDetails(
            id: widget.appointmentDetails!.id.toString(),
            meetingUrl: _notesController.text);

        if (res == true) {
          // return true;
          Navigator.pop(context, true);
        }
      } else {
        var res = await AppointmentDetailService().updateAppointmentDetails(
            id: widget.appointmentDetails!.id.toString(),
            status: "Completed",
            otp: _notesController.text);
        if (res == true) {
          // return true;
          Navigator.pop(context, true);
        }
      }
    }
  }
}
