import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  bool loading = false;
  String? faq;

  faqApi() async{
    print("get_settings_request_is_______  & url_is__ ${ApiUrls.get_settings}");

    final response = await http.post(Uri.parse(ApiUrls.get_settings), body: {});
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {loading =false;});
    if(jsonResponse['error'] == false){
      faq = jsonResponse['data']['about_us'][0];
      print("get_settings_response_is_______ ${jsonResponse['data']['about_us'][0]}");
    }else{
      toast('${jsonResponse['message']}');
    }
  }

  @override
  void initState() {
    super.initState();
    faqApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: appBar(context: context,),

      body:
      loading == true ? Center(child:  CupertinoActivityIndicator(radius: 15, color: MyColors.grey11,),):
      SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:  HtmlContentViewer(
              htmlContent: '$faq',
              initialContentHeight: MediaQuery.of(context).size.height,
              initialContentWidth: MediaQuery.of(context).size.width,
            )
        ),
      ),
    );
  }
}
