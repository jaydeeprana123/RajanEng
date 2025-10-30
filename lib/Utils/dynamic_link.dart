import 'dart:convert';

import 'package:doctor/Utils/GeneralFunctions.dart';
import 'package:doctor/Utils/preference_utils.dart';
import 'package:doctor/Utils/share_predata.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DynamicLink {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static Future<Uri> createDynamicLink({@required String? dataBunch}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: SharePreData.FIREBASELINK,
      // link: Uri.parse("https://thsindia.in/patient/"),
      link: Uri.parse('${SharePreData.FIREBASELINK}/doctor/$dataBunch'),
      androidParameters: AndroidParameters(
        packageName: SharePreData.APP_ANDROID_PACKAGE,
      ),
      iosParameters: IOSParameters(
        bundleId: SharePreData.APP_IOS_PACKAGE,
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    shortLink.shortUrl;
    return shortLink.shortUrl;
  }

  static Map generateDynamicLinkData({data}) {
    Map dataToSend = {};
    dataToSend = {
      'dynamic_link_data': {
        'data': data,
      }
    };
    return dataToSend;
  }

  // static Future<String> setDynamicLink(
  //     {required String shareType,
  //     required String encryptedKey,
  //     required String doctorId}) async {
  //   String dynamicLink = "";
  //   Map sendData = generateDynamicLinkData(data: {
  //     "ENCRYPTED_KEY": encryptedKey,
  //     "DOCTOR_ID": doctorId,
  //   });
  //
  //   String? dataBunch = jsonEncode(sendData);
  //
  //   await DynamicLink.createDynamicLink(dataBunch: dataBunch).then((shortLink) {
  //     print('Shortlink $shortLink');
  //     SharePreData.generatedDoctorDeepLink = shortLink.toString();
  //     dynamicLink = shortLink.toString();
  //
  //     if (shareType == "whatsapp") {
  //       SocialShare.shareWhatsapp(shortLink.toString());
  //     } else if (shareType == 'telegram') {
  //       SocialShare.shareTelegram(shortLink.toString());
  //     } else if (shareType == "any") {
  //       Share.share("$shortLink\n\n" +
  //           "Welcome! Experience convenient and secure consultations. Join us for expert medical care anytime, anywhere.");
  //     } else {}
  //
  //   });
  //
  //   return dynamicLink;
  // }
}
