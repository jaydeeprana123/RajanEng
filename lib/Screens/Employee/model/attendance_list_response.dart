// To parse this JSON data, do
//
//     final attendanceListResponse = attendanceListResponseFromJson(jsonString);

import 'dart:convert';

AttendanceListResponse attendanceListResponseFromJson(String str) =>
    AttendanceListResponse.fromJson(json.decode(str));

String attendanceListResponseToJson(AttendanceListResponse data) =>
    json.encode(data.toJson());

class AttendanceListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  AttendanceListResponse({this.status, this.message, this.code, this.data});

  factory AttendanceListResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceListResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  List<AttendanceBatch>? attendanceBatches;

  Data({this.attendanceBatches});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    attendanceBatches: json["attendance_batches"] == null
        ? []
        : List<AttendanceBatch>.from(
            json["attendance_batches"]!.map((x) => AttendanceBatch.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "attendance_batches": attendanceBatches == null
        ? []
        : List<dynamic>.from(attendanceBatches!.map((x) => x.toJson())),
  };
}

class AttendanceBatch {
  int? id;
  DateTime? attendanceDate;
  int? totalEmployees;
  dynamic createdBy;

  AttendanceBatch({
    this.id,
    this.attendanceDate,
    this.totalEmployees,
    this.createdBy,
  });

  factory AttendanceBatch.fromJson(Map<String, dynamic> json) =>
      AttendanceBatch(
        id: json["id"],
        attendanceDate: json["attendance_date"] == null
            ? null
            : DateTime.parse(json["attendance_date"]),
        totalEmployees: json["total_employees"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date":
        "${attendanceDate!.year.toString().padLeft(4, '0')}-${attendanceDate!.month.toString().padLeft(2, '0')}-${attendanceDate!.day.toString().padLeft(2, '0')}",
    "total_employees": totalEmployees,
    "created_by": createdBy,
  };
}
