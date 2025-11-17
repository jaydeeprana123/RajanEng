import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/employee_controller.dart';

class AttendanceEntryPage extends StatefulWidget {
  @override
  _AttendanceEntryPageState createState() => _AttendanceEntryPageState();
}

class _AttendanceEntryPageState extends State<AttendanceEntryPage> {
  final EmployeeController controller = Get.put(EmployeeController());

  bool selectAll = false;

  TextEditingController masterSignIn = TextEditingController();
  TextEditingController masterSignOut = TextEditingController();

  DateTime? attendanceDate;

  Map<int, bool> selected = {};
  Map<int, TextEditingController> signInControllers = {};
  Map<int, TextEditingController> signOutControllers = {};
  Map<int, TextEditingController> remarksControllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    await controller.callEmployeeListAPI(context);
    setupControllers();
    setState(() {});
  }

  void setupControllers() {
    for (var emp in controller.employeeList) {
      int id = emp.id ?? 0;

      selected[id] = false;
      signInControllers[id] = TextEditingController();
      signOutControllers[id] = TextEditingController();
      remarksControllers[id] = TextEditingController();
    }
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
      initialDate: attendanceDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      setState(() {
        attendanceDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance Entry")),
      body: Obx(() {
        if (controller.employeeList.isEmpty) {
          return Center(child: Text("No Employees Found"));
        }

        return Column(
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
                  attendanceDate == null
                      ? "Select Date"
                      : "${attendanceDate!.day}-${attendanceDate!.month}-${attendanceDate!.year}",
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
                          int? id = emp.id;
                          if (id != null) {
                            selected[id] = selectAll;
                          }
                        });

                        // If selecting all, apply master times to all
                        if (selectAll) {
                          controller.employeeList.forEach((emp) {
                            int? id = emp.id;

                            if (id != null &&
                                signInControllers[id] != null &&
                                masterSignIn.text.isNotEmpty) {
                              signInControllers[id]!.text = masterSignIn.text;
                            }

                            if (id != null &&
                                signOutControllers[id] != null &&
                                masterSignOut.text.isNotEmpty) {
                              signOutControllers[id]!.text = masterSignOut.text;
                            }
                          });
                        }
                      });
                    },
                  ),

                  // MASTER SIGN IN
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await pickTimeForController(masterSignIn);

                        // Apply to all SELECTED employees only
                        setState(() {
                          controller.employeeList.forEach((emp) {
                            int? id = emp.id;
                            if (id != null &&
                                selected[id] == true &&
                                signInControllers[id] != null) {
                              signInControllers[id]!.text = masterSignIn.text;
                            }
                          });
                        });
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: masterSignIn,
                          decoration: InputDecoration(
                            labelText: "Master Sign In",
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
                        await pickTimeForController(masterSignOut);

                        // Apply to all SELECTED employees only
                        setState(() {
                          controller.employeeList.forEach((emp) {
                            int? id = emp.id;
                            if (id != null &&
                                selected[id] == true &&
                                signOutControllers[id] != null) {
                              signOutControllers[id]!.text = masterSignOut.text;
                            }
                          });
                        });
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: masterSignOut,
                          decoration: InputDecoration(
                            labelText: "Master Sign Out",
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
                                value: selected[id] ?? false,
                                onChanged: (v) {
                                  setState(() {
                                    selected[id] = v ?? false;

                                    // Update selectAll checkbox state
                                    selectAll = selected.values.every(
                                      (val) => val == true,
                                    );
                                  });
                                },
                              ),

                              Expanded(flex: 2, child: Text(emp.name ?? "")),

                              SizedBox(width: 10),

                              // INDIVIDUAL SIGN IN
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: signInControllers[id] != null
                                      ? () async {
                                          await pickTimeForController(
                                            signInControllers[id]!,
                                          );
                                        }
                                      : null,
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: signInControllers[id],
                                      decoration: InputDecoration(
                                        labelText: "Sign In",
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
                                  onTap: signOutControllers[id] != null
                                      ? () async {
                                          await pickTimeForController(
                                            signOutControllers[id]!,
                                          );
                                        }
                                      : null,
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: signOutControllers[id],
                                      decoration: InputDecoration(
                                        labelText: "Sign Out",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          TextField(
                            controller: remarksControllers[id],
                            decoration: InputDecoration(labelText: "Remarks"),
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
        );
      }),
    );
  }

  // ---------------- SUBMIT ----------------
  void submitAttendance() {
    if (attendanceDate == null) {
      Get.snackbar("Error", "Please select attendance date");
      return;
    }

    List<int> selectedIds = [];
    Map<String, String> signInMap = {};
    Map<String, String> signOutMap = {};
    Map<String, String> remarksMap = {};

    selected.forEach((id, isChecked) {
      if (isChecked) {
        selectedIds.add(id);
        signInMap[id.toString()] = signInControllers[id]!.text;
        signOutMap[id.toString()] = signOutControllers[id]!.text;
        remarksMap[id.toString()] = remarksControllers[id]!.text;
      }
    });

    print("SELECTED IDs → $selectedIds");
    print("SIGN IN MAP → $signInMap");
    print("SIGN OUT MAP → $signOutMap");
    print("REMARKS MAP → $remarksMap");

    Get.snackbar("Success", "Attendance Submitted");
  }
}
