import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rajan_engineers/Screens/Authentication/model/login_response.dart';

import '../model/attendance_details_response.dart';
import '../model/attendance_list_response.dart';
import '../model/employee_list_response.dart';

class EmployeeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Employee> employeeList = <Employee>[].obs;
  RxList<Employee> filteredList = <Employee>[].obs;
  Rx<AttendanceData> selectedAttendanceData = AttendanceData().obs;
  DateTime? attendanceDate;
  Rx<TextEditingController> masterSignInController =
      TextEditingController().obs;
  Rx<TextEditingController> masterSignOutController =
      TextEditingController().obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<AttendanceBatch> attendanceList = <AttendanceBatch>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> callEmployeeListAPI(BuildContext context) async {
    isLoading.value = true;

    print("token: ${await getToken()}");

    var headers = {'Authorization': "Bearer ${await getToken()}"};
    var request = http.Request(
      'GET',
      Uri.parse('https://rjn.bnrpl.com/api/admin/employees'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    isLoading.value = false;

    if (response.statusCode == 200) {
      // READ STREAM ONLY ONCE
      String responseBody = await response.stream.bytesToString();
      print("API Response => $responseBody");

      Map<String, dynamic> jsonMap = json.decode(responseBody);

      EmployeeListResponse employeeListResponse = EmployeeListResponse.fromJson(
        jsonMap,
      );

      if (employeeListResponse.status ?? false) {
        employeeList.value = employeeListResponse.data?.employees ?? [];
        filteredList.value = employeeList;
      } else {
        Get.snackbar("Error", employeeListResponse.message ?? "");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  callAttendanceListAPI(BuildContext context) async {
    isLoading.value = true;

    var headers = {'Authorization': "Bearer ${await getToken()}"};

    var request = http.Request(
      'GET',
      Uri.parse('https://rjn.bnrpl.com/api/admin/attendances'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    isLoading.value = false;

    if (response.statusCode == 200) {
      // Read stream ONCE
      String responseBody = await response.stream.bytesToString();
      print("Attendance List Response => $responseBody");

      Map<String, dynamic> userModel = json.decode(responseBody);

      AttendanceListResponse attendanceListResponse =
          AttendanceListResponse.fromJson(userModel);

      attendanceList.value =
          attendanceListResponse.data?.attendanceBatches ?? [];
    } else {
      print(response.reasonPhrase);
    }
  }

  callAttendanceDetailsAPI(
    BuildContext context,
    String attendanceId,
    bool isFromEditPage,
  ) async {
    isLoading.value = true;

    var headers = {'Authorization': "Bearer ${await getToken()}"};

    var request = http.Request(
      'GET',
      Uri.parse('https://rjn.bnrpl.com/api/admin/attendances/$attendanceId'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    isLoading.value = false;

    if (response.statusCode == 200) {
      // Read stream ONE time only
      String responseBody = await response.stream.bytesToString();
      print("Attendance Details Response => $responseBody");

      Map<String, dynamic> userModel = json.decode(responseBody);

      AttendanceDetailsResponse attendanceDetailsResponse =
          AttendanceDetailsResponse.fromJson(userModel);

      selectedAttendanceData.value =
          attendanceDetailsResponse.data ?? AttendanceData();

      attendanceDate = selectedAttendanceData.value.attendanceDate;

      if (isFromEditPage) {
        for (
          int i = 0;
          i < (selectedAttendanceData.value.attendances ?? []).length;
          i++
        ) {
          for (int j = 0; j < employeeList.length; j++) {
            if (selectedAttendanceData.value.attendances?[i].employeeId ==
                employeeList[j].id) {
              employeeList[j].signInController.text =
                  selectedAttendanceData.value.attendances?[i].signIn ?? "";
              employeeList[j].signOutController.text =
                  selectedAttendanceData.value.attendances?[i].signOut ?? "";
              employeeList[j].remarksController.text =
                  selectedAttendanceData.value.attendances?[i].remarks ?? "";

              if ((selectedAttendanceData.value.attendances?[i].signIn ?? "")
                  .isNotEmpty) {
                employeeList[j].isChecked = true;
              }
            }
          }
        }
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  callAddAttendanceAPI(
    BuildContext context,
    List<int> selectedIds,
    Map<String, String> signInMap,
    Map<String, String> signOutMap,
    Map<String, String> remarksMap,
    String date,
  ) async {
    isLoading.value = true;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${await getToken()}",
    };
    var request = http.Request(
      'POST',
      Uri.parse('https://rjn.bnrpl.com/api/admin/attendances'),
    );
    request.body = json.encode({
      "attendance_date": date,
      "employee_id": selectedIds, // <-- ARRAY
      "sign_in": signInMap, // <-- OBJECT
      "sign_out": signOutMap, // <-- OBJECT
      "remarks": remarksMap, // <-- OBJECT
    });
    request.headers.addAll(headers);

    print("bodyy " + request.body.toString());

    http.StreamedResponse response = await request.send();
    isLoading.value = false;
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("callAddAttendanceAPI Response => $responseBody");

      Map<String, dynamic> userModel = json.decode(responseBody);

      AttendanceListResponse attendanceListResponse =
          AttendanceListResponse.fromJson(userModel);

      if (attendanceListResponse.status ?? false) {
        Get.snackbar("Success", attendanceListResponse.message ?? "");
        Navigator.pop(context);
      } else {
        Get.snackbar("Error", attendanceListResponse.message ?? "");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  callUpdateAttendanceAPI(
    BuildContext context,
    List<int> selectedIds,
    Map<String, String> signInMap,
    Map<String, String> signOutMap,
    Map<String, String> remarksMap,
    String date,
    String id,
  ) async {
    isLoading.value = true;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer ${await getToken()}",
    };
    var request = http.Request(
      'POST',
      Uri.parse('https://rjn.bnrpl.com/api/admin/attendances/update/$id'),
    );
    request.body = json.encode({
      "attendance_date": date,
      "employee_id": selectedIds, // <-- ARRAY
      "sign_in": signInMap, // <-- OBJECT
      "sign_out": signOutMap, // <-- OBJECT
      "remarks": remarksMap, // <-- OBJECT
    });
    request.headers.addAll(headers);

    print("bodyy " + request.body.toString());

    http.StreamedResponse response = await request.send();
    isLoading.value = false;
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("callAddAttendanceAPI Response => $responseBody");

      Map<String, dynamic> userModel = json.decode(responseBody);

      AttendanceListResponse attendanceListResponse =
          AttendanceListResponse.fromJson(userModel);

      if (attendanceListResponse.status ?? false) {
        Get.snackbar("Success", attendanceListResponse.message ?? "");
        Navigator.pop(context);
      } else {
        Get.snackbar("Error", attendanceListResponse.message ?? "");
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";
  }

  DateTime convertDateTime(String date) {
    DateFormat inputFormat = DateFormat("dd-MM-yyyy");

    DateTime dt = inputFormat.parse(date);
    return dt;
  }
}
