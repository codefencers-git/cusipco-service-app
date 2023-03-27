import 'package:flutter/material.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/screens/main_screen/earnings/earning_model.dart';
import 'package:healu_doctor_app/screens/main_screen/earnings/earning_service.dart';
import 'package:healu_doctor_app/services/main_navigaton_prowider_service.dart';
import 'package:healu_doctor_app/widgets/appbar_widget.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EarningScreen extends StatefulWidget {
  EarningScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EarningScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<EarningScreen> {
  @override
  void initState() {
    super.initState();
  }

  _reFreshData() async {
    var prov = Provider.of<EarningService>(context, listen: false);
    prov.getEarningData(isShowLoading: false);
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
                isShowRightIcon: true,
                onbackPress: () {
                  Provider.of<MainNavigationProwider>(context, listen: false)
                      .chaneIndexOfNavbar(0);
                },
                isShowBack: true,
                title: "Earnings",
              )),
          body: Container(
            color: ThemeClass.whiteColor,
            height: height,
            width: width,
            child: RefreshIndicator(
              displacement: 40,
              onRefresh: () {
                return _reFreshData();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Consumer<EarningService>(
                    builder: (context, earningPRov, child) {
                  if (earningPRov.isLoadingEarning == true) {
                    return _Loading();
                  } else if (earningPRov.isErrorEarning == true) {
                    return _buildDataNotFound1(earningPRov.errorMessageEarning);
                  } else {
                    if (earningPRov.globalEarningData != null) {
                      return _buildView(earningPRov.globalEarningData);
                    } else {
                      return _buildDataNotFound1("Data Not Found");
                    }
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildDataNotFound1(
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Center(child: Text("$text")),
    );
  }

  Padding _Loading() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

Column _buildView(EarningData? data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTopContainer(data!.balance.toString()),
      _buildRewardTitle(),
      _buildDateAndAmount(),
      ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.history!.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildListTileItems(data.history![index]);
          }),
    ],
  );
}

Column _buildListTileItems(History history) {
  DateTime tempDate1 =
      new DateFormat("yyyy-MM-dd").parse(history.date.toString());
  var tempDate = new DateFormat("dd MMMM,yyyy").format(tempDate1);

  return Column(
    children: [
      Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tempDate,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  history.time.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: ThemeClass.greyDarkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  history.type == "Deposit"
                      ? "+ ₹${history.balance}"
                      : "- ₹${history.balance}",
                  style: TextStyle(
                    fontSize: 14,
                    color: history.status == "Failed"
                        ? ThemeClass.redColor
                        : history.type == "Deposit"
                            ? ThemeClass.greenColor
                            : ThemeClass.redColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                history.status == "Failed"
                    ? Text(
                        history.status.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: ThemeClass.redColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ],
        ),
      ),
      Divider(
        thickness: 1,
        color: ThemeClass.greyLightColor1,
      )
    ],
  );
}

Container _buildDateAndAmount() {
  return Container(
    color: ThemeClass.skyblueColor1,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Date",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Amount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Padding _buildRewardTitle() {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Text(
      "Earning History",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Container _buildTopContainer(String balance) {
  return Container(
    height: 120,
    width: double.infinity,
    color: ThemeClass.skyblueColor1,
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/walletIcon.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Available Balance",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeClass.greyDarkColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "₹ ${balance}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeClass.blueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
