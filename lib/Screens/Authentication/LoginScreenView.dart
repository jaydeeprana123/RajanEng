import 'package:dotted_line/dotted_line.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../Styles/my_colors.dart';
import '../../Styles/my_font.dart';
import '../../Styles/my_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String selectedRole = 'Admin'; // default role
  final List<String> roles = ['Admin', 'Staff'];
  Future<void> login() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Navigate to MenuPage or Home

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigationView()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon_logo, width: 250, height: 220),

            SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            const SizedBox(height: 40),
            Visibility(
              visible: false,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: roles
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedRole = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Role",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // const SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: ElevatedButton(
                          onPressed: login,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: fontMulishSemiBold,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black54, // 🔹 Your custom color here
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
