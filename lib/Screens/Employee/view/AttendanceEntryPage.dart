import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/employee_controller.dart';

class AttendanceEntryPage extends StatefulWidget {
  final bool isEdit;
  final String attendanceId;

  const AttendanceEntryPage({
    Key? key,
    required this.isEdit,
    required this.attendanceId,
  }) : super(key: key);

  @override
  _AttendanceEntryPageState createState() => _AttendanceEntryPageState();
}

class _AttendanceEntryPageState extends State<AttendanceEntryPage> {
  final EmployeeController controller = Get.put(EmployeeController());

  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    await controller.callEmployeeListAPI(context);
    if (widget.isEdit) {
      await controller.callAttendanceDetailsAPI(
        context,
        widget.attendanceId,
        true,
      );
    }
    setState(() {});
  }

  // ---------------- TIME PICKER (AUTO-FILL CURRENT TIME) ----------------
  Future<void> pickTimeForController(
    TextEditingController targetController,
  ) async {
    TimeOfDay now = TimeOfDay.now(); // auto-fill current time

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formatted =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

      targetController.text = formatted;
      setState(() {});
    }
  }

  // ---------------- DATE PICKER ----------------
  void pickDate() async {
    DateTime now = DateTime.now();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.attendanceDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      setState(() {
        controller.attendanceDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance Entry")),
      body: Obx(() {
        if (controller.employeeList.isEmpty && !controller.isLoading.value) {
          return Center(child: Text("No Employees Found"));
        }

        return Stack(
          children: [
            Column(
              children: [
                // -------------------- DATE --------------------
                InkWell(
                  onTap: pickDate,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.attendanceDate == null
                          ? "Select Date"
                          : "${controller.attendanceDate!.day}-${controller.attendanceDate!.month}-${controller.attendanceDate!.year}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // ---------------- MASTER SECTION ----------------
                Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Checkbox(
                        value: selectAll,
                        onChanged: (value) {
                          setState(() {
                            selectAll = value ?? false;

                            // Toggle all employees' selection
                            controller.employeeList.forEach((emp) {
                              emp.isChecked = selectAll;
                            });

                            // If selecting all, apply master times to all
                          });
                        },
                      ),

                      // MASTER SIGN IN
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await pickTimeForController(
                              controller.masterSignInController.value,
                            );

                            // Apply to all SELECTED employees only
                            setState(() {
                              controller.employeeList.forEach((emp) {
                                int? id = emp.id;
                                if (emp.isChecked) {
                                  emp.signInController.text = controller
                                      .masterSignInController
                                      .value
                                      .text;
                                }
                              });
                            });
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller:
                                  controller.masterSignInController.value,
                              decoration: InputDecoration(
                                labelText: "Master Sign In",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 10),

                      // MASTER SIGN OUT
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await pickTimeForController(
                              controller.masterSignOutController.value,
                            );

                            // Apply to all SELECTED employees only
                            setState(() {
                              controller.employeeList.forEach((emp) {
                                int? id = emp.id;
                                if (emp.isChecked) {
                                  emp.signOutController.text = controller
                                      .masterSignOutController
                                      .value
                                      .text;
                                }
                              });
                            });
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller:
                                  controller.masterSignOutController.value,
                              decoration: InputDecoration(
                                labelText: "Master Sign Out",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- EMPLOYEE LIST ----------------
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.employeeList.length,
                    itemBuilder: (context, index) {
                      final emp = controller.employeeList[index];
                      final id = emp.id ?? 0;

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: emp.isChecked,
                                    onChanged: (v) {
                                      setState(() {
                                        emp.isChecked = v ?? false;
                                      });
                                    },
                                  ),

                                  Expanded(
                                    flex: 2,
                                    child: Text(emp.name ?? ""),
                                  ),

                                  SizedBox(width: 10),

                                  // INDIVIDUAL SIGN IN
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await pickTimeForController(
                                          controller
                                              .employeeList[index]
                                              .signInController,
                                        );
                                      },
                                      child: AbsorbPointer(
                                        child: TextField(
                                          controller: controller
                                              .employeeList[index]
                                              .signInController,
                                          decoration: InputDecoration(
                                            labelText: "Sign In",
                                            labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10),

                                  // INDIVIDUAL SIGN OUT
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await pickTimeForController(
                                          controller
                                              .employeeList[index]
                                              .signOutController,
                                        );
                                      },
                                      child: AbsorbPointer(
                                        child: TextField(
                                          controller: controller
                                              .employeeList[index]
                                              .signOutController,
                                          decoration: InputDecoration(
                                            labelText: "Sign Out",
                                            labelStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: controller
                                    .employeeList[index]
                                    .remarksController,
                                decoration: InputDecoration(
                                  labelText: "Remarks",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ---------------- SUBMIT BUTTON ----------------
                Padding(
                  padding: EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: submitAttendance,
                    child: Text("Submit Attendance"),
                  ),
                ),
              ],
            ),

            if (controller.isLoading.value)
              Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }

  // ---------------- SUBMIT ----------------
  void submitAttendance() {
    if (controller.attendanceDate == null) {
      Get.snackbar("Error", "Please select attendance date");
      return;
    }

    List<int> selectedIds = [];
    Map<String, String> signInMap = {};
    Map<String, String> signOutMap = {};
    Map<String, String> remarksMap = {};

    for (int i = 0; i < controller.employeeList.length; i++) {
      if (controller.employeeList[i].isChecked) {
        selectedIds.add(controller.employeeList[i].id ?? 0);
        signInMap[(controller.employeeList[i].id ?? 0).toString()] =
            controller.employeeList[i].signInController.text;
        signOutMap[(controller.employeeList[i].id ?? 0).toString()] =
            controller.employeeList[i].signOutController.text;
        remarksMap[(controller.employeeList[i].id ?? 0).toString()] =
            controller.employeeList[i].remarksController.text;
      }
    }

    print("SELECTED IDs → $selectedIds");
    print("SIGN IN MAP → $signInMap");
    print("SIGN OUT MAP → $signOutMap");
    print("REMARKS MAP → $remarksMap");

    if (widget.isEdit) {
      controller.callUpdateAttendanceAPI(
        context,
        selectedIds,
        signInMap,
        signOutMap,
        remarksMap,
        convertIntoYYYYMMDD(controller.attendanceDate ?? DateTime(2025)),
        widget.attendanceId,
      );
    } else {
      controller.callAddAttendanceAPI(
        context,
        selectedIds,
        signInMap,
        signOutMap,
        remarksMap,
        convertIntoYYYYMMDD(controller.attendanceDate ?? DateTime(2025)),
      );
    }
  }

  String convertIntoYYYYMMDD(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate; // Output: 13-11-2025
  }
}
