import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/themedata.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget(
      {Key? key,
      this.isLoading = false,
      required this.title,
      required this.color,
      this.fontSize = 16,
      this.heightPadding = 12,
      this.isdisable = false,
      required this.callBack})
      : super(key: key);
  final bool isLoading;
  final bool isdisable;
  final String title;
  final Function callBack;
  final Color color;
  final double fontSize;
  final double heightPadding;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          callBack();
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: ThemeClass.blueColor, width: 1.5),
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                // horizontal: 50,
                vertical: heightPadding),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: ThemeClass.blueColor,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
