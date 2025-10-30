import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:doctor/Enums/screens_enum_for_redirection.dart';
import 'package:doctor/Enums/status_enum.dart';
import 'package:doctor/Screens/Authentication/Login/view/otp_verification_login_view.dart';
import 'package:doctor/Screens/Authentication/Register/view/basic_information_view.dart';
import 'package:doctor/Screens/Authentication/Register/view/otp_verification_signup_view.dart';
import 'package:doctor/Screens/Authentication/Register/view/qualification_documents_view.dart';
import 'package:doctor/Screens/Authentication/Register/view/work_profile_view.dart';
import 'package:doctor/Screens/BottomNavigationFlow/bottom_navigation_view.dart';
import 'package:doctor/Screens/TimeSlot&Fees/BankInformation/view/bank_details_view.dart';
import 'package:doctor/Screens/TimeSlot&Fees/TimeSlot/view/doctor_availability_view.dart';
import 'package:doctor/Utils/GeneralFunctions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../Model/BaseModel.dart';
import '../../../../Networks/api_endpoint.dart';
import '../../../../Networks/api_response.dart';
import '../../../../Utils/common_widget.dart';
import '../../../../Utils/preference_utils.dart';
import '../../../../Utils/share_predata.dart';
import '../../Register/model/signup_model.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> mobileNumText = TextEditingController().obs;
  Rx<TextEditingController> passwordText = TextEditingController().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;
  RxBool boolRemember = false.obs;
  String? deviceToken;
  String? voipToken;

  @override
  void onInit() {
    super.onInit();
    printData(runtimeType.toString(), "init State");
    checkPasswordIsRemembered();
  }

  // It check Whether user selected remember password
  checkPasswordIsRemembered() async {
    var preferences = MySharedPref();
    var rememberMe =
        await preferences.getBoolValue(SharePreData.keyRememberedUserInfo);

    if (rememberMe == null) {
      await preferences.setBool(SharePreData.keyRememberedUserInfo, false);
    }
    boolRemember.value =
        await preferences.getBoolValue(SharePreData.keyRememberedUserInfo);

    if (boolRemember.value == true) {
      getStoredUserDetails();
    }
  }

  // Login Api With email/Mobile and Password
  callLoginAPI(BuildContext context) async {
    onLoading(context, '');

    printData(runtimeType.toString(), "login $deviceToken");

    String url = urlBase + urlGetLogin;
    final apiReq = Request();
    dynamic body = {
      'email': mobileNumText.value.text,
      'device_token': deviceToken ?? "",
      'password': passwordText.value.text,
      'voip_token': voipToken ?? "",
    };

    await apiReq.postAPIwithoutAuth(url, body).then((value) async {
      http.StreamedResponse res = value;

      if (res.statusCode == 200) {
        await res.stream.bytesToString().then((value) async {
          Map<String, dynamic> userModel = json.decode(value);
          BaseModel model = BaseModel.fromJson(userModel);

          if (model.statusCode == 200) {
            SignupModel loginInModel = SignupModel.fromJson(userModel);

            FirebaseAnalytics analytics = FirebaseAnalytics.instance;

            analytics.logEvent(
              name: 'login',
              parameters: <String, String>{
                'user_id': (loginInModel.data?.id ?? 0).toString(),
                'email': loginInModel.data?.email ?? "",
                'method': "Email",
                'success': "yes",
              },
            );

            /// Set response into in shared preference
            var preferences = MySharedPref();

            /// Save token in the shared preference
            await preferences.setString(
                SharePreData.keyToken, loginInModel.data?.token ?? "");

            await preferences.setSignupModel(
                loginInModel, SharePreData.keySignupModel);

            if (boolRemember.value == true) {
              await preferences.setBool(
                  SharePreData.keyRememberedUserInfo, true);
              await preferences.setString(SharePreData.keyRememberPassword,
                  passwordText.value.text.toString());
            } else {
              await preferences.setBool(
                  SharePreData.keyRememberedUserInfo, false);
            }

            /// Redirect screen on pending state
            redirectOnPendingState(loginInModel);
          } else {
            Navigator.pop(context);
            snackBar(context, model.message!);
          }
        });
      } else if (res.statusCode == 101) {
        Navigator.pop(context);
        snackBarRapid(context, "Enter valid Credentials");
      } else {
        Navigator.pop(context);
        snackBar(context, res.statusCode.toString());
      }
    });
  }

  /// Call Login with only mobile. After success it sends the OTP from the server to verify
  callLoginWithMobileAPI(BuildContext context) async {
    onLoading(context, "");

    String url = urlBase + urlLoginWithMobileNo;
    final apiReq = Request();
    dynamic body = {
      'mobile_number': mobileNumText.value.text,
    };

    await apiReq.postAPIwithoutAuth(url, body).then((value) async {
      http.StreamedResponse res = value;

      printData("callLoginWithMobileAPI", value.toString());

      if (res.statusCode == 200) {
        await res.stream.bytesToString().then((value) async {
          Map<String, dynamic> userModel = json.decode(value);
          BaseModel model = BaseModel.fromJson(userModel);

          if (model.statusCode == 200) {
            Navigator.pop(context);
            Get.to(OtpVerificationLoginView(
                mobileNo: mobileNumText.value.text, strWhereFrom: ''));
          } else {
            Navigator.pop(context);
            snackBar(context, model.message!);
          }
        });
      } else if (res.statusCode == 101) {
        Navigator.pop(context);
        snackBarRapid(context, "Enter valid Credentials");
      } else {
        Navigator.pop(context);
      }
    });
  }

  // API for verify and OTP
  callOTPVerifyAPI(BuildContext context, String mobileNo) async {
    onLoading(context, "");
    String url = urlBase + urlLoginVerifyOTP;
    final apiReq = Request();
    dynamic body = {
      'mobile_number': mobileNo,
      'device_token': deviceToken ?? "",
      'voip_token': voipToken ?? "",
      'otp': otpController.value.text
    };
    printData("callOTPVerifyAPI model.body", body.toString());
    await apiReq.postAPIwithoutAuth(url, body).then((value) async {
      http.StreamedResponse res = value;

      if (res.statusCode == 200) {
        await res.stream.bytesToString().then((value) async {
          Map<String, dynamic> userModel = json.decode(value);
          BaseModel model = BaseModel.fromJson(userModel);

          printData(
              "callOTPVerifyAPI model.statusCode", model.statusCode.toString());

          if (model.statusCode == 200) {
            var preferences = MySharedPref();
            // await preferences.setBool(SharePreData.keyOtpVerified, true);

            SignupModel loginInModel = SignupModel.fromJson(userModel);

            FirebaseAnalytics analytics = FirebaseAnalytics.instance;

            analytics.logEvent(
              name: 'login',
              parameters: <String, String>{
                'user_id': (loginInModel.data?.id ?? 0).toString(),
                'email': loginInModel.data?.mobileNumber ?? "",
                'method': "Mobile",
                'success': "yes",
              },
            );

            // Save token in the shared preference
            await preferences.setString(
                SharePreData.keyToken, loginInModel.data?.token ?? "");

            await preferences.setSignupModel(
                loginInModel, SharePreData.keySignupModel);

            if (boolRemember.value == true) {
              await preferences.setBool(
                  SharePreData.keyRememberedUserInfo, true);
              await preferences.setString(SharePreData.keyRememberPassword,
                  passwordText.value.text.toString());
            } else {
              await preferences.setBool(
                  SharePreData.keyRememberedUserInfo, false);
            }

            Navigator.pop(context);
            redirectOnPendingState(loginInModel);
          } else {
            Navigator.pop(context);
            snackBar(context, model.message!);
          }
        });
      } else if (res.statusCode == 101) {
        Navigator.pop(context);
        snackBarRapid(context, "Enter valid Credentials");
      } else {
        Navigator.pop(context);
      }
    });
  }

  /// Resend OTP
  callResendOTPApi(BuildContext context, String mobileNo) async {
    String url = urlBase + urlLoginResendOTP;
    final apiReq = Request();
    dynamic body = {
      'mobile_number': mobileNo,
    };

    await apiReq.postAPIwithoutAuth(url, body).then((value) async {
      http.StreamedResponse res = value;

      if (res.statusCode == 200) {
        await res.stream.bytesToString().then((value) async {
          Map<String, dynamic> userModel = json.decode(value);
          BaseModel model = BaseModel.fromJson(userModel);

          if (model.statusCode == 200) {
            snackBar(context, model.message!);
          } else {
            snackBar(context, model.message!);
          }
        });
      } else if (res.statusCode == 101) {
        snackBar(context, res.reasonPhrase.toString());
      }
    });
  }

  /// get user info from shared preferences
  Future<void> getStoredUserDetails() async {
    var preferences = MySharedPref();
    SignupModel? profileModel =
        await preferences.getSignupModel(SharePreData.key_UserInfoModel);

    mobileNumText.value.text = profileModel!.data!.email!;
    // passwordText.value.text = profileModel.data!.pa!;
  }

  // check validation before proceed
  bool checkValidation(context) {
    // if (emailText.value.text.isEmpty) {
    //   snackBar(context, "Enter email/mobile no");
    //   return false;
    // } else if (passwordText.value.text.isEmpty) {
    //   snackBar(context, "Enter password");
    //   return false;
    // } else
    if (passwordText.value.text.length < 6) {
      snackBar(context, "Password should not be less than 6 digits");
      return false;
    } else {
      return true;
    }
  }

  // go to screen as per which information is already filled and which is not
  void redirectOnPendingState(SignupModel signupModel) {
    if (signupModel.data!.isActive == 1) {
      navigateOnDashboard();
    } else if (signupModel.data!.isActive == 0) {
      if (signupModel.data!.isSkip == 1 || signupModel.data!.isSkip == 2) {
        Get.off(() => const BottomNavigationView());
      } else if (signupModel.data!.isSkip == 0) {
        if (signupModel.data!.token!.isEmpty) {
          Get.offAll(() => OtpVerificationSignupView(
              mobileNo: (signupModel.data!.mobileNumber.toString()),
              strWhereFrom: ScreenRedirectionComeFrom.Splash.index.toString()));
        } else if (signupModel.data?.basicInformationDone !=
            StatusEnum.Yes.index.toString()) {
          Get.offAll(() => BasicInformationView(
              ScreenRedirectionComeFrom.Splash.index.toString()));
        } else if (signupModel.data?.workProfileDone !=
            StatusEnum.Yes.index.toString()) {
          Get.offAll(() => WorkProfileView(
              ScreenRedirectionComeFrom.Splash.index.toString()));
        } else if (signupModel.data?.qualificationDocumentsDone !=
            StatusEnum.Yes.index.toString()) {
          Get.offAll(() => QualificationAndDocumentsView(
              ScreenRedirectionComeFrom.Splash.index.toString()));
        } else if (signupModel.data?.doctorAvailablityDone !=
            StatusEnum.Yes.index.toString()) {
          Get.offAll(() => DoctorAvailabilityView(
              ScreenRedirectionComeFrom.Splash.index.toString()));
        } else if (signupModel.data?.bankDetailsDone !=
            StatusEnum.Yes.index.toString()) {
          Get.offAll(() => BankDetailsView(
              ScreenRedirectionComeFrom.Splash.index.toString()));
        } else {
          navigateOnDashboard();
        }
      }
    } else if (signupModel.data!.isActive == 2) {
      navigateOnDashboard();
    }
  }

  // Navigate on dashboard
  navigateOnDashboard() {
    Get.offAll(const BottomNavigationView());

    // SplashController controller = Get.put(SplashController());
    // controller.callMedkartGenerateToken();
  }
}
