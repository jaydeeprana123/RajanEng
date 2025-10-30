import 'dart:convert';

import 'package:doctor/Screens/Dashboard/model/dashboard_analytics_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Authentication/Register/model/signup_model.dart';
import '../Screens/ChatWithUser/model/call_notification_model.dart';
import 'GeneralFunctions.dart';

// Created by Vrusti Patel

Future setuplocator() async {
  GetIt locator = GetIt.instance;
  var instance = await MySharedPref.getInstance();
  locator.registerSingleton<MySharedPref>(instance);
}

class MySharedPref {
  static MySharedPref? classInstance;
  static SharedPreferences? preferences;

  static Future<MySharedPref> getInstance() async {
    classInstance ??= MySharedPref();
    preferences ??= await SharedPreferences.getInstance();
    return classInstance!;
  }

  Future<void> setString(String key, String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    printData(runtimeType.toString(),"Value Set ::::::$key :::::::::: $content");
    prefs.setString(key, content);
  }

  Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    printData(runtimeType.toString(),"Value set ::::::$value");
    prefs.setBool(key, value);
  }

  getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key) ?? "";
    printData(runtimeType.toString(),"Value set ::::::$key :::::::::: $stringValue");
    return stringValue;
  }

  getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    bool? boolVal = prefs.getBool(key);
    printData(runtimeType.toString(),"Value get ::::::$boolVal");
    return boolVal;
  }

  setRememberModel(SignupModel model, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    printData(runtimeType.toString(),"Value set model ::::::${model.data!.id}");
    prefs.setString(key, json.encode(model.toJson()));
  }

  // It clears preference data by unique key name
  Future<void> clearData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.remove(key);
  }

  // It clears preference whole data
  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.clear();
  }

  // Used to save user's information
  setSignupModel(SignupModel model, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(model.toJson()));
  }


  // Used to save user's information
  setNotificationModel(CallNotificationModel model, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    prefs.setString(key, json.encode(model.toJson()));
  }


  // Used to get user's information
  Future<CallNotificationModel?> getNotificationModel(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var myJson = prefs.getString(key);


    printData(runtimeType.toString(),"myJson "+ myJson.toString());

    if (myJson == null) {
      return null;
    }
    return CallNotificationModel.fromJson(json.decode(myJson));
  }
 // Used to get dashboard analytics
  setDashboardAnalytics(DashboardAnalyticsModel model, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(model.toJson()));
  }

  // Used to get user's information
  Future<SignupModel?> getSignupModel(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var myJson = prefs.getString(key);
    if (myJson == null) {
      return null;
    }
    return SignupModel.fromJson(json.decode(myJson));
  }

// Used to get user's information
  Future<DashboardAnalyticsModel?> getDashboardAnalytics(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var myJson = prefs.getString(key);
    if (myJson == null) {
      return null;
    }
    return DashboardAnalyticsModel.fromJson(json.decode(myJson));
  }

  Future<SignupModel?> getRememberModel(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var myJson = prefs.getString(key);
    if (myJson == null) {
      return null;
    }
    return SignupModel.fromJson(json.decode(myJson));
  }
}
