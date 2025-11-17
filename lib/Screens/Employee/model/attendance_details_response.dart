// To parse this JSON data, do
//
//     final attendanceDetailsResponse = attendanceDetailsResponseFromJson(jsonString);

import 'dart:convert';

AttendanceDetailsResponse attendanceDetailsResponseFromJson(String str) =>
    AttendanceDetailsResponse.fromJson(json.decode(str));

String attendanceDetailsResponseToJson(AttendanceDetailsResponse data) =>
    json.encode(data.toJson());

class AttendanceDetailsResponse {
  bool? status;
  String? message;
  int? code;
  AttendanceData? data;

  AttendanceDetailsResponse({this.status, this.message, this.code, this.data});

  factory AttendanceDetailsResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceDetailsResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null
            ? null
            : AttendanceData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class AttendanceData {
  int? batchId;
  DateTime? attendanceDate;
  List<Attendance>? attendances;

  AttendanceData({this.batchId, this.attendanceDate, this.attendances});

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
    batchId: json["batch_id"],
    attendanceDate: json["attendance_date"] == null
        ? null
        : DateTime.parse(json["attendance_date"]),
    attendances: json["attendances"] == null
        ? []
        : List<Attendance>.from(
            json["attendances"]!.map((x) => Attendance.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "batch_id": batchId,
    "attendance_date":
        "${attendanceDate!.year.toString().padLeft(4, '0')}-${attendanceDate!.month.toString().padLeft(2, '0')}-${attendanceDate!.day.toString().padLeft(2, '0')}",
    "attendances": attendances == null
        ? []
        : List<dynamic>.from(attendances!.map((x) => x.toJson())),
  };
}

class Attendance {
  int? employeeId;
  String? name;
  String? mobile;
  String? signIn;
  String? signOut;
  String? overtimeHours;
  String? remarks;

  Attendance({
    this.employeeId,
    this.name,
    this.mobile,
    this.signIn,
    this.signOut,
    this.overtimeHours,
    this.remarks,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    employeeId: json["employee_id"],
    name: json["name"],
    mobile: json["mobile"],
    signIn: json["sign_in"],
    signOut: json["sign_out"],
    overtimeHours: json["overtime_hours"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "employee_id": employeeId,
    "name": name,
    "mobile": mobile,
    "sign_in": signIn,
    "sign_out": signOut,
    "overtime_hours": overtimeHours,
    "remarks": remarks,
  };
}
