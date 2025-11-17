import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../../Styles/my_colors.dart';
import '../../../Styles/my_font.dart';
import '../../../Styles/my_icons.dart';
import '../controller/employee_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/employee_list_response.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Employee Details",
          style: TextStyle(fontFamily: fontMulishSemiBold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailItem("Employee Code", employee.employeeCode),
            detailItem("Name", employee.name),
            detailItem("Email", employee.email?.toString()),
            detailItem("Mobile", employee.mobile),
            detailItem("Position", employee.position),
            detailItem("Address", employee.address),
            detailItem("UAN Number", employee.uanNumber),
            detailItem("PAN Number", employee.panNumber),
            detailItem("Account No", employee.accountNumber),
            detailItem("Bank Name", employee.bankName),
            detailItem("IFSC Code", employee.ifscCode),
            detailItem("Account Holder", employee.accountHolderName),
            detailItem(
              "Joining Date",
              employee.joiningDate?.toString().split(" ").first,
            ),
            detailItem("Shift Start", employee.shiftStartTime),
            detailItem("Shift End", employee.shiftEndTime),
            detailItem("Daily Wages", employee.dailyWages?.toString()),
            detailItem("HRA %", employee.hraPercent),
            detailItem("Travel Allowance", employee.travelAllowance),
            detailItem("Special Allowance", employee.specialAllowance),
            detailItem("PF %", employee.pfPercent),
            detailItem("Professional Tax", employee.profTax),
            detailItem("Employer PF %", employee.employerPfPercent),
            detailItem("Employer EPF %", employee.employerEpfPercent),
            detailItem("Status", employee.status),
          ],
        ),
      ),
    );
  }

  Widget detailItem(String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: TextStyle(
                fontFamily: fontMulishSemiBold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: fontMulishRegular,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
