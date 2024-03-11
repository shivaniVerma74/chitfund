import 'package:chitfund/constants/colors.dart';
import 'package:chitfund/constants/global_data.dart';
import 'package:chitfund/constants/images_url.dart';
import 'package:chitfund/constants/sized_box.dart';
import 'package:chitfund/constants/toast.dart';
import 'package:chitfund/function/navigation.dart';
import 'package:chitfund/screen/HomeScreen.dart';
import 'package:chitfund/screen/Login.dart';
import 'package:chitfund/widgets/BottomBar.dart';
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


class FillForm extends StatefulWidget {
  const FillForm({Key? key}) : super(key: key);

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  TextEditingController cityController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController contributeAmountController = TextEditingController();
  TextEditingController monthIncomeController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  bool loading = false;
  String male="male";
  String Occupation="Salaried Proffesional";
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    print('LAT: ${_currentPosition?.latitude ?? ""}');
    print('LNG: ${_currentPosition?.longitude ?? ""}');
    print('ADDRESS: ${_currentAddress ?? ""}');
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
      var address = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      print("full address: $address");
    }).catchError((e) {
      debugPrint(e);
    });
  }

  validateSignup(){
    if(cityController.text.length == 0){
      toast('Please enter your City');
    }else if(organizationController.text.length == 0){
      toast('Please enter your Organization name');
    }else if(contributeAmountController.text.length == 0){
      toast('Please enter your Contribution');
    }else if(monthIncomeController.text.length == 0){
      toast('Please enter your Monthly Income');
    }else{
      SignupApi();
    }
  }


  SignupApi() async{
    setState(() {
      loading = true;
    });
    Map<String, dynamic> params={
    'city': cityController.text,
    'gender': male,
    'occupation': Occupation,
    'organization': organizationController.text,
    'contribute_amount': contributeAmountController.text,
    'month_income': monthIncomeController.text,
    // 'referral_code': referralController.text,
    'user_id': userDataNotifier.value?.id,
      'latitude': _currentPosition?.latitude.toString(),
      'longitude':_currentPosition?.longitude.toString(),
    };

    print("fill_form_request_is_____$params");

    var response = await http.post(Uri.parse(ApiUrls.add_user_info), body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    if(jsonResponse['response_code'].toString() == "1"){
      pushAndRemoveUntil(context: context, screen: BottomBar());
      print('fill_form_response_is_____${jsonResponse}_________');
    }else{
      toast('Something went wrong');
    }

  }

  @override
  void initState() {
    _getCurrentPosition();
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
              ParagraphText('Fill the form to join group', fontSize: 20, fontWeight: FontWeight.w600, color: MyColors.blackColor,),
              vSizedBox05,
              ParagraphText('Please create your account', fontSize: 15, color: MyColors.grey2,),
              vSizedBox20,
              ParagraphText('City *', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,

              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: cityController,
                  hintText: 'City'),
              vSizedBox10,

              ParagraphText('Gender *', fontSize: 15, color: MyColors.grey2,),
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


              ParagraphText('Occupation *', fontSize: 15, color: MyColors.grey2,),
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

              ParagraphText('Name of your organization *', fontSize: 15, color: MyColors.grey2,),

              vSizedBox10,
              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: organizationController,
                  hintText: 'Organization Name'),
              vSizedBox10,

              ParagraphText('Amount you wish to contribute every month *', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,

              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: contributeAmountController,
                  keyboardType: TextInputType.number,
                  hintText: 'Contribution Amount'),
              vSizedBox10,
              ParagraphText('Monthly Income *', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,

              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: monthIncomeController,
                  keyboardType: TextInputType.number,
                  hintText: 'Monthly Income'),
              vSizedBox10,

              ParagraphText('Referral Code (Optional)', fontSize: 15, color: MyColors.grey2,),
              vSizedBox10,
              CustomTextField(
                  width: MediaQuery.of(context).size.width,
                  controller: referralController,
                  hintText: 'Referral Code'),
              vSizedBox10,



              RoundEdgedButton(
                text: 'Signup',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                isLoad: loading,
                onTap: (){
                  validateSignup();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}