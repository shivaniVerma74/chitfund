import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/GroupDetail.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/appBar.dart';
import 'package:chitfund/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UpcomingAuctions extends StatefulWidget {
  bool? fromDashboard;
  UpcomingAuctions({Key? key, this.fromDashboard}) : super(key: key);

  @override
  State<UpcomingAuctions> createState() => _UpcomingAuctionsState();
}

class _UpcomingAuctionsState extends State<UpcomingAuctions> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List groupList = [
    {
      "grp_title": "CapitalCrafters",
      "chit_value": "50000",
    },
    {
      "grp_title": "WealthWeavers",
      "chit_value": "100000",
    },
    {
      "grp_title": "CashFlow Collective",
      "chit_value": "150000",
    },
    {
      "grp_title": "CoinVault Club",
      "chit_value": "200000",
    },
    {
      "grp_title": "BullionBuilders",
      "chit_value": "225000",
    },
    {
      "grp_title": "MoneyMinds Network",
      "chit_value": "250000",
    },
    {
      "grp_title": "WealthWave Consortium",
      "chit_value": "275000",
    },
    {
      "grp_title": "CapitalCatalysts",
      "chit_value": "300000",
    },
  ];





  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColors.backgroundColor,
           appBar: widget.fromDashboard == true? AppBar(
             title: Text("Upcoming Auctions"),
             backgroundColor: MyColors.primaryColor,
           ):
           appBar(context: context, title: 'Upcoming Auctions'),
          body: loading == true
              ? Center(
              child: CupertinoActivityIndicator(
                radius: 12,
                color: MyColors.blackColor,
              ))
              :
          groupList == null || groupList.length == 0 ? Center(child: ParagraphText("No Data Found..!!", color: MyColors.black54Color,),) :
          ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: MyColors.boxBorderColor, width: 1),
                        color: MyColors.boxBackgroundColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                child: Image.asset(MyImages.bid_group, width: 120,)),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Wrap(
                                      children: [
                                        ParagraphText(
                                          '${groupList[index]['grp_title']}',
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  vSizedBox05,
                                  ParagraphText(
                                    '${groupList[index]['chit_value']}',
                                    fontSize: 9,
                                    maxline: 2,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.primaryColor,
                                  ),




                                ],
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   height: 20,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color: MyColors.boxBorderColor, width: 1),
                        //       color: MyColors.primaryColor.withOpacity(0.8),
                        //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                        //   ),)
                      ],
                    ),
                  ),
                );
              }),

        ),
      ),
    );
  }
}
