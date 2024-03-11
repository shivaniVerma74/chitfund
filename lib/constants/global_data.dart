import 'package:chitfund/Model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;
ValueNotifier<User_data?> userDataNotifier = ValueNotifier(null);