import 'package:flutter/material.dart';
import 'package:cusipco_doctor_app/Global/themedata.dart';
import 'package:cusipco_doctor_app/services/main_navigaton_prowider_service.dart';
import 'package:cusipco_doctor_app/services/provider_service/general_info_service.dart';
import 'package:cusipco_doctor_app/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NeedSupportScreen extends StatefulWidget {
  NeedSupportScreen({Key? key}) : super(key: key);

  @override
  State<NeedSupportScreen> createState() => _NeedSupportScreenState();
}

class _NeedSupportScreenState extends State<NeedSupportScreen> {
  @override
  void initState() {
    print("---------------init state called of profile");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(65.0),
              child: AppBarWithTextAndBackWidget(
                isShowBack: true,
                isShowRightIcon: true,
                onbackPress: () {
                  Provider.of<MainNavigationProwider>(context, listen: false)
                      .chaneIndexOfNavbar(0);
                },
                title: "Help & Support",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Consumer<GeneralInfoService>(
                    builder: (context, prowidergeneralService, child) {
                  if (prowidergeneralService.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ThemeClass.blueColor,
                      ),
                    );
                  } else if (prowidergeneralService.isError) {
                    return Center(
                      child: Text(prowidergeneralService.errorMessage),
                    );
                  } else {}
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListTile1(
                          "Contact Number",
                          prowidergeneralService.generalInfoData!.contactNo
                              .toString(),
                          "assets/icons/telephone_icon.png",
                          true),
                      _buildListTile1(
                          "Email",
                          prowidergeneralService.generalInfoData!.contactEmail
                              .toString(),
                          "assets/icons/email_icon.png",
                          false),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildListTile1(String title, String subTitle, String icon, bool isNumber) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          if (isNumber) {
            _lauch("tel://${subTitle}");
          } else {
            _lauch("mailto://${subTitle}");
          }
        },
        child: Row(
          children: [
            Expanded(
                child: Center(
              child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: ThemeClass.blueColorlight2.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    icon,
                  ),
                ),
              ),
            )),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: ThemeClass.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                    Text(subTitle,
                        style: TextStyle(
                            color: ThemeClass.blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500))
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _lauch(value) async {
    try {
      if (!await launchUrl(Uri.parse("${value}"))) throw 'Could not launch';
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
