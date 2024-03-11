import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitfund/Model/user_model.dart';
import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/HomeScreen.dart';
import 'package:chitfund/screen/Login.dart';
import 'package:chitfund/widgets/appBar.dart';
import 'package:chitfund/services/api_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:chitfund/screen/otp_screen.dart';
import 'package:chitfund/widgets/custom_text.dart';
import 'package:chitfund/widgets/custom_text_field.dart';
import 'package:chitfund/widgets/round_edge_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController contributeAmountController = TextEditingController();
  TextEditingController monthIncomeController = TextEditingController();
  bool loading = false;
  String male="male";
  String Occupation="Salaried Proffesional";
  late File imgFile;
  final imgPicker = ImagePicker();
  var selectedimage;
  var stored_image_path;

  void _image_camera_dialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Select an Image',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
              onPressed: () {
                openGallery();
                Navigator.pop(context);
              },
              child: Text(
                'Select a photo from Gallery',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
          CupertinoActionSheetAction(
              onPressed: () {
                openCamera();
                Navigator.pop(context);
              },
              child: Text(
                'Take a photo with the camera',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      selectedimage = imgFile;
      print('image upload$imgFile');
    });
  }

  void openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      selectedimage = imgFile;
      print('image upload$imgFile');
    });
  }


  EditProfileApi() async{
    setState(() {
      loading = true;
    });

    var request = await  http.MultipartRequest("POST", Uri.parse(ApiUrls.update_profile));

    request.fields.addAll({
      'name': nameController.text,
      'city': cityController.text,
      'gender': male,
      'occupation': Occupation,
      'organization': organizationController.text,
      'contribute_amount': contributeAmountController.text,
      'month_income': monthIncomeController.text,
      'user_id': "${userDataNotifier.value!.id}",
    });

   if(selectedimage != null){
     request.files.add(await http.MultipartFile.fromPath('p_image', selectedimage.path));
   }
    print("edit_profile_request_is_____${request.fields} image is ${request.files} & url_is____ ${ApiUrls.update_profile}");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var jsonResponse = convert.jsonDecode(responseString);
    setState(() {
      loading = false;
    });

    if(jsonResponse['response_code'].toString() == "1"){
      userDataNotifier.value = User_data.fromJson(jsonResponse['user']);
      Navigator.pop(context);
      toast('${jsonResponse['message']}');
      print('edit_profile_response_is_____${jsonResponse}_________');
    }else{
      toast('Something went wrong');
    }

  }

  autoFill(){
      stored_image_path = userDataNotifier.value?.image.toString();
      nameController.text = userDataNotifier.value!.username.toString();
      cityController.text = userDataNotifier.value!.city.toString();
      male = userDataNotifier.value!.gender.toString();
      Occupation = userDataNotifier.value!.occupation.toString();
      organizationController.text = userDataNotifier.value!.organization.toString();
      contributeAmountController.text = userDataNotifier.value!.contributeAmount.toString();
      monthIncomeController.text = userDataNotifier.value!.monthIncom.toString();

      setState(() {});
  }


  @override
  void initState() {
    print("checkkk ${userDataNotifier.value!.gender.toString()}");
    print("checkkk ${userDataNotifier.value!.occupation.toString()}");
    autoFill();
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
              ParagraphText('Edit Profile', fontSize: 20, fontWeight: FontWeight.w600, color: MyColors.blackColor,),
              vSizedBox20,

              if(userDataNotifier.value?.image == null && (selectedimage == null ||selectedimage == "" ))
              Center(
                child: GestureDetector(
                  onTap: () {
                    _image_camera_dialog(context);
                  },
                  child:  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border:
                        Border.all(color: MyColors.primaryColor)),
                    child: Icon(
                      Icons.camera_alt,
                      color: MyColors.primaryColor,
                      size: 30,
                    )

                  ),
                ),
              ),

              if((selectedimage == null || selectedimage == "") && userDataNotifier.value?.image != null)
                Stack(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                           border: Border.all(color: MyColors.primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              height: 120,
                              width: 120,
                              imageUrl: "${ApiUrls.imageUrl}${userDataNotifier.value?.image}",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    
                    Positioned(
                        bottom: 5,
                        right: 110,
                        child: GestureDetector(
                          onTap: (){
                            userDataNotifier.value?.image = null;
                            _image_camera_dialog(context);

                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.whiteColor,
                                borderRadius: BorderRadius.circular(100)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(Icons.edit, color: MyColors.primaryColor,),
                              )),
                        ))
                  ],
                ),

              if((selectedimage != null || selectedimage != "") && userDataNotifier.value?.image == null)
                Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      height: 120,
                      width: 120,
                      File(selectedimage?.path??""),
                      fit: BoxFit.cover,
                    )),
              ),




              ParagraphText('Name', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,

              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: nameController,
                  hintText: 'Name'),
              vSizedBox10,

              ParagraphText('City', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,

              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: cityController,
                  hintText: 'City'),
              vSizedBox10,

              ParagraphText('Gender', fontSize: 15, color: MyColors.grey2,),
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: MyColors.primaryColor,
                ),
                child:   Row(
                  children: [
                    Radio(
                        value: "male",
                        groupValue: male,
                        activeColor: MyColors.primaryColor,
                        onChanged: (val) {
                          setState(() {
                            male = val!;
                          });
                        }
                    ),

                    ParagraphText('Male', fontSize: 15, color: MyColors.grey2,),
                    hSizedBox10,

                    Radio(
                        value: "female",
                        groupValue: male,
                        activeColor: MyColors.primaryColor,
                        onChanged: (val) {
                          setState(() {
                            male = val!;
                          });
                        }
                    ),

                    ParagraphText('Female', fontSize: 15, color: MyColors.grey2,),
                  ],
                ),
              ),

              vSizedBox10,


              ParagraphText('Occupation', fontSize: 15, color: MyColors.grey2,),
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: MyColors.primaryColor,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Radio(
                              value: "Salaried Proffesional",
                              groupValue: Occupation,
                              activeColor: MyColors.primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  Occupation = val!;
                                });
                              }
                          ),
                        ),

                        ParagraphText('Salaried Proffesional', fontSize: 15, color: MyColors.grey2,),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "Self Employed",
                            groupValue: Occupation,
                            activeColor: MyColors.primaryColor,
                            onChanged: (val) {
                              setState(() {
                                Occupation = val!;
                              });
                            }
                        ),

                        ParagraphText('Self Employed', fontSize: 15, color: MyColors.grey2,),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(
                            value: "Student",
                            groupValue: Occupation,
                            activeColor: MyColors.primaryColor,
                            onChanged: (val) {
                              setState(() {
                                Occupation = val!;
                              });
                            }
                        ),

                        ParagraphText('Student', fontSize: 15, color: MyColors.grey2,),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(
                            value: "HouseWife",
                            groupValue: Occupation,
                            activeColor: MyColors.primaryColor,
                            onChanged: (val) {
                              setState(() {
                                Occupation = val!;
                              });
                            }
                        ),

                        ParagraphText('HouseWife', fontSize: 15, color: MyColors.grey2,),
                      ],
                    ),
                  ],
                ),
              ),
              vSizedBox10,

              ParagraphText('Name of your organization', fontSize: 15, color: MyColors.grey2,),

              vSizedBox10,
              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: organizationController,
                  hintText: 'Organization Name'),
              vSizedBox10,

              ParagraphText('Amount you wish to contribute every month', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,

              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: contributeAmountController,
                  keyboardType: TextInputType.number,
                  hintText: 'Contribution Amount'),
              vSizedBox10,
              ParagraphText('Monthly Income', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,

              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: monthIncomeController,
                  keyboardType: TextInputType.number,
                  hintText: 'Monthly Income'),
              vSizedBox10,

              RoundEdgedButton(
                text: 'Update',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                isLoad: loading,
                onTap: (){
                  EditProfileApi();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}