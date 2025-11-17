import 'dart:convert';
import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:rajan_engineers/Screens/HomeBottomNav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rajan_engineers/Screens/Authentication/model/login_response.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> mobileNumText = TextEditingController().obs;
  Rx<TextEditingController> passwordText = TextEditingController().obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  /// Call Login with only mobile. After success it sends the OTP from the server to verify
  Future<void> callLoginWithMobileAPI(BuildContext context) async {
    isLoading.value = true;

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://rjn.bnrpl.com/api/admin/login'),
    );

    request.body = json.encode({
      "email": "admin@gmail.com",
      "password": "admin@123",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    isLoading.value = false;

    if (response.statusCode == 200) {
      // Read stream ONLY ONCE
      String responseBody = await response.stream.bytesToString();
      print("API Response => $responseBody");

      Map<String, dynamic> jsonMap = json.decode(responseBody);
      LoginResponse loginModel = LoginResponse.fromJson(jsonMap);

      if (loginModel.status ?? false) {
        // Save token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", loginModel.data?.token ?? "");

        Get.offAll(HomeBottomNav());
      } else {
        Get.snackbar("Error", loginModel.message ?? "");
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
