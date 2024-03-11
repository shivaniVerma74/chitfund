import 'package:chitfund/Model/user_model.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/HomeScreen.dart';
import 'package:chitfund/screen/FillForm.dart';
import 'package:chitfund/widgets/BottomBar.dart';
import 'package:chitfund/widgets/appBar.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/custom_text.dart';
import 'package:chitfund/widgets/otp_verification.dart';
import 'package:chitfund/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/sized_box.dart';
import '../constants/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class OtpScreen extends StatefulWidget {
  String otp;
  String phoneNumber;


  OtpScreen({Key? key, required this.otp, required this.phoneNumber, }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? correctOtp;
  bool loading = false;
  TextEditingController otpController = TextEditingController();
  showLoading() async{
    // toast('Otp matched');
  }


  ///validation and api Integration
  verifyOtpApi() async{
    if(otpController.text == '' || otpController.text == null){
      toast('Please enter otp');
    }else{
      setState(() {loading =true;});

      Map<String,dynamic> login_request ={
        'mobile': widget.phoneNumber,
        'otp': otpController.text,
      };
      print("verify_otp_request_is_______ $login_request & url_is__ ${ApiUrls.verify_otp}");
      final response = await http.post(Uri.parse(ApiUrls.verify_otp), body: login_request);
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {loading =false;});
      if(jsonResponse['response_code'].toString() == "1"){
        print("verify_otp_response_is_______ $jsonResponse");
        await prefs.setString("userId", jsonResponse['data']['id'].toString());
        userDataNotifier.value = User_data.fromJson(jsonResponse['data']);
       print("id isss ${jsonResponse['data']['id'].toString()}");
        if(jsonResponse['data']['city'] != null) {
          pushAndRemoveUntil(context: context, screen: BottomBar());
        }else{
          push(context: context, screen: FillForm());
        }
        toast('Login successfully');
      }else{
        toast('Something went wrong');
      }
    }
  }

  getOtpApi() async{
    setState(() {loading =true;});

    Map<String,dynamic> params={
      'mobile': widget.phoneNumber,
    };
    print("get_otp_request_is_______ ${params} & url_is__ ${ApiUrls.resend_otp}");

    final response = await http.post(Uri.parse(ApiUrls.resend_otp), body: params);
    var jsonResponse = convert.jsonDecode(response.body);
    setState(() {loading =false;});

    if(jsonResponse['response_code'].toString() == "1"){
      correctOtp = jsonResponse['otp'].toString();
      print("get_otp_response_is_______ ${widget.otp}");
    }

  }

  @override
  void initState() {
    correctOtp = widget.otp;

    print("correctOtp_is______$correctOtp");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: appBar(context: context),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(child: Image.asset(MyImages.splash_logo, height: 150,)),
              vSizedBox20,

              ParagraphText('Enter OTP', fontSize: 20, fontWeight: FontWeight.w600, color: MyColors.blackColor,),
              vSizedBox05,
              ParagraphText('We sent OTP on ${widget.phoneNumber}',  fontSize: 15, color: MyColors.grey2,),
              vSizedBox05,
              loading==true? Center(child: CupertinoActivityIndicator(color: MyColors.primaryColor, radius: 8,)):
              ParagraphText('Otp: ${correctOtp}', fontSize: 15, color: MyColors.grey2,),
              vSizedBox20,

              ///otp field
              OtpVerification(
                bgColor: MyColors.whiteColor,
                borderColor: Colors.transparent,
                textColor: MyColors.blackColor,
                correctOtp: correctOtp!,
                textEditingController: otpController,
                load: showLoading,
                wrongOtp: (){
                  otpController.text = '';
                  setState(() {});
                },
                navigationFrom: 'otp_screen',
              ),

              InkWell(
                onTap: (){
                  getOtpApi();
                },
                child: Align(
                    alignment: Alignment.centerRight,
                    child: ParagraphText('Resend OTP?',  color: MyColors.primaryColor,)),
              ),

              vSizedBox05,

              RoundEdgedButton(
                text: 'Submit',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                isLoad: loading,
                onTap: (){
                  verifyOtpApi();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}