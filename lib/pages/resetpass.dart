// ignore_for_file: prefer_const_constructors

import 'package:dental_new/components/buttonsign.dart';
import 'package:dental_new/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Resetpasspage extends StatefulWidget {
     final VoidCallback onTapBackToLogin;
  const Resetpasspage({super.key, required this.onTapBackToLogin});

  @override
  State<Resetpasspage> createState() => _ResetpasspageState();
}

class _ResetpasspageState extends State<Resetpasspage> {
  final forgotPasswordEmailCtrl = TextEditingController();

  void showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the alert dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void resetPassword() async {
    // Validate email input before proceeding
    if (forgotPasswordEmailCtrl.text.isEmpty) {
      showErrorDialog(context, "Missing Email", "Please enter your email to reset the password.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 5, 89, 157),
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: forgotPasswordEmailCtrl.text.trim(), // Use trim() to remove leading/trailing spaces
      );
      Navigator.pop(context); // Pop the loading indicator

      // Show success message to the user
      showErrorDialog(
        context,
        "Password Reset Email Sent",
        "A password reset link has been sent to ${forgotPasswordEmailCtrl.text}.\nPlease check your email (and spam folder).",
      );

      // Optionally clear the email field after sending
      forgotPasswordEmailCtrl.clear();

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Pop the loading indicator FIRST

      // Firebase often doesn't give specific errors for security reasons
      // to avoid revealing if an email exists or not.
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        // For password reset, it's generally best not to confirm if an email exists
        // so we can give a generic "If an account exists..." message.
        showErrorDialog(
          context,
          "Password Reset Info",
          "If an account with that email exists, a password reset link has been sent.",
        );
      } else {
        // Handle other potential errors like network issues
        showErrorDialog(
          context,
          "Error Sending Reset Email",
          e.message ?? "An unknown error occurred.",
        );
      }
    } catch (e) {
      Navigator.pop(context); // Pop the loading indicator
      showErrorDialog(
        context,
        "An Unexpected Error Occurred",
        "Failed to send password reset email: ${e.toString()}",
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //logo
          
                SizedBox(
                  height: 220,
                ),
                Icon(
                  Icons.lock,
                  size: 80,
                ),
                SizedBox(
                  height: 20,
                ),
          
                //line
          
                Text(
                  'Please enter your mail. password reset link will be sent.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
          
                //username password
                Textfieldcustom(
                    controller: forgotPasswordEmailCtrl,
                    hinttext: 'Username',
                    obscuretext: false),
                SizedBox(
                  height: 15,
                ),
          
                //sign in
          
                Buttonsign(
                  onTap: resetPassword,
                  signtext: "Reset Password Link",
                ),
                SizedBox(
                  height: 20,
                ),
          
                /// for sign up page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password?',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTapBackToLogin,
                      child: Text(
                        'Go Sign In',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
