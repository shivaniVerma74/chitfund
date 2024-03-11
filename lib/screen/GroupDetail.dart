import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/appBar.dart';
import 'package:chitfund/widgets/custom_text_field.dart';
import 'package:chitfund/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../widgets/custom_text.dart';


class GroupDetail extends StatefulWidget {
  String? group_id;
  Map? group_detail;
  GroupDetail({Key? key, required this.group_id, required this.group_detail}) : super(key: key);

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  TextEditingController bidAmntcontroller= TextEditingController();
  bool loading = false;

  applyBidApi(mysetState) async{
    mysetState(() {loading =true;});

    Map<String,dynamic> params={
      'group_id': widget.group_detail?['id'].toString(),
      'user_id': userDataNotifier.value?.id.toString(),
      'bid_amount': bidAmntcontroller.text,
    };

    print("apply_bid_request_is_______ ${params} & url_is__ ${ApiUrls.add_bid}");

    final response = await http.post(Uri.parse(ApiUrls.add_bid), body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    mysetState(() {loading =false;});

    if(jsonResponse['response_code'].toString() == "1"){
      print("apply_bid_response_is_______ ${jsonResponse}");
      Navigator.of(context).pop();
      toast('Bid appplied successfully');
    }else{
      print("apply_bid_response_is_______ ${jsonResponse}");
      toast('${jsonResponse['message']}');
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Group Detail #${widget.group_id}"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox20,
            Container(
              width: double.infinity,
                color: MyColors.primaryColor.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ParagraphText('${widget.group_detail!['grp_title']}',color: MyColors.whiteColor,fontWeight: FontWeight.w600,fontSize: 16,),
                )),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  vSizedBox10,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ParagraphText('Chit value: ',color:Colors.black, fontWeight: FontWeight.w600, fontSize: 12,),
                          ParagraphText('${widget.group_detail!['chit_value']}',color:Colors.black, fontSize: 12,),
                        ],
                      ),
                      Row(
                        children: [
                          ParagraphText('Auction Date: ',color:Colors.black, fontWeight: FontWeight.w600, fontSize: 12,),
                          ParagraphText('${widget.group_detail!['auction_date']}',color:Colors.black, fontSize: 12,),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ParagraphText('Total Bids: ', fontWeight: FontWeight.w600, fontSize: 12,),
                          ParagraphText('${widget.group_detail!['bids'].length}', fontSize: 12,),
                        ],
                      ),

                      Row(
                        children: [
                          ParagraphText('Auction Interval: ', fontWeight: FontWeight.w600, fontSize: 12,),
                          ParagraphText('${widget.group_detail!['duration']} ${widget.group_detail!['duration_type']}', fontSize: 12,),
                        ],
                      ),

                    ],
                  ),

                  vSizedBox10,

                ],
              ),
            ),

            Container(
              height: 25,
                width: double.infinity,
                color: MyColors.primaryColor.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ParagraphText('Start Time: ', color: MyColors.whiteColor, fontWeight: FontWeight.w600, fontSize: 12,),
                      ParagraphText('${widget.group_detail!['start_time']}',color: MyColors.whiteColor, fontSize: 12,),
                    ],
                  ),
                  Row(
                    children: [
                      ParagraphText('End Time: ',color: MyColors.whiteColor, fontWeight: FontWeight.w600, fontSize: 12,),
                      ParagraphText('${widget.group_detail!['end_time']}',color: MyColors.whiteColor, fontSize: 12,),
                    ],
                  ),
                ],
              ),
            ),
            ),
            vSizedBox40,


            ///biding data
            for(int i=0; i<widget.group_detail!['bids'].length; i++)
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.primaryColor, width: 1),
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
                                  ParagraphText('Bid Amount: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                  ParagraphText('${widget.group_detail!['bids'][i]['bid_amount']}', fontSize: 12, ),
                                ],
                              ),
                              Row(
                                children: [
                                  ParagraphText('Bidder Name: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                  ParagraphText('${widget.group_detail!['bids'][i]['username']}', fontSize: 12, ),
                                ],
                              ),
                            ],
                          ),
                          vSizedBox05,

                          if(widget.group_detail!['bids'][i]['winner'].toString() == '1')
                            ParagraphText('Winner', fontSize: 12, fontWeight: FontWeight.w600, color: MyColors.green4,),




                        ],
                      ),
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
            )


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,  ),
                child: StatefulBuilder(
                    builder: (context, dialog_setState) {

                      return AlertDialog(
                        backgroundColor:   MyColors.backgroundColor,
                        insetPadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ///heading
                                    Text('Apply Bid',
                                      style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                          onTap: ()=> Navigator.pop(context),
                                          child: Icon(CupertinoIcons.multiply)),
                                    ),
                                  ],
                                ),
                                Divider(),
                                vSizedBox20,

                                CustomTextField(
                                    controller: bidAmntcontroller,
                                    hintText: 'Enter Bid Amount'),


                                RoundEdgedButton(
                                  text: 'Apply Bid',
                                  color: MyColors.primaryColor,
                                  isLoad: loading,
                                  loaderColor: MyColors.whiteColor,
                                  borderRadius: 10,
                                  onTap: () async{
                                    await applyBidApi(dialog_setState);
                                    Navigator.of(context).pop();

                                  },
                                ),


                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              );
            },
          );
        },
        backgroundColor: MyColors.primaryColor,
        child: const Icon(Icons.add),
      ),

    );
  }


}
