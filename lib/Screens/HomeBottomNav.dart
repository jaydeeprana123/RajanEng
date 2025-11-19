import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:rajan_engineers/Screens/Employee/view/EmployeeListScreen.dart';

import '../../../Styles/my_colors.dart';
import '../../../Styles/my_font.dart';
import '../../../Styles/my_icons.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Employee/view/AttendanceListScreen.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    EmployeeListScreen(), // Employees screen
    // AttendanceListScreen(), // Salary screen (create placeholder)
    AttendanceListScreen(), // Attendance screen (create placeholder)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        selectedLabelStyle: TextStyle(
          fontFamily: fontMulishSemiBold,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: fontMulishRegular,
          fontSize: 12,
        ),

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Employees"),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.currency_rupee),
          //   label: "Salary",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Attendance",
          ),
        ],
      ),
    );
  }
}
