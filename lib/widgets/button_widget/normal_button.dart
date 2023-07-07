import 'package:flutter/material.dart';

import '../../Global/themedata.dart';

class NormalButton extends StatelessWidget {
  const NormalButton(
      {Key? key,
        this.isLoading = false,
        required this.title,
        required this.color,
        this.fontSize = 16,
        this.radius = 30,
        this.isdisable = false,
        this.heightPadding = 12,
        required this.callBack, this.width, this.icon,   this.fontsize})
      : super(key: key);
  final bool isLoading;
  final bool isdisable;
  final String title;
  final double? fontsize;
  final Function callBack;
  final IconData? icon;
  final Color color;
  final double fontSize;
  final double radius;
  final double heightPadding;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: isdisable ? color.withOpacity(0.5) : color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              color,color
            ],
          ),
        ),
        width: width ?? MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            if (!isdisable) {
              callBack();
            }
          },
          child: Row(
            mainAxisAlignment: (icon!= null) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(icon!= null)  Container(),
              if(icon!= null) Icon(icon, color: Colors.white,),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: isLoading
                    ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  ),
                )
                    : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: fontsize,
                  ),
                ),
              ),

              if(icon!=null)  Container(),Container(),
            ],
          ),
        ),
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
