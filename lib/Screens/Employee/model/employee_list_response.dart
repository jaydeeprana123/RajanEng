// To parse this JSON data, do
//
//     final employeeListResponse = employeeListResponseFromJson(jsonString);

import 'dart:convert';

EmployeeListResponse employeeListResponseFromJson(String str) =>
    EmployeeListResponse.fromJson(json.decode(str));

String employeeListResponseToJson(EmployeeListResponse data) =>
    json.encode(data.toJson());

class EmployeeListResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  EmployeeListResponse({this.status, this.message, this.code, this.data});

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeListResponse(
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
  List<Employee>? employees;

  Data({this.employees});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    employees: json["employees"] == null
        ? []
        : List<Employee>.from(
            json["employees"]!.map((x) => Employee.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "employees": employees == null
        ? []
        : List<dynamic>.from(employees!.map((x) => x.toJson())),
  };
}

class Employee {
  int? id;
  String? employeeCode;
  String? name;
  dynamic email;
  String? mobile;
  String? uanNumber;
  String? panNumber;
  String? position;
  String? address;
  String? accountNumber;
  String? bankName;
  String? ifscCode;
  String? accountHolderName;
  DateTime? joiningDate;
  String? photo;
  String? aadharCard;
  String? shiftStartTime;
  String? shiftEndTime;
  String? letterText;
  int? dailyWages;
  String? hraPercent;
  String? travelAllowance;
  String? specialAllowance;
  String? pfPercent;
  String? profTax;
  String? employerPfPercent;
  String? employerEpfPercent;
  String? status;

  Employee({
    this.id,
    this.employeeCode,
    this.name,
    this.email,
    this.mobile,
    this.uanNumber,
    this.panNumber,
    this.position,
    this.address,
    this.accountNumber,
    this.bankName,
    this.ifscCode,
    this.accountHolderName,
    this.joiningDate,
    this.photo,
    this.aadharCard,
    this.shiftStartTime,
    this.shiftEndTime,
    this.letterText,
    this.dailyWages,
    this.hraPercent,
    this.travelAllowance,
    this.specialAllowance,
    this.pfPercent,
    this.profTax,
    this.employerPfPercent,
    this.employerEpfPercent,
    this.status,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    employeeCode: json["employee_code"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    uanNumber: json["uan_number"],
    panNumber: json["pan_number"],
    position: json["position"],
    address: json["address"],
    accountNumber: json["account_number"],
    bankName: json["bank_name"],
    ifscCode: json["ifsc_code"],
    accountHolderName: json["account_holder_name"],
    joiningDate: json["joining_date"] == null
        ? null
        : DateTime.parse(json["joining_date"]),
    photo: json["photo"],
    aadharCard: json["aadhar_card"],
    shiftStartTime: json["shift_start_time"],
    shiftEndTime: json["shift_end_time"],
    letterText: json["letter_text"],
    dailyWages: json["daily_wages"],
    hraPercent: json["hra_percent"],
    travelAllowance: json["travel_allowance"],
    specialAllowance: json["special_allowance"],
    pfPercent: json["pf_percent"],
    profTax: json["prof_tax"],
    employerPfPercent: json["employer_pf_percent"],
    employerEpfPercent: json["employer_epf_percent"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_code": employeeCode,
    "name": name,
    "email": email,
    "mobile": mobile,
    "uan_number": uanNumber,
    "pan_number": panNumber,
    "position": position,
    "address": address,
    "account_number": accountNumber,
    "bank_name": bankName,
    "ifsc_code": ifscCode,
    "account_holder_name": accountHolderName,
    "joining_date":
        "${joiningDate!.year.toString().padLeft(4, '0')}-${joiningDate!.month.toString().padLeft(2, '0')}-${joiningDate!.day.toString().padLeft(2, '0')}",
    "photo": photo,
    "aadhar_card": aadharCard,
    "shift_start_time": shiftStartTime,
    "shift_end_time": shiftEndTime,
    "letter_text": letterText,
    "daily_wages": dailyWages,
    "hra_percent": hraPercent,
    "travel_allowance": travelAllowance,
    "special_allowance": specialAllowance,
    "pf_percent": pfPercent,
    "prof_tax": profTax,
    "employer_pf_percent": employerPfPercent,
    "employer_epf_percent": employerEpfPercent,
    "status": status,
  };
}
