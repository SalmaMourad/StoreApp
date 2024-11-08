import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stores_app/constansts%20and%20fields/constants.dart';
import 'package:stores_app/constansts%20and%20fields/feild.dart';
import 'package:stores_app/DataBaseHelper/oldDataBaseHelper.dart';
import 'package:stores_app/signUp_LoginPage/newSignUpPage.dart';
import 'package:stores_app/Stores/storesScreen.dart';


class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  static String id = "LoginPage";
  final GlobalKey<FormState> formKey = GlobalKey();
  final DatabaseHelper dbHelper =
      DatabaseHelper(); // Initialize database helper

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> storeUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kprimaryColourWhite,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            const SizedBox(height: 60),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'YSH Store',
                  style: TextStyle(
                    fontSize: 35,
                     fontWeight: FontWeight.bold,
                         fontStyle: FontStyle.italic, // Making the text italic

                    // fontStyle: ,
                    color: Color(0xFF9A4253),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/icons/logo3.jpg',
                      width: 150,
                      height: 150,
                    )
                  ],
                ),
             const   SizedBox(height: 15,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 25),
            Feild(
              text: 'Email',
              icon: const Icon(Icons.email_outlined),
              controller: emailController,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
              },
            ),
            const SizedBox(height: 15),
            Feild(
              text: 'Password',
              icon: const Icon(Icons.lock_outline),
              controller: passwordController,
              obscureText: true,
              isPassword: true,
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else {
                  if (value.length < 8) {
                    return 'Your password must be eight characters or more';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        // Validate credentials against database
                        final user = await dbHelper.getUserByEmailAndPassword(
                            emailController.text, passwordController.text);
                        if (user != null) {
                          // Login successful
                          showSnackBar(context, 'Login successful');
                          // Store user ID in local storage
                          await storeUserId(user['id']);
                          // Proceed to profile page
                          Navigator.pushNamed(context, StoresScreen.id);
                        } else {
                          // Invalid credentials
                          showSnackBar(context, 'Invalid email or password');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(320, 48),
                      backgroundColor: const Color(0xFF9A4253),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                    child: const Text('Sign In',style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SignUpPagee.id);
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
     ),
);
}
}