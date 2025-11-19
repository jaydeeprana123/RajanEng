import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:rajan_engineers/Screens/Authentication/view/LoginScreenView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Styles/my_colors.dart';
import '../../../Styles/my_font.dart';
import '../../../Styles/my_icons.dart';
import '../controller/employee_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'EmployeeDetailPage.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  EmployeeController employeeController = Get.put(EmployeeController());

  @override
  void initState() {
    super.initState();

    employeeController.callEmployeeListAPI(context);
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      employeeController.filteredList.value = employeeController.employeeList;
    } else {
      employeeController.filteredList.value = employeeController.employeeList
          .where((emp) {
            return (emp.name ?? "").toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                (emp.employeeCode ?? "").toLowerCase().contains(
                  query.toLowerCase(),
                );
          })
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Employees",
          style: TextStyle(fontFamily: fontMulishSemiBold, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              clearToken();

              Get.offAll(LoginPage());
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Obx(
        () => Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: employeeController.searchController.value,
                onChanged: filterSearch,
                decoration: InputDecoration(
                  hintText: "Search by name or code",
                  hintStyle: TextStyle(fontFamily: fontMulishRegular),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (employeeController.filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "No employees found",
                      style: TextStyle(
                        fontFamily: fontMulishRegular,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: employeeController.filteredList.length,
                  itemBuilder: (context, index) {
                    final emp = employeeController.filteredList[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),

                        title: Text(
                          emp.name ?? "No Name",
                          style: TextStyle(
                            fontFamily: fontMulishSemiBold,
                            fontSize: 16,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (emp.employeeCode != null)
                              infoRow("Code", emp.employeeCode),

                            if (emp.position != null)
                              infoRow("Position", emp.position),

                            if (emp.email != null)
                              infoRow("Email", emp.email?.toString()),

                            if (emp.mobile != null)
                              infoRow("Mobile", emp.mobile),
                          ],
                        ),

                        // 👉 Optional: Edit / Delete buttons
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Get.to(() => EmployeeDetailPage(employee: emp));
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: TextStyle(
                fontFamily: fontMulishSemiBold, // Title style
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: fontMulishRegular, // Value style
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }
}
