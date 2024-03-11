import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/appBar.dart';
import 'package:chitfund/widgets/custom_text.dart';
import 'package:chitfund/widgets/custom_text_field.dart';
import 'package:chitfund/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:lottie/lottie.dart';


class MyWallet extends StatefulWidget {
  MyWallet({Key? key,}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool loading = false;
  List transactionList = [];
  TextEditingController paymentAddressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  getTransactionApi() async{
    setState(() {loading =true;});

    Map<String,dynamic> params={
      'user_id': userDataNotifier.value?.id.toString(),
    };
    print("getTransaction_request_is_______ ${params} & url_is__ ${ApiUrls.get_withdrawal_transactions}");

    final response = await http.post(Uri.parse(ApiUrls.get_withdrawal_transactions), body: params);

    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {loading =false;});
    print("getTransaction_response_is_______ ${jsonResponse}");

    if(jsonResponse['error'] == false){
      transactionList = jsonResponse['data'];
      print("transactionList_____${transactionList}");
    }else{
      print("transactionList_____${jsonResponse['data']}");
      toast('${jsonResponse['message']}');
    }

  }

  requestPaymentApi(mysetState) async{
    mysetState(() {loading =true;});

    Map<String,dynamic> params={
      'user_id': userDataNotifier.value?.id.toString(),
      'payment_address': paymentAddressController.text,
      'amount': amountController.text,
    };
    print("send_request_is_______ ${params} & url_is__ ${ApiUrls.send_withdrawal_request}");

    final response = await http.post(Uri.parse(ApiUrls.send_withdrawal_request), body: params);

    var jsonResponse = convert.jsonDecode(response.body);

    mysetState(() {loading =false;});
    print("send_response_is_______ ${jsonResponse}");

    if(jsonResponse['error'] == false){
      Navigator.pop(context);
      userDataNotifier.value?.balance = jsonResponse['data'];
      setState(() {});
    }else{
      print("balance_is_____${userDataNotifier.value?.balance}");
      Navigator.pop(context);
      toast('${jsonResponse['message']}');
    }

  }


  @override
  void initState() {
    getTransactionApi();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: 'My Wallet'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withOpacity(0.8)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ParagraphText("Available Balance",fontSize: 18 , fontWeight: FontWeight.w600, color: MyColors.whiteColor,),
                    ParagraphText("${userDataNotifier.value?.balance}", color: MyColors.whiteColor,),
                  ],
                ),
              ),
            ),
            vSizedBox20,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ParagraphText('Transactions', fontWeight: FontWeight.w600, color: MyColors.primaryColor,),

                  for(int i=0; i< transactionList.length; i++)
                  loading == true
                      ? Center(
                      child: CupertinoActivityIndicator(
                        radius: 12,
                        color: MyColors.blackColor,
                      ))
                      :
                  transactionList == null || transactionList.length == 0 ? Center(child: ParagraphText("No Data Found..!!", color: MyColors.black54Color,),) :
                  Padding(
                    padding: const EdgeInsets.symmetric( vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.primaryColor, width: 1),
                          color: MyColors.boxBackgroundColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
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
                                    ParagraphText('Amount: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                    ParagraphText('${transactionList[i]['amount']}', fontSize: 12, ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ParagraphText('Request Status: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                    transactionList[i]['status'].toString() =="0"?
                                    ParagraphText('Pending', fontSize: 12, color: MyColors.blue,):
                                    transactionList[i]['status'].toString() =="1"?
                                    ParagraphText('Approve', fontSize: 12, color: MyColors.green4,):
                                    transactionList[i]['status'].toString() =="3"?
                                    ParagraphText('Rejected', fontSize: 12, color: MyColors.red3,):Text("")
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ParagraphText('Transaction Type: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                ParagraphText('${transactionList[i]['type']}', fontSize: 12, ),
                              ],
                            ),
                            Wrap(
                              children: [
                                ParagraphText('Message: ', fontSize: 12, fontWeight: FontWeight.w600,),
                                ParagraphText('${transactionList[i]['message']}', fontSize: 12, ),
                              ],
                            ),
                            vSizedBox05,





                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RoundEdgedButton(
          text: 'Payment Request',
          onTap: (){
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
                                      Text('Withdrawl Request',
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
                                      controller: paymentAddressController,
                                      hintText: 'Mobile/UPI/Cash Request Number'),

                                  vSizedBox10,
                                  CustomTextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      hintText: 'Enter amount'),


                                  RoundEdgedButton(
                                    text: 'Apply',
                                    color: MyColors.primaryColor,
                                    isLoad: loading,
                                    loaderColor: MyColors.whiteColor,
                                    borderRadius: 10,
                                    onTap: () async{
                                       requestPaymentApi(dialog_setState);
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
        ),
      ),

    );
  }
}
