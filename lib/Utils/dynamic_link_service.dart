import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  static Future<Uri> createDoctorDynamicLink({required String encryptedKey, required String doctorId}) async {
    final url = 'https://medicaldoctor.page.link/patient?encryptedKey=$encryptedKey&doctorId=$doctorId';
    log('URL::::: $url');
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(url),
      uriPrefix: 'https://medicaldoctor.page.link',
      androidParameters: const AndroidParameters(
        packageName: 'com.medical.userapp',
        // fallbackUrl: Uri.parse('https://thsindia.in'),
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.medicaluser.app',
        appStoreId: '1661952894',
        fallbackUrl: Uri.parse('https://thsindia.in'),
      ),
    );
    final shortUrl = await (FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams));
    return shortUrl.shortUrl;
  }
}
