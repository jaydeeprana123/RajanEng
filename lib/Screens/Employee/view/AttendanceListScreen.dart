import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:rajan_engineers/Screens/Employee/view/AttendanceEntryPage.dart';

import '../../../Styles/my_colors.dart';
import '../../../Styles/my_font.dart';
import '../../../Styles/my_icons.dart';
import '../controller/employee_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AttendanceDetailsScreen.dart';
import 'EmployeeDetailPage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  final EmployeeController controller = Get.put(EmployeeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.callAttendanceListAPI(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance Batches",
          style: TextStyle(fontFamily: fontMulishSemiBold, fontSize: 18),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Get.to(AttendanceEntryPage());
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.attendanceList.isEmpty) {
          return Center(
            child: Text(
              "No attendance records found",
              style: TextStyle(fontFamily: fontMulishRegular, fontSize: 14),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.attendanceList.length,
          itemBuilder: (context, index) {
            final att = controller.attendanceList[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {
                  Get.to(
                    AttendanceDetailPage(
                      attendanceId: (controller.attendanceList[index].id ?? 0)
                          .toString(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Row(
                        children: [
                          Text(
                            "Date: ",
                            style: TextStyle(
                              fontFamily: fontMulishSemiBold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            att.attendanceDate != null
                                ? "${att.attendanceDate!.day}-${att.attendanceDate!.month}-${att.attendanceDate!.year}"
                                : "N/A",
                            style: TextStyle(
                              fontFamily: fontMulishRegular,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Total Employees
                      Row(
                        children: [
                          Text(
                            "Total Employees: ",
                            style: TextStyle(
                              fontFamily: fontMulishSemiBold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${att.totalEmployees ?? 0}",
                            style: TextStyle(
                              fontFamily: fontMulishRegular,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
