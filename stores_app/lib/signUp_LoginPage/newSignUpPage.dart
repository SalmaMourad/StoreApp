// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stores_app/constansts%20and%20fields/constants.dart';
import 'package:stores_app/constansts%20and%20fields/feild.dart';
import 'package:stores_app/DataBaseHelper/oldDataBaseHelper.dart';
import 'package:stores_app/signUp_LoginPage/LoginPage.dart';

class SignUpPagee extends StatefulWidget {
  const SignUpPagee({Key? key}) : super(key: key);

  static String id = "SignUpPage";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPagee> {
  // late Position _currentPosition;
  final formKey = GlobalKey<FormState>(); //key for form
  final DatabaseHelper dbHelper =
      DatabaseHelper(); // Initialize the database helper

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // bool validateEmail(String email) {
  //   // Regular expression for the email pattern
  //   final RegExp emailRegex =
  //       RegExp(r"^[a-zA-Z0-9_.+-]+@stud\.fci-cu\.edu\.eg$");

  //   // Check if the email matches the pattern
  //   return emailRegex.hasMatch(email);
  // }
  bool validateEmail(String email) {
    // Regular expression for the email pattern
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");

    // Check if the email matches the pattern
    return emailRegex.hasMatch(email);
  }

  Future<void> storeUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kprimaryColourWhite,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            const SizedBox(height: 23),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'sign up',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9A4253),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Feild(
              text: 'Name',
              icon: const Icon(Icons.person_2_outlined),
              controller: nameController,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
              },
            ),
            const SizedBox(height: 15),
            Feild(
              text: 'Email',
              icon: const Icon(Icons.email_outlined),
              controller: emailController,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (value != null) {
                  if (!validateEmail(value)) {
                    return "Please correct email format";
                  }
                }
              },
            ),
            const SizedBox(height: 15),
            Feild(
              text: 'Password',
              icon: const Icon(Icons.lock_outline),
              controller: passwordController,
              obscureText: true,
              isPassword:
                  true, // Set isPassword to true to indicate it's a password field
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else {
                  if (value.length < 8) {
                    return 'Your password must be eight characters or more';
                  }
                }
              },
            ),
            const SizedBox(height: 15),
            Feild(
              text: 'Confirm Password',
              icon: const Icon(Icons.password_outlined),
              isPassword: true,
              obscureText: true,
              controller: confirmPasswordController,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter same password again';
                } else {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                }
              },
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        // Validating passwords match
                        if (passwordController.text ==
                            confirmPasswordController.text) {
                          // Check if the email already exists
                          Map<String, dynamic>? existingUser = await dbHelper
                              .getUserByEmail(emailController.text);
                          if (existingUser != null) {
                            // Email already exists, show error message
                            showSnackBar(context, 'Email already exists');
                            return; // Stop sign-up process
                          }

                          // Insert user data into database
                          int userId = await dbHelper.insertUser({
                            'name': nameController.text,
                            'email': emailController.text,
                            // 'studentId': studentIdController.text,
                            'password': passwordController.text,
                            // 'gender': genderController.text,
                            // 'level': levelController.text,
                          });

                          // Store user ID in local storage
                          await storeUserId(userId);

                          // Registration successful
                          showSnackBar(context, 'Signup success');

                          // Navigate to login page
                          Navigator.pushNamed(context, LoginPage.id);
                        } else {
                          showSnackBar(context, 'Passwords do not match');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(320, 48),
                      backgroundColor: kprimaryColourPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                    child: const Text('Sign Up',style: TextStyle(color: Colors.white)),
                  );
                }),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LoginPage.id);
                  },
                  child: const Text("Sign In"),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
