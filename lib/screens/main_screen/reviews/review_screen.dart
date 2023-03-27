import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healu_doctor_app/Global/themedata.dart';
import 'package:healu_doctor_app/screens/main_screen/reviews/review_model.dart';
import 'package:healu_doctor_app/screens/main_screen/reviews/review_service.dart';
import 'package:healu_doctor_app/services/main_navigaton_prowider_service.dart';

import 'package:healu_doctor_app/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewScreen extends StatefulWidget {
  ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  _reFreshData() async {
    var prov = Provider.of<ReviewService>(context, listen: false);
    prov.getReviews(isShowLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: ThemeClass.safeareBackGround,
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Consumer<ReviewService>(
                      builder: (context, provReview, child) {
                    if (provReview.isLoadingReview) {
                      return Center(child: _Loading());
                    } else if (provReview.isErrorReview) {
                      return Center(
                        child:
                            _buildDataNotFound1(provReview.errorMessageReview),
                      );
                    } else if (provReview.globalReviewData == null ||
                        provReview.globalReviewData!.isEmpty) {
                      return Center(
                        child: _buildDataNotFound1("Review Not Found"),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...provReview.globalReviewData!
                              .map((e) => _buildReviewListTile(e))
                              .toList(),
                          provReview.globalReviewData!.length == 1
                              ? SizedBox(
                                  height: height * 0.7,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          provReview.globalReviewData!.length == 2
                              ? SizedBox(
                                  height: height * 0.4,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    }
                  }),
                ),
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
      padding: const EdgeInsets.only(top: 300, left: 20, right: 20),
      child: Center(child: Text("$text")),
    );
  }

  Padding _Loading() {
    return Padding(
      padding: const EdgeInsets.only(top: 300, left: 20, right: 20),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBarWithTextAndBackWidget(
          isShowBack: true,
          isShowRightIcon: true,
          onbackPress: () {
            Provider.of<MainNavigationProwider>(context, listen: false)
                .chaneIndexOfNavbar(0);
          },
          title: "Received Reviews",
        ));
  }

  Padding _buildReviewListTile(ReviewData? review) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: review!.image.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(50)),
                ),
                placeholder: (context, url) => CircularProgressIndicator(
                  color: ThemeClass.orangeColor,
                  strokeWidth: 3,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: ThemeClass.blackColor,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    Text(
                      // formatBookingDate(data[index].date.toString()),
                      review.date.toString(),
                      // DateFormatting()
                      //     .dmyTOymd(data[index].date.toString().substring(0, 10)),
                      style: TextStyle(
                          fontSize: 10,
                          color: ThemeClass.blueColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              RatingBar(
                initialRating: review.rating != null
                    ? double.parse(review.rating.toString())
                    : 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 16,
                itemCount: 5,
                ignoreGestures: true,
                ratingWidget: RatingWidget(
                  full: _image('assets/icons/star_fill.png'),
                  half: _image('assets/icons/star_half.png'),
                  empty: _image('assets/icons/start_empty.png'),
                ),
                itemPadding: const EdgeInsets.symmetric(horizontal: 0.7),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.review.toString(),
            style: TextStyle(
                fontSize: 12,
                color: ThemeClass.greyColor,
                fontWeight: FontWeight.w400),
          ),
          Divider(
            height: 15,
            color: ThemeClass.blueColor.withOpacity(0.3),
          )
        ],
      ),
    );
  }

  _image(String image) {
    return Image.asset(image);
  }

  _lauch(value) async {
    try {
      if (!await launchUrl(Uri.parse("${value}"))) throw 'Could not launch';
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
