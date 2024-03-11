import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/appBar.dart';
import 'package:chitfund/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:lottie/lottie.dart';


class AuctionResult extends StatefulWidget {
  bool? fromDashboard;
  AuctionResult({Key? key, this.fromDashboard}) : super(key: key);

  @override
  State<AuctionResult> createState() => _AuctionResultState();
}

class _AuctionResultState extends State<AuctionResult> {
  bool loading = false;
  List auctionResult = [];


  auctionResultApi() async{
    setState(() {loading =true;});

    Map<String,dynamic> params={
      'user_id': userDataNotifier.value?.id.toString(),
    };

    print("get_auction_bid_winners_request_is_______ ${params} & url_is__ ${ApiUrls.get_auction_bid_winners}");

    final response = await http.post(Uri.parse(ApiUrls.get_auction_bid_winners), body: params);
    var jsonResponse = convert.jsonDecode(response.body);
    setState(() {loading =false;});

    if(jsonResponse['response_code'].toString() == "1"){
      print("get_auction_bid_winners_response_is_______ ${jsonResponse}");
      auctionResult = jsonResponse['data'];
      print("auctionResult_____${auctionResult}");
    }else{
      print("auctionResult_____${jsonResponse['data']}");
      toast('${jsonResponse['message']}');
    }

  }



  @override
  void initState() {
    auctionResultApi();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromDashboard == true? AppBar(
        title: Text("Auction Result"),
        backgroundColor: MyColors.primaryColor,
      ):appBar(context: context, title: 'Auction Result'),
      body: loading == true
          ? Center(
          child: CupertinoActivityIndicator(
            radius: 12,
            color: MyColors.blackColor,
          ))
          :
      auctionResult == null || auctionResult.length == 0 ? Center(child: ParagraphText("No Data Found..!!", color: MyColors.black54Color,),) :
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              MyImages.lottie_congrats,
              width: 350
            ),
            ListView.builder(
                itemCount: auctionResult.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return  Column(
                    children: [
                          Padding(
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
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ParagraphText('Group Name: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                                ParagraphText('${auctionResult[index]['group_name']}', fontSize: 12, ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ParagraphText('Chit Value: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                                ParagraphText('${auctionResult[index]['chit_value']}', fontSize: 12, ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ParagraphText('Bid Amount: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                                ParagraphText('${auctionResult[index]['bid_amount']}', fontSize: 12, ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ParagraphText('Bidder Name: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                                ParagraphText('${auctionResult[index]['bidder_name']}', fontSize: 12, ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ParagraphText('Auction Date: ',color:Colors.black, fontWeight: FontWeight.w600, fontSize: 12,),
                                                ParagraphText('${auctionResult[index]['auction_date']}',color:Colors.black, fontSize: 12,),
                                              ],
                                            ),
                                            ParagraphText('Winner', fontSize: 12, fontWeight: FontWeight.w600, color: MyColors.green4,),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: MyColors.boxBorderColor, width: 1),
                                        color: MyColors.primaryColor.withOpacity(0.8),
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                    ),)
                                ],
                              ),
                            ),
                          )
                    ],
                  );
                }),
          ],
        ),
      ),

    );
  }
}
