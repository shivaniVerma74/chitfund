class user_model {
  String? responseCode;
  String? message;
  String? status;
  int? otp;
  User_data? user;

  user_model(
      {this.responseCode, this.message, this.status, this.otp, this.user});

  user_model.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    status = json['status'];
    otp = json['otp'];
    user = json['user'] != null ? new User_data.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    data['status'] = this.status;
    data['otp'] = this.otp;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User_data {
  String? id;
  String? ipAddress;
  String? username;
  String? password;
  String? email;
  String? mobile;
  String? gender;
  String? occupation;
  String? organization;
  String? contributeAmount;
  String? monthIncom;
  String? adharNumber;
  String? image;
  String? balance;
  String? activationSelector;
  String? activationCode;
  String? forgottenPasswordSelector;
  String? forgottenPasswordCode;
  String? forgottenPasswordTime;
  String? rememberSelector;
  String? rememberCode;
  String? otp;
  String? deviceToken;
  String? createdOn;
  String? lastLogin;
  String? active;
  String? company;
  String? address;
  String? bonus;
  String? dob;
  String? countryCode;
  String? city;
  String? area;
  String? street;
  String? pincode;
  String? serviceableZipcodes;
  String? apikey;
  String? referralCode;
  String? friendsCode;
  String? fcmId;
  String? latitude;
  String? longitude;
  String? createdAt;

  User_data(
      {this.id,
        this.ipAddress,
        this.username,
        this.password,
        this.email,
        this.mobile,
        this.gender,
        this.occupation,
        this.organization,
        this.contributeAmount,
        this.monthIncom,
        this.adharNumber,
        this.image,
        this.balance,
        this.activationSelector,
        this.activationCode,
        this.forgottenPasswordSelector,
        this.forgottenPasswordCode,
        this.forgottenPasswordTime,
        this.rememberSelector,
        this.rememberCode,
        this.otp,
        this.deviceToken,
        this.createdOn,
        this.lastLogin,
        this.active,
        this.company,
        this.address,
        this.bonus,
        this.dob,
        this.countryCode,
        this.city,
        this.area,
        this.street,
        this.pincode,
        this.serviceableZipcodes,
        this.apikey,
        this.referralCode,
        this.friendsCode,
        this.fcmId,
        this.latitude,
        this.longitude,
        this.createdAt});

  User_data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ipAddress = json['ip_address'];
    username = json['username']??'';
    password = json['password'];
    email = json['email'];
    mobile = json['mobile'].toString()??'';
    gender = json['gender']??'';
    occupation = json['occupation']??'';
    organization = json['organization']??'';
    contributeAmount = json['contribute_amount'].toString() ??'';
    monthIncom = json['month_incom'].toString() ?? '';
    adharNumber = json['adhar_number'].toString() ?? '';
    image = json['image'] ??'';
    balance = json['balance'];
    activationSelector = json['activation_selector']??'';
    activationCode = json['activation_code'].toString() ??'';
    forgottenPasswordSelector = json['forgotten_password_selector'].toString() ??'';
    forgottenPasswordCode = json['forgotten_password_code'].toString() ??'';
    forgottenPasswordTime = json['forgotten_password_time'].toString() ??'';
    rememberSelector = json['remember_selector']??'';
    rememberCode = json['remember_code'].toString() ??'';
    otp = json['otp'];
    deviceToken = json['device_token'] ?? '';
    createdOn = json['created_on'];
    lastLogin = json['last_login'];
    active = json['active'];
    company = json['company'];
    address = json['address']?? '';
    bonus = json['bonus']??'';
    dob = json['dob']??'';
    countryCode = json['country_code'];
    city = json['city'];
    area = json['area'];
    street = json['street'] ?? '';
    pincode = json['pincode'] ?? '';
    serviceableZipcodes = json['serviceable_zipcodes'] ?? '';
    apikey = json['apikey'] ?? '';
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'] ?? '';
    fcmId = json['fcm_id'];
    latitude = json['latitude'] ?? '';
    longitude = json['longitude'] ?? '';
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ip_address'] = this.ipAddress;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['occupation'] = this.occupation;
    data['organization'] = this.organization;
    data['contribute_amount'] = this.contributeAmount;
    data['month_incom'] = this.monthIncom;
    data['adhar_number'] = this.adharNumber;
    data['image'] = this.image;
    data['balance'] = this.balance;
    data['activation_selector'] = this.activationSelector;
    data['activation_code'] = this.activationCode;
    data['forgotten_password_selector'] = this.forgottenPasswordSelector;
    data['forgotten_password_code'] = this.forgottenPasswordCode;
    data['forgotten_password_time'] = this.forgottenPasswordTime;
    data['remember_selector'] = this.rememberSelector;
    data['remember_code'] = this.rememberCode;
    data['otp'] = this.otp;
    data['device_token'] = this.deviceToken;
    data['created_on'] = this.createdOn;
    data['last_login'] = this.lastLogin;
    data['active'] = this.active;
    data['company'] = this.company;
    data['address'] = this.address;
    data['bonus'] = this.bonus;
    data['dob'] = this.dob;
    data['country_code'] = this.countryCode;
    data['city'] = this.city;
    data['area'] = this.area;
    data['street'] = this.street;
    data['pincode'] = this.pincode;
    data['serviceable_zipcodes'] = this.serviceableZipcodes;
    data['apikey'] = this.apikey;
    data['referral_code'] = this.referralCode;
    data['friends_code'] = this.friendsCode;
    data['fcm_id'] = this.fcmId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    return data;
  }
}
