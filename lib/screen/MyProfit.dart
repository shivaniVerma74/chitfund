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


class MyProfit extends StatefulWidget {
  const MyProfit({Key? key}) : super(key: key);

  @override
  State<MyProfit> createState() => _MyProfitState();
}

class _MyProfitState extends State<MyProfit> {
  bool loading = false;
  String? investment;
  String? earn;
  String? profit;
  String? loss;

  getProfitLossApi() async{
    setState(() {loading =true;});

    Map<String,dynamic> params={
      'user_id': userDataNotifier.value?.id.toString(),
    };
    print("getProfitLoss_request_is_______ ${params} & url_is__ ${ApiUrls.get_profit_loss}");

    final response = await http.post(Uri.parse(ApiUrls.get_profit_loss), body: params);

    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {loading =false;});
    print("getProfitLoss_response_is_______ ${jsonResponse}");

    if(jsonResponse['response_code'].toString() == "1"){
      investment = jsonResponse['invest'].toString()??"";
      earn = jsonResponse['get'].toString()??"";
      profit = jsonResponse['profit'].toString()??'';
      loss = jsonResponse['loss'].toString()??'';

      print("invest_amount_is__ $investment earn_amount_is__ $earn profit_is__ $profit loss_is__ $loss");
    }else{
      toast('${jsonResponse['message']}');
    }

  }

  @override
  void initState() {
    print("check_____________${loss == null || loss == ""}");
    getProfitLossApi();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: 'My Profit'),
      body: loading == true
          ? Center(
          child: CupertinoActivityIndicator(
            radius: 12,
            color: MyColors.blackColor,
          ))
          :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)
              ),
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ParagraphText('Investment: ', color: MyColors.whiteColor, fontWeight: FontWeight.w700, fontSize: 12,),
                        ParagraphText('$investment',color: MyColors.whiteColor, fontSize: 12,),
                      ],
                    ),
                    Row(
                      children: [
                        ParagraphText('Earned Amount: ', color: MyColors.whiteColor, fontWeight: FontWeight.w700, fontSize: 12,),
                        ParagraphText('$earn',color: MyColors.whiteColor, fontSize: 12,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),

      bottomNavigationBar:  Container(
        width: double.infinity,
        color: MyColors.primaryColor.withOpacity(0.8),
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
          profit != null || profit != ""?
          Row(
           mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ParagraphText('Total Profit: ', fontWeight: FontWeight.w700,color: MyColors.whiteColor, fontSize: 12,),
              ParagraphText('$profit', fontSize: 12,color: MyColors.whiteColor,),
            ],
          ):
          Row(
           mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ParagraphText('Total Loss: ', fontWeight: FontWeight.w700,color: MyColors.whiteColor, fontSize: 12,),
              ParagraphText('$loss', fontSize: 12,color: MyColors.whiteColor,),
            ],
          ),

        ),
      ),

    );
  }
}
