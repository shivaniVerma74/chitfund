import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/GroupDetail.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:chitfund/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  List groupList = [];

  getGroupsApi() async{
    setState(() {loading =true;});

    Map<String,dynamic> params={
      'mobile': userDataNotifier.value?.mobile.toString(),
    };
    print("get_groups_request_is_______ ${params} & url_is__ ${ApiUrls.get_groups}");

    final response = await http.post(Uri.parse(ApiUrls.get_groups), body: params);
    var jsonResponse = convert.jsonDecode(response.body);
    setState(() {loading =false;});
    if(jsonResponse['response_code'].toString() == "1"){
      print("get_groups_response_is_______ ${jsonResponse}");
      groupList = jsonResponse['data'];
      print("groupList_____${groupList}");
    }else{
      print("groupList_____${jsonResponse['data']}");
      toast('${jsonResponse['message']}');
    }

  }



  @override
  void initState() {
    getGroupsApi();
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
          drawer: get_drawer(context),
          key: scaffoldKey,
          backgroundColor: MyColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: MyColors.primaryColor,
            leading:GestureDetector(
              onTap: (){
                scaffoldKey.currentState?.openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15,horizontal:18),
                child: Icon(Icons.menu)
              ),
            ),

            title:ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child:ParagraphText( "${userDataNotifier.value?.username}", fontWeight: FontWeight.w500,fontSize: 18,),

            ),
            toolbarHeight: 73,
            titleSpacing: 0,
          ),
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
               return GestureDetector(
                 behavior: HitTestBehavior.opaque,
                 onTap: () async{
                  await push(context: context, screen: GroupDetail(group_id: groupList[index]['id'], group_detail: groupList[index],));
                  getGroupsApi();
                 },
                 child: Padding(
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
                                   ParagraphText(
                                     '${groupList[index]['grp_title']}',
                                     fontSize: 14,
                                     fontWeight:
                                     FontWeight.w600,
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
                 ),
               );
              }),

        ),
      ),
    );
  }
}
