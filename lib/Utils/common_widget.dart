import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:doctor/Enums/TimeUnitEnum.dart';
import 'package:doctor/Screens/Authentication/Login/view/login_screen_view.dart';
import 'package:doctor/Styles/my_colors.dart';
import 'package:doctor/Utils/common_widget.dart';
import 'package:doctor/Styles/my_font.dart';
import 'package:doctor/Utils/GeneralFunctions.dart';
import 'package:doctor/Utils/preference_utils.dart';
import 'package:doctor/Utils/share_predata.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../Styles/my_icons.dart';
import '../main.dart';

File imagePath = File("");

String doctorsPrefix = "Doctors_";
String usersPrefix = "Users_";
String chatPrefix = "Chat_";
String channelPrefix = "Channel_";

createdDateConverted(String originalDate) {
  String result;
  var date = DateTime.parse(originalDate);
  result = DateFormat("d MMM, yyyy | hh:mm a").format(date);
  return result;
}

String utcTo12HourFormat(String bigTime) {
  // print("bigTime " + bigTime);

  // print("bigTime " + bigTime);

  DateTime tempDate = DateFormat("hh:mm").parse(bigTime);
  var dateFormat = DateFormat("h:mm a"); // you can change the format here
  var utcDate = dateFormat.format(tempDate); // pass the UTC time here
  var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
  String createdDate = dateFormat.format(DateTime.parse(localDate));
  // print("------------$createdDate");
  return createdDate;
}

snackBar(BuildContext? context, String message) {
  // const snackBar = SnackBar(
  //   elevation: 6.0,
  //   backgroundColor: Colors.black,
  //   behavior: SnackBarBehavior.floating,
  //   content: Text(
  //     "Snack bar test",
  //     style: TextStyle(color: Colors.white),
  //   ),
  // );

  // return snackBar;

  // if (!Get.isOverlaysOpen) {
  GetSnackBar(
    backgroundColor: blue_3093bb,
    duration: const Duration(seconds: 2),
    snackPosition: SnackPosition.TOP,
    borderRadius: 10.r,
    margin: EdgeInsets.symmetric(
      horizontal: 15.mw,
      vertical: 15.mh,
    ),
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(
      message,
      style: TextStyle(
          fontFamily: fontMulishRegular,
          fontSize: responsiveFontSize(context!, 14).msp,
          color: Colors.white),
    ),
  ).show();
  // }
}

snackBarRapid(BuildContext context, String message) {
  if (!context.mounted) return;

  GetSnackBar(
    backgroundColor: red_e44b41,
    duration: const Duration(seconds: 3 ?? 2),
    snackPosition: SnackPosition.TOP,
    borderRadius: 10.r,
    margin: EdgeInsets.symmetric(
      horizontal: 15.mw,
      vertical: 15.mh,
    ),
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(
      message,
      style: TextStyle(
          fontFamily: fontMulishRegular,
          fontSize: responsiveFontSize(context, 14).msp,
          color: Colors.white),
    ),
  ).show();
  // return ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text(message),
  //     duration: const Duration(seconds: 1),
  //   ),
  // );
}

String validateAadharcard(String value) {
  String pattern = r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Aadhar card Number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter Valid Aadhar card Number';
  }
  return "";
}

String validatePancard(String value) {
  String pattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Pancard Number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter Valid Pancard Number';
  }
  return "";
}

String validateDrivingLicense(String value) {
  String pattern =
      r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter DrivingLicense ID';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter Valid DrivingLicense ID';
  }
  return "";
}

String validateAccountNumber(String value) {
  String pattern = '[0-9]{9,18}';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Account Number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter Valid Account Number';
  }
  return "";
}

String validateUpiID(String value) {
  String pattern = '[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter UPI ID';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter valid UPI ID';
  }
  return "";
}

String validateIFSC(String value) {
  String pattern = '^[A-Z]{4}0[A-Z0-9]{6}\$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter IFSC';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter valid IFSC';
  }
  return "";

  // It should be 11 characters long.
  // The first four characters should be upper case alphabets.
  // The fifth character should be 0.
  // The last six characters usually numeric, but can also be alphabetic.
}

String validateRegistrationNumber(String value) {
  RegExp regex = RegExp(r'(?=.*\d)(?=.*[A-Z])');
  if (value.isEmpty) {
    return 'Please enter registration number';
  } else {
    if (!regex.hasMatch(value)) {
      return 'Enter valid registration number';
    } else {
      return "";
    }
  }

  /*
  r'^
    (?=.*[A-Z])       // should contain at least one upper case
    (?=.*[a-z])       // should contain at least one lower case
    (?=.*?[0-9])      // should contain at least one digit
    (?=.*?[!@#\$&*~]) // should contain at least one Special character
      .{8,}             // Must be at least 8 characters in length
  $
  */
}

Future<Uint8List?> showImagePickerWeb(BuildContext context) {
  return showModalBottomSheet<Uint8List?>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final bytes = await _getFileWeb(ImageSource.gallery);
                  Navigator.of(context).pop(bytes);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.photo_camera),
              //   title: const Text('Camera'),
              //   onTap: () async {
              //     final bytes = await _getFileWeb(ImageSource.camera);
              //     Navigator.of(context).pop(bytes);
              //   },
              // ),
            ],
          ),
        ),
      );
    },
  );
}

Future<Uint8List?> _getFileWeb(ImageSource source) async {
  final XFile? pickedFile = await ImagePicker().pickImage(source: source);
  if (pickedFile == null) return null;
  return pickedFile.readAsBytes();
}

void onLoading(BuildContext context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(gifHeartbeat, height: 80.mh, width: 80.mw)),
      );
      // child: const CircularProgressIndicator(backgroundColor: Colors.white,
      //   valueColor: AlwaysStoppedAnimation<Color>(
      //     blue_3093bb, //<-- SEE HERE
      //   ),)
      // ),
      // );
    },
  );
}

getCommaSeparatedStrings(String stringArray) {
  String result;
  final removedBrackets = stringArray.substring(1, stringArray.length - 1);
  final parts = removedBrackets.split(', ');

  result = parts.map((part) => part).join(', ');
  return result;
}

void onLoadingWithText(BuildContext context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 55),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                  color: Colors.white,
                  // width: 250,
                  child: Row(
                    children: [
                      Image.asset(gifHeartbeat, height: 80.mh, width: 80.mw),
                      Expanded(
                        flex: 1,
                        child: DefaultTextStyle(
                          style: TextStyle(
                              height: 1.5,
                              fontSize: responsiveFontSize(context, 14).msp,
                              fontFamily: fontMulishSemiBold,
                              color: black_1e1f20),
                          child: const Text(
                            "Your documents are\nuploading please wait..",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ))),
        ),
      );
      // child: const CircularProgressIndicator(backgroundColor: Colors.white,
      //   valueColor: AlwaysStoppedAnimation<Color>(
      //     blue_3093bb, //<-- SEE HERE
      //   ),)
      // ),
      // );
    },
  );
}

convertedDateFormat(String original) {
  DateTime tempDate = DateFormat("yyyy-MM-dd").parse(original);
  return DateFormat("dd/MM/yyyy").format(tempDate);
}

convertedDateForRevenue(String original) {
  String result;
  DateTime currentDate =
      DateFormat(SharePreData.dateFormate1).parse(DateTime.now().toString());
  DateTime yesterdayDate = DateFormat(SharePreData.dateFormate1)
      .parse(DateTime.now().subtract(const Duration(days: 1)).toString());
  DateTime tempDate = DateFormat("yyyy-MM-dd").parse(original);

  if (currentDate == tempDate) {
    result = "Today";
  } else if (yesterdayDate == tempDate) {
    result = "Yesterday";
  } else {
    result = DateFormat("dd/MM").format(tempDate);
  }

  return result;
}

convertDate(String originalDate) {
  String result;
  var date = DateTime.parse(originalDate);
  result = DateFormat("d MMM, yyyy HH:mm a").format(date);
  return result;
}

getDateOnly(String originalDate) {
  String result;
  var date = DateTime.parse(originalDate);
  result = DateFormat("d MMM, yyyy").format(date);
  return result;
}

convertDateInto12hrsFormat(String originalDate, String time) {
  DateTime tempDate = DateFormat("yyyy-MM-dd").parse(originalDate);
  String date = DateFormat("d MMM, yyyy").format(tempDate);

  DateTime strTime =
      DateFormat("HH:mm:ss").parse(time); // think this will work better for you
  String strConvertedTime = DateFormat("hh:mm a").format(strTime);

  return "$date $strConvertedTime";
}

convertedDate(String original) {
  var newStr = '${original.substring(0, 10)} ${original.substring(11, 23)}';
  DateTime dt = DateTime.parse(newStr);
  //DateTime tempDate = new DateFormat("dd MM yyyy").parse(newStr);
  var date = DateFormat("dd MMM, yyyy").format(dt);
  return date.toString();
}

String coversionDateTime(String dateTimes) {
  printData('Plan purchased date, time', dateTimes);
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime time = dateFormat.parse(dateTimes);
  var date = DateTime.parse(dateTimes);
  String result = DateFormat("dd/MM/yyyy").format(date);
  // String result = DateFormat("yyyy-MM-dd").format(date);
  String formattedTime = DateFormat('hh:mm a').format(time);

  printData('Converted date and time', "$result at $formattedTime");
  return "$result at $formattedTime";
}

Future _getFile(ImageSource source) async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: source,
  );
  print("Image Path " + pickedFile!.path);

  if (pickedFile != null) {
    return imagePath = File(pickedFile.path);
  } else {
    return "";
  }
}

Future showImagePicker(context) {
  // imagePath = null;
  Future<void> future = showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0))),
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    _getFile(ImageSource.gallery)
                        .then((value) => Navigator.of(context).pop());
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _getFile(ImageSource.camera)
                      .then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          ),
        ),
      );
    },
  );
  return future;
}

Future<void> downloadPdf(BuildContext context, String pdfUrl) async {
  onLoading(context, "Downloading...");
  bool downloading = false;
  var path = "No Data";

  String progress = '';
  Dio dio = Dio();
  final status = await Permission.storage.request();
  if (status.isGranted) {
    String dirloc = "";
    if (PlatformHelper.isAndroid) {
      dirloc = "/sdcard/download/";
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }

    try {
      FileUtils.mkdir([dirloc]);
      await dio.download(pdfUrl, "$dirloc$pdfUrl",
          onReceiveProgress: (receivedBytes, totalBytes) {
        print('here 1');
        downloading = true;
        progress =
            "${((receivedBytes / totalBytes) * 100).toStringAsFixed(0)}%";
        print(progress);
        print('here 2');
      });
    } catch (e) {
      print('catch catch catch');
      print(e);
    }

    downloading = false;
    progress = "";
    path = "$dirloc$pdfUrl";

    print(path);
    print('here give alert-->completed');

    var dirloc1 = "/sdcard/download/";
    var path1 = "$dirloc1$pdfUrl";
    if (File(path1).existsSync()) {
      OpenFilex.open(path1);
    }
  } else {
    progress = "-101";
    downloadPdf(context, pdfUrl);
  }

  Navigator.pop(context);
}

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(
    uri,
  )) {
    throw 'Could not launch $url';
  }
}

Future<File> getImageFileFromUrl(String imageLink) async {
  final url = Uri.parse(imageLink);
  final response = await http.get(url);
  final bytes = response.bodyBytes;
  final buffer = bytes.buffer;

  final temp = await getTemporaryDirectory();
  final path = "${temp.path}/image.jpg";
  File(path).writeAsBytesSync(bytes);
  return File(path).writeAsBytes(
      buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
}

int getMyAge(DateTime birthdate) {
  //the birthday's date
  final birthday = birthdate;

  DateTime dateFrom = DateTime.now();
  final difference = dateFrom.difference(birthday).inDays;

  return difference;
}

String validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return "";
}

calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

// Get chat database
String getChatDatabaseWithDoctor(
    String doctorId, String userId, String bookingId) {
  return "$chatPrefix${doctorId}_${userId}_$bookingId";
}

String checkLeftTime(String time) {
  String result = "";
  printData(time, time[0]);
  if (time[0] != "-") {
    final split = time.split(RegExp('[:.]'));
    String hours = split[0];
    String minutes = split[1];
    // String seconds = split[2];

    //  print("Date Difference received $hours$minutes");

    if (hours == "0" || hours == "00") {
      result = "$minutes mins left";
    } else if (minutes == "0" || minutes == "00") {
      result = "$hours hrs left";
    } else if (hours != "0" ||
        hours != "00" ||
        minutes != "0" ||
        minutes != "00") {
      result = "$hours hrs $minutes mins left";
    }
    // print("result$result");
  } else {
    result = "";
  }

  return result;
}

// Get chat database
String getDoctorDatabase(String doctorId) {
  return "$doctorsPrefix$doctorId";
}

// Get chat database
String getDoctorMainDatabase() {
  return "Doctors";
}

// Time to show in user list
String getTimeToShowInUserChatList(Timestamp timeStamp) {
  String timeTosHow = "";

  var now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day);
  final previousDate = DateTime(now.year, now.month, now.day - 1);
  final chatDate = timeStamp.toDate();

  var sdf = DateFormat('yyyy-MM-dd');
  var timeFormat = DateFormat('h:mm a');
  String todayDateInString = sdf.format(date);
  String yesterdayDateInString = sdf.format(previousDate);
  String chatDateInString = sdf.format(chatDate);
  String timingOfToday = timeFormat.format(chatDate);

  if (chatDateInString == todayDateInString) {
    timeTosHow = timingOfToday;
  } else if (chatDateInString == yesterdayDateInString) {
    timeTosHow = "Yesterday";
  } else {
    timeTosHow = chatDateInString;
  }

  return timeTosHow;
}

twodatesDifference(String toDate, String fromDate) {
  DateTime dt1 = DateTime.parse(toDate);
  DateTime dt2 = DateTime.parse(fromDate);

  Duration diff = dt1.difference(dt2);

  return diff.inDays.toString();
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

String getCurrentDate(String format) {
  printData("Date Format", format);

  String date;
  var now = DateTime.now();
  var formatter = DateFormat(format);
  date = formatter.format(now);

  printData("Current Date", date);
  return date;
}

// Convert 24 hours time into 12 hours
String convert24To12HoursFormat(DateTime? dateTime) {
  String timeIn12Hours = "";
  if (dateTime != null) {
    final dateFormat = DateFormat('h:mm a');
    timeIn12Hours = dateFormat.format(dateTime);
  }

  return timeIn12Hours;
}

String formatDateddmmmmyyy(String date) {
  DateTime tempDate = DateFormat(SharePreData.dateFormate1).parse(date);

  final dateFormat = DateFormat(SharePreData.dateFormate2);
  return dateFormat.format(tempDate);
}

String formatDateddmmhhm(DateTime date) {
  // DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);

  final dateFormat = DateFormat("dd MMM  hh:mm aa");
  return dateFormat.format(date);
}

String formatDatehhmm(DateTime date) {
  // DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);

  final dateFormat = DateFormat("hh:mm aa");
  return dateFormat.format(date);
}

String formatDateddmmyyyy(DateTime date) {
  // DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);

  final dateFormat = DateFormat("dd MM yyyy");
  return dateFormat.format(date);
}

// Convert bytes into kbmb
String convertSizeIntoKBMB(int bytes) {
  String sizeInKBMB = "";
  final kb = bytes / 1024;
  final mb = kb / 1024;

  if (mb < 1) {
    sizeInKBMB = "${kb.toStringAsFixed(2)} kb";
  } else {
    sizeInKBMB = "${mb.toStringAsFixed(2)} mb";
  }

  return sizeInKBMB;
}

// Get time difference between two time as per unit
String timeDiffAsPerUnit(String time1, String time2, int unit) {
  var getTime1 = DateTime.fromMillisecondsSinceEpoch(int.parse(time1));
  var getTime2 = DateTime.fromMillisecondsSinceEpoch(int.parse(time2));
  var diffHr = getTime1.difference(getTime2).inHours;
  var diffMin = getTime1.difference(getTime2).inMinutes;
  var diffSec = getTime1.difference(getTime2).inSeconds;
  // print("akash diffTime $diff");
  var finalHr = diffHr.toString().replaceAll("-", "");
  var finalMin = diffMin.toString().replaceAll("-", "");
  var finalSec = diffSec.toString().replaceAll("-", "");

  // return "$finalHr Hr : $finalMin Min : $finalSec Sec";

  if (unit == TimeUnitEnum.hour.index) {
    return finalHr;
  } else if (unit == TimeUnitEnum.minute.index) {
    return finalMin;
  } else if (unit == TimeUnitEnum.second.index) {
    return finalSec;
  } else {
    return finalMin;
  }
}

// logout from the app
logoutFromTheApp() async {
  var preferences = MySharedPref();
  await preferences.clearData(SharePreData.keySignupModel);
  await preferences.clearData(SharePreData.keyToken);
  Get.offAll(const LoginScreenView());
}

// Get time difference between two time as per unit
int calculateTimeDifferenceBetweenAsPerUnit(
    DateTime startDate, DateTime endDate, int unit) {
  if (unit == TimeUnitEnum.day.index) {
    return startDate.difference(endDate).inDays.abs();
  } else if (unit == TimeUnitEnum.hour.index) {
    return startDate.difference(endDate).inHours.abs();
  } else if (unit == TimeUnitEnum.minute.index) {
    return startDate.difference(endDate).inMinutes.abs();
  } else if (unit == TimeUnitEnum.second.index) {
    // print('in seconds ' + startDate.difference(endDate).inSeconds.abs().toString());
    return startDate.difference(endDate).inSeconds.abs();
  } else {
    return startDate.difference(endDate).inMinutes.abs();
  }
}

String getCurrentScreenName(BuildContext context) {
  final currentRoute = ModalRoute.of(context)?.settings;
  final screenName = currentRoute?.name;
  return screenName ?? '';
}

launchWhatsappChat(String mobileNumber, BuildContext context) async {
  var whatsapp = mobileNumber;
  var whatsappAndroid = Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
  if (await canLaunchUrl(whatsappAndroid)) {
    await launchUrl(whatsappAndroid);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("WhatsApp is not installed on the device"),
      ),
    );
  }
}

void showSuccessSnackBar(String message,
    {Color? color, int? secondsToDisplay}) {
  if (!Get.isOverlaysOpen) {
    GetSnackBar(
      backgroundColor: color ?? Colors.green,
      duration: Duration(seconds: secondsToDisplay ?? 2),
      isDismissible: false,
      snackPosition: SnackPosition.TOP,
      borderRadius: 10.r,
      margin: EdgeInsets.symmetric(horizontal: 15.mw, vertical: 15.mh),
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(message),
    ).show();
  }
}

double responsiveFontSize(BuildContext context, double base) {
  const baseWidth = 380.0; // iPhone 14 reference width
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  // Scale factor relative to base width
  double scale = screenWidth / baseWidth;

  // Put safe limits so text is not too big or too small
  if (scale > 1) scale = 1;
  if (scale < 0.8) scale = 0.8;

  final result = base * scale;

  // printData("responsiveFontSize",
  //     "width=$screenWidth, height=$screenHeight scale=$scale, result=$result");

  return result;
}

double responsiveFontSizeForWebPage(BuildContext context, double base) {
  const percent = 1.0; // reference factor
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Scale factor relative to reference width
  double scale = (screenWidth * percent) / 1570;

  printData("scaaaalllu", scale.toString());

  double ratio = screenWidth / screenHeight;

  if (ratio >= 2.17) {
    scale = 0.8; // very wide screens
  } else if (screenWidth >= 1400) {
    scale = 1; // big desktops
  } else if (scale > 1) {
    scale = 1; // don't exceed base
  } else if (scale < 0.8 && scale > 0.7) {
    scale = 0.77;
  } else if (scale < 0.7) {
    scale = 0.75;
  } else {
    scale = 0.6;
  }

  final result = base * scale;

  // Debug logs (optional)
  // debugPrint("responsiveFontSizeForWebPage => width=$screenWidth, "
  //     "height=$screenHeight, scale=$scale, result=$result");

  return result;
}

double responsiveFontSizeForWebPageContent(BuildContext context, double base) {
  const percent = 1.0; // reference factor
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Scale factor relative to reference width
  double scale = (screenWidth * percent) / 1570;

  printData("scaaaalllu", scale.toString());

  double ratio = screenWidth / screenHeight;

  if (ratio >= 2.17) {
    scale = 0.8; // very wide screens
  } else if (screenWidth >= 1400) {
    scale = 1; // big desktops
  } else if (scale > 1) {
    scale = 1; // don't exceed base
  } else if (scale < 0.8 && scale >= 0.75) {
    scale = 0.77;
  } else if (scale < 0.75) {
    scale = 0.75;
  } else {
    scale = 0.6;
  }

  final result = base * scale;

  // Debug logs (optional)
  // debugPrint("responsiveFontSizeForWebPage => width=$screenWidth, "
  //     "height=$screenHeight, scale=$scale, result=$result");

  return result;
}

double responsiveSpaceForWebPage(BuildContext context, double base) {
  const percent = 1.0; // reference factor
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Scale factor relative to reference width
  double scale = (screenWidth * percent) / 1920;

  final result = base * scale;

  // Debug logs (optional)
  // debugPrint("responsiveFontSizeForWebPage => width=$screenWidth, "
  //     "height=$screenHeight, scale=$scale, result=$result");

  return result;
}

extension AdaptiveNum on num {
  double get mw => kIsWeb ? toDouble() : w;
  double get mh => kIsWeb ? toDouble() : h;
  double get msp => kIsWeb ? toDouble() : sp;
}
