// To parse this JSON data, do
//
//     final attendanceRequestModel = attendanceRequestModelFromJson(jsonString);

import 'dart:convert';

AttendanceRequestModel attendanceRequestModelFromJson(String str) =>
    AttendanceRequestModel.fromJson(json.decode(str));

String attendanceRequestModelToJson(AttendanceRequestModel data) =>
    json.encode(data.toJson());

class AttendanceRequestModel {
  DateTime? attendanceDate;
  List<int>? employeeId;
  Map<String, String>? signIn;
  Map<String, String>? signOut;
  Map<String, String>? remarks;

  AttendanceRequestModel({
    this.attendanceDate,
    this.employeeId,
    this.signIn,
    this.signOut,
    this.remarks,
  });

  factory AttendanceRequestModel.fromJson(Map<String, dynamic> json) =>
      AttendanceRequestModel(
        attendanceDate: json["attendance_date"] == null
            ? null
            : DateTime.parse(json["attendance_date"]),
        employeeId: json["employee_id"] == null
            ? []
            : List<int>.from(json["employee_id"]!.map((x) => x)),
        signIn: Map.from(
          json["sign_in"]!,
        ).map((k, v) => MapEntry<String, String>(k, v)),
        signOut: Map.from(
          json["sign_out"]!,
        ).map((k, v) => MapEntry<String, String>(k, v)),
        remarks: Map.from(
          json["remarks"]!,
        ).map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
    "attendance_date":
        "${attendanceDate!.year.toString().padLeft(4, '0')}-${attendanceDate!.month.toString().padLeft(2, '0')}-${attendanceDate!.day.toString().padLeft(2, '0')}",
    "employee_id": employeeId == null
        ? []
        : List<dynamic>.from(employeeId!.map((x) => x)),
    "sign_in": Map.from(signIn!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "sign_out": Map.from(
      signOut!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "remarks": Map.from(
      remarks!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}
