import 'dart:math';

import 'package:chitfund/Model/user_model.dart';
import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/Forgot_password.dart';
import 'package:chitfund/screen/HomeScreen.dart';
import 'package:chitfund/screen/FillForm.dart';
import 'package:chitfund/screen/otp_screen.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/custom_text.dart';
import 'package:chitfund/widgets/custom_text_field.dart';
import 'package:chitfund/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinContrller = TextEditingController();
  TextEditingController emailContrller = TextEditingController();
  TextEditingController nameContrller = TextEditingController();
  bool loading = false;
  bool is_user_exist = false;
  bool is_login = false;
  bool is_signup = false;
  String? city;


  ///validation and api Integration
  checkUserApi() async{
    if(phoneController.text.length == 0 ){
      toast('Please enter phone number');
    }else if(phoneController.text.length != 10 ){
      toast('Please enter only 10 digit phone number');
    }else{
      setState(() {loading =true;});

      Map<String,dynamic> params={
        'mobile': phoneController.text,
      };
      print("is_user_request_is_______ ${params} & url_is__ ${ApiUrls.is_user}");

      final response = await http.post(Uri.parse(ApiUrls.is_user), body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      is_user_exist = jsonResponse['status'];

      if(is_user_exist == true){
        setState(() {
          is_login = true;
        });
      }else{
        setState(() {
          is_signup = true;
        });
      }
      setState(() {loading =false;});

      print("is_user_response_is_______ ${is_user_exist}");

        loginOrSignupApi();
    }
  }

  loginOrSignupApi() async{

    if(phoneController.text.length == 0 ){
      toast('Please enter phone number');
    }else if(phoneController.text.length != 10 ){
      toast('Please enter only 10 digit phone number');
    }else if(pinContrller.text.length==0 && is_user_exist == true){
      toast('Please enter pin');
    }else if(nameContrller.text.length==0 && is_user_exist != true){
      toast('Please enter username');
    }else if(emailContrller.text.length==0 && is_user_exist != true){
      toast('Please enter email');
    }else if(emailContrller.text.length>0 && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailContrller.text) && is_user_exist != true){
      toast('Please enter valid email address');
    }else{
      setState(() {loading =true;});

      Map<String,dynamic> login_request ={
        'mobile': phoneController.text,
        'password': pinContrller.text,
      };

      Map<String,dynamic> signup_request ={
        'mobile': phoneController.text,
        'name': nameContrller.text,
        'email': emailContrller.text,
      };

      print("send_otp_request_is_______ ${is_user_exist == true? login_request : signup_request} & url_is__ ${ApiUrls.send_otp}");

      final response = await http.post(Uri.parse(ApiUrls.send_otp), body: is_user_exist == true? login_request : signup_request);
      var jsonResponse = convert.jsonDecode(response.body);

      setState(() {loading =false;});
      if(jsonResponse['response_code'].toString() == "1"){
        print("send_otp_response_is_______ ${jsonResponse}");


        if(is_user_exist == true){
          push(context: context, screen: OtpScreen(otp: jsonResponse['otp'].toString(), phoneNumber: phoneController.text,));
        }else{
          push(context: context, screen: ForgotPassword(mobile: phoneController.text, fromSignUp: true,));
        }

      }else{
        toast('Something went wrong');
      }
    }
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
              const ParagraphText('Login via Phone Number', fontSize: 20, fontWeight: FontWeight.w600, color: MyColors.blackColor,),
              vSizedBox05,
              const ParagraphText('Please enter your phone number', fontSize: 15, color: MyColors.grey2,),
              vSizedBox20,
              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  hintText: 'Phone number'),
              if(is_login == true)
              login_fields(),
              if(is_signup == true)
              signup_fields(),
              RoundEdgedButton(
                text: 'Submit',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                isLoad: loading,
                onTap: () {
                  checkUserApi();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget login_fields(){
    return Column(
      children: [
        vSizedBox20,
        CustomTextField(
            width: MediaQuery.of(context).size.width,
            controller: pinContrller,
            keyboardType: TextInputType.number,
            hintText: 'Enter Pin'),
        vSizedBox10,
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            if(phoneController.text.length == 0){
              toast('Please enter phone number');
            }else{
              push(context: context, screen: ForgotPassword(mobile: phoneController.text,));
            }
          },
          child: Align(
              alignment: Alignment.centerRight,
              child: ParagraphText('Forgot pin?')),
        )
      ],
    );
  }

  Widget signup_fields(){
    return Column(
      children: [
        vSizedBox20,
        CustomTextField(
            width: MediaQuery.of(context).size.width,
            controller: nameContrller,
            hintText: 'Enter username'),
        vSizedBox20,
        CustomTextField(
            width: MediaQuery.of(context).size.width,
            controller: emailContrller,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Enter email'),
      ],
    );
  }

}