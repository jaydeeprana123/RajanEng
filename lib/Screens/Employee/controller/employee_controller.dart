import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';

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
  Rx<AttendanceData> attendanceData = AttendanceData().obs;
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

  callAttendanceDetailsAPI(BuildContext context, String attendanceId) async {
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

      attendanceData.value = attendanceDetailsResponse.data ?? AttendanceData();
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";
  }
}
