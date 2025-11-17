import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:rajan_engineers/Screens/Authentication/view/LoginScreenView.dart';
import 'package:rajan_engineers/Screens/Employee/view/EmployeeListScreen.dart';
import 'package:rajan_engineers/Screens/HomeBottomNav.dart';

import '../../../Styles/my_colors.dart';
import '../../../Styles/my_font.dart';
import '../../../Styles/my_icons.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  Future<void> navigateUser() async {
    await Future.delayed(const Duration(seconds: 2)); // Add splash delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      // Token found → Move to Home
      Get.offAll(() => const HomeBottomNav());
    } else {
      // No token → Login page
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your App Logo
            Icon(Icons.fitness_center, size: 80, color: Colors.blue),

            const SizedBox(height: 20),
            Text(
              "RAJAN ENGINEERS",
              style: TextStyle(
                fontSize: 22,
                fontFamily: fontMulishSemiBold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 30),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
