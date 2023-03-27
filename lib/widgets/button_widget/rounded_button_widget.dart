import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      this.isLoading = false,
      required this.title,
      required this.color,
      this.fontSize = 16,
      this.radius = 30,
      this.isdisable = false,
      this.heightPadding = 12,
      required this.callBack})
      : super(key: key);
  final bool isLoading;
  final bool isdisable;
  final String title;
  final Function callBack;
  final Color color;
  final double fontSize;
  final double radius;
  final double heightPadding;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            // horizontal: 50,
            vertical: heightPadding,
          ),
          child: isLoading
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.white,
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize,
                  ),
                ),
        ),
        color: isdisable ? color.withOpacity(0.5) : color,
        onPressed: () {
          if (!isdisable) {
            callBack();
          }
        },
      ),
    );
  }
}

class MinButton extends StatelessWidget {
  const MinButton(
      {Key? key,
      this.isLoading = false,
      required this.title,
      required this.color,
      this.fontSize = 16,
      this.radius = 30,
      this.isdisable = false,
      this.heightPadding = 12,
      required this.callBack})
      : super(key: key);
  final bool isLoading;
  final bool isdisable;
  final String title;
  final Function callBack;
  final Color color;
  final double fontSize;
  final double radius;
  final double heightPadding;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            // horizontal: 50,
            vertical: heightPadding,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ),
        color: isdisable ? color.withOpacity(0.5) : color,
        onPressed: () {
          if (!isdisable) {
            callBack();
          }
        },
      ),
    );
  }
}
