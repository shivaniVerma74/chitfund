import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/AuctionResult.dart';
import 'package:chitfund/screen/EditProfile.dart';
import 'package:chitfund/screen/FAQ.dart';
import 'package:chitfund/screen/HomeScreen.dart';
import 'package:chitfund/screen/Login.dart';
import 'package:chitfund/screen/MyProfit.dart';
import 'package:chitfund/screen/MyWallet.dart';
import 'package:chitfund/screen/PrivacyPolicy.dart';
import 'package:chitfund/screen/TermsConditions.dart';
import 'package:chitfund/screen/UpcomingAuctions.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

Drawer get_drawer(
  BuildContext context,
) {


  return Drawer(
    backgroundColor: MyColors.primaryColor,
    child: StatefulBuilder(builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 50,
                left: 10,
                right: 10,
              ),
              child: Row(
                children: [
                  userDataNotifier.value?.image == null?
                  CupertinoActivityIndicator(color: MyColors.whiteColor, radius: 10,):
                  ValueListenableBuilder(
                    valueListenable: userDataNotifier,
                    builder: (context, userData, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: "${ApiUrls.imageUrl}${userDataNotifier.value?.image}",
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  hSizedBox10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userDataNotifier.value?.username}",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Regular",
                            fontWeight: FontWeight.w400,
                            color: MyColors.backgroundColor),
                      ),
                      Wrap(
                        children: [
                          SizedBox(
                              width: 170,
                              child: Text(
                                "${userDataNotifier.value?.email}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Regular",
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.backgroundColor),
                              )),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 50,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: EditProfile());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: PrivacyPolicy());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Privacy policy",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: TermsConditions());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Terms & Condition",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: FAQ());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "FAQ",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: UpcomingAuctions());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Auctions ",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: AuctionResult());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Auction Result ",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: MyProfit());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Profit ",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  InkWell(
                    onTap: () {
                      Scaffold.of(context).closeEndDrawer();
                      Navigator.pop(context);
                      push(context: context, screen: MyWallet());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Wallet ",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Regular",
                              fontWeight: FontWeight.w400,
                              color: MyColors.whiteColor),
                        ),
                        Icon(Icons.chevron_right, color: MyColors.whiteColor)
                      ],
                    ),
                  ),
                  vSizedBox20,
                  // InkWell(
                  //   onTap: () {
                  //     Scaffold.of(context).closeEndDrawer();
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "Payment due date",
                  //         style: TextStyle(
                  //             fontSize: 15,
                  //             fontFamily: "Regular",
                  //             fontWeight: FontWeight.w400,
                  //             color: MyColors.whiteColor),
                  //       ),
                  //       Icon(Icons.chevron_right, color: MyColors.whiteColor)
                  //     ],
                  //   ),
                  // ),
                  // vSizedBox20,
                  // InkWell(
                  //   onTap: () {
                  //     Scaffold.of(context).closeEndDrawer();
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "Upcoming Events ",
                  //         style: TextStyle(
                  //             fontSize: 15,
                  //             fontFamily: "Regular",
                  //             fontWeight: FontWeight.w400,
                  //             color: MyColors.whiteColor),
                  //       ),
                  //       Icon(Icons.chevron_right, color: MyColors.whiteColor)
                  //     ],
                  //   ),
                  // ),

                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}
