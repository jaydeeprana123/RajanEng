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

import 'EmployeeDetailPage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class AttendanceDetailPage extends StatefulWidget {
  final String attendanceId;

  const AttendanceDetailPage({Key? key, required this.attendanceId})
    : super(key: key);

  @override
  State<AttendanceDetailPage> createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  final EmployeeController controller = Get.find<EmployeeController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.callAttendanceDetailsAPI(context, widget.attendanceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance Details",
          style: TextStyle(fontFamily: "fontInterMedium"),
        ),
      ),

      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- TOP INFO ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Batch ID: ${controller.attendanceData.value.batchId ?? ''}",
                    style: TextStyle(
                      fontFamily: "fontInterMedium",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Date: ${controller.attendanceData.value.attendanceDate?.toString().substring(0, 10) ?? ''}",
                    style: TextStyle(
                      fontFamily: "fontInterRegular",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // -------- ATTENDANCE LIST ----------
            Expanded(
              child:
                  controller.attendanceData.value.attendances == null ||
                      controller.attendanceData.value.attendances!.isEmpty
                  ? Center(
                      child: Text(
                        "No Attendance Records",
                        style: TextStyle(fontFamily: "fontInterRegular"),
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          controller.attendanceData.value.attendances!.length,
                      itemBuilder: (context, index) {
                        final attend =
                            controller.attendanceData.value.attendances![index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attend.name ?? "",
                                  style: TextStyle(
                                    fontFamily: "fontInterMedium",
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 6),

                                _row("Mobile", attend.mobile),
                                _row("Sign In", attend.signIn),
                                _row("Sign Out", attend.signOut),
                                _row("Overtime", attend.overtimeHours),
                                _row("Remarks", attend.remarks),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------ ROW WIDGET --------------
  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: TextStyle(fontFamily: "fontInterMedium", fontSize: 14),
          ),
          Expanded(
            child: Text(
              value ?? "",
              style: TextStyle(fontFamily: "fontInterRegular", fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
