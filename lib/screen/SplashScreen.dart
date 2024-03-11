import 'package:chitfund/Model/user_model.dart';
import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/HomeScreen.dart';
import 'package:chitfund/screen/Login.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/BottomBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  String? user_id;

  go_to_sign_in_page() async{
    prefs=await SharedPreferences.getInstance();

    user_id = prefs.getString("userId");
    print("user_id_is_______ $user_id");

     if(user_id != null ){
       await getUserDetailApi();
       pushAndRemoveUntil(context: context, screen: BottomBar());
     }else{
       pushReplacement(context: context, screen: Login());
     }
  }

  getUserDetailApi() async{
    user_id = prefs.getString("userId");

    Map<String,dynamic> request ={
      'user_id': user_id,
    };
    print("get_user_request_is_______ ${request} & url_is__ ${ApiUrls.get_user}");

    final response = await http.post(Uri.parse(ApiUrls.get_user), body: request);
    var jsonResponse = convert.jsonDecode(response.body);

    if(jsonResponse['response_code'].toString() == "1"){
      userDataNotifier.value = User_data.fromJson(jsonResponse['user']);
      print("get_user_response_is_______ ${jsonResponse}");
    }
  }



  @override
  void initState() {
    go_to_sign_in_page();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.purple,
      body:Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.asset(MyImages.splash_logo, width: 200,height: 200,))
      ),

    );
  }

}