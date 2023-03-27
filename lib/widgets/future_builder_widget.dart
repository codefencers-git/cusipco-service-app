import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/screens/main_screen/earnings/earning_model.dart';

class FutureBuildWidget extends StatelessWidget {
  FutureBuildWidget(
      {Key? key,
      required this.child,
      this.errorchild,
      required this.future,
      this.errorMessage,
      this.isList = false})
      : super(key: key);
  Function child;
  Widget? errorchild;
  dynamic future;

  String? errorMessage;
  bool isList;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (isList) {
                  if (snapshot.data.isNotEmpty) {
                    return child(data: snapshot.data);
                  } else {
                    return errorchild ??
                        _buildDataNotFound1(errorMessage ?? "Data Not Found!");
                  }
                } else {
                  return child(snapshot.data);
                }
              } else {
                return errorchild ??
                    _buildDataNotFound1(errorMessage ?? "Data Not Found!");
              }
            } else if (snapshot.hasError) {
              return _buildDataNotFound1(snapshot.error.toString());
            } else {
              return errorchild ??
                  _buildDataNotFound1(errorMessage ?? "Data Not Found!");
            }
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 300, left: 20, right: 20),
                child: CircularProgressIndicator(color: ThemeClass.blueColor),
              ),
            );
          }
        });
  }

  Padding _buildDataNotFound1(
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 300, left: 20, right: 20),
      child: Center(child: Text("$text")),
    );
  }
}
