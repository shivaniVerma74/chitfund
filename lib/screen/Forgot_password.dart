import 'dart:math';

import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/FillForm.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/custom_text.dart';
import 'package:chitfund/widgets/custom_text_field.dart';
import 'package:chitfund/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Model/user_model.dart';
import '../constants/global_data.dart';


class ForgotPassword extends StatefulWidget {
  String mobile;
  bool? fromSignUp;
  ForgotPassword({Key? key, required this.mobile, this.fromSignUp}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController otpController = TextEditingController();
  TextEditingController pinContrller = TextEditingController();
  TextEditingController confirmPinContrller = TextEditingController();
  bool loading = false;
  String? otp ;
  bool _obscured = true;
  bool _obscured2 = true;
  final textFieldFocusNode = FocusNode();
  final textFieldFocusNode2 = FocusNode();

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  void _toggleObscured2() {
    setState(() {
      _obscured2 = !_obscured2;
      if (textFieldFocusNode2.hasPrimaryFocus) return;
      textFieldFocusNode2.canRequestFocus = false;
    });
  }

  ///validation and api Integration
  getOtpApi() async{
    setState(() {loading =true;});

    Map<String,dynamic> params={
      'mobile': widget.mobile,
    };
    print("get_otp_request_is_______ ${params} & url_is__ ${ApiUrls.resend_otp}");

    final response = await http.post(Uri.parse(ApiUrls.resend_otp), body: params);
    var jsonResponse = convert.jsonDecode(response.body);
    setState(() {loading =false;});

    if(jsonResponse['response_code'].toString() == "1"){
      otp = jsonResponse['otp'].toString();
      print("get_otp_response_is_______ ${otp}");
    }

  }

  submitApi() async {
    if(otpController.text.length==0){
      toast('Please enter otp');
    }else if(pinContrller.text.length==0){
      toast('Please enter new pin');
    }else if(confirmPinContrller.text.length==0){
      toast('Please enter confirm pin');
    }else if(confirmPinContrller.text != pinContrller.text){
      toast('You have not entered same pin');
    }else{
      setState(() {
        loading = true;
      });

      Map<String, dynamic> params = {
        'mobile': widget.mobile,
        'pin': pinContrller.text
      };

      print("forgot_request_is_______ $params & url_is__ ${ApiUrls.add_pin}");

      final response = await http.post(Uri.parse(ApiUrls.add_pin), body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        loading = false;
      });
      if (jsonResponse['response_code'].toString() == "1") {
        await prefs.setString("userId", jsonResponse['data']['id'].toString());
        userDataNotifier.value = User_data.fromJson(jsonResponse['data']);
        print("id isss hererereer${jsonResponse['data']['id'].toString()}");
        if(widget.fromSignUp == true){
          push(context: context, screen: const FillForm());
        }else{
          toast(jsonResponse['message']);
          Navigator.pop(context);
        }
        print("forgot_response_is_______ $jsonResponse");
      }
    }
  }

  @override
  void initState() {
    getOtpApi();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSizedBox100,

              Center(child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(MyImages.splash_logo, height: 150,))),

              vSizedBox40,

              ParagraphText('Create Pin', fontSize: 20, fontWeight: FontWeight.w600, color: MyColors.blackColor,),
              vSizedBox05,
              ParagraphText('Please enter otp and set your pin', fontSize: 15, color: MyColors.grey2,),
              vSizedBox05,
              loading==true? Center(child: CupertinoActivityIndicator(color: MyColors.primaryColor, radius: 8,)):
              ParagraphText('Otp: ${otp}', fontSize: 15, color: MyColors.grey2,),
              vSizedBox20,


              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter Otp'),

              vSizedBox20,
              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: pinContrller,
                  keyboardType: TextInputType.number,
                  obscureText: _obscured,
                  suffix2: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(_obscured==false? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill, color: MyColors.primaryColor,)),
                  hintText: 'New Pin'),
              vSizedBox20,
              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: confirmPinContrller,
                  keyboardType: TextInputType.number,
                  obscureText: _obscured2,
                  suffix2: GestureDetector(
                      onTap: _toggleObscured2,
                      child: Icon(_obscured2==false? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill, color: MyColors.primaryColor,)),
                  hintText: 'Confirm Pin'),
              vSizedBox10,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  getOtpApi();
                },
                child: Align(
                    alignment: Alignment.centerRight,
                    child: ParagraphText('Resend Otp?')),
              ),

              RoundEdgedButton(
                text: 'Submit',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                isLoad: loading,
                onTap: (){
                  submitApi();
                },
              )
            ],
          ),
        ),
      ),



    );
  }



}