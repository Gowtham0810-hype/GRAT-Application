// ignore_for_file: prefer_const_constructors

import 'package:dental_new/components/buttonsign.dart';
import 'package:dental_new/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
   final VoidCallback onTapLogin;
  const Signuppage({super.key, required this.onTapLogin});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final usernamectrl = TextEditingController();

  final passwordctrl = TextEditingController();

  final confirmpassctrl = TextEditingController();
  
  @override
  void dispose() {
    usernamectrl.dispose();
    passwordctrl.dispose();
    confirmpassctrl.dispose();
    super.dispose();
  }

  // A single function to show various alert dialogs (re-included for completeness)
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

  void signupuser() async {
    // Show loading indicator dialog
    showDialog(
      context: context,
      barrierDismissible: false, // User must wait for process to finish
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 5, 89, 157),
          ),
        );
      },
    );

    try {
      if (passwordctrl.text == confirmpassctrl.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernamectrl.text,
          password: passwordctrl.text,
        );
        // If user creation is successful, pop the loading indicator
        Navigator.pop(context);

        // Optionally, navigate to the next screen or show a success message
        // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));

      } else {
        // Passwords do not match
        Navigator.pop(context); // Pop the loading indicator FIRST
        showErrorDialog(context, "Password Mismatch",
            "Passwords provided in both fields should match.");
      }
    } on FirebaseAuthException catch (e) {
      // Pop the loading indicator FIRST on any Firebase error
      Navigator.pop(context);

      // Provide more specific error messages based on Firebase error codes
      if (e.code == 'weak-password') {
        showErrorDialog(context, "Weak Password", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog(context, "Email Already In Use", "An account already exists for that email.");
      } else if (e.code == 'invalid-email') {
        showErrorDialog(context, "Invalid Email", "The email address is not valid.");
      } else {
        // Fallback for other unexpected Firebase errors
        showErrorDialog(context, "Signup Error", e.message ?? "An unknown error occurred during signup.");
      }
    } catch (e) {
      // Catch any other unexpected errors (e.g., network issues)
      Navigator.pop(context); // Pop the loading indicator
      showErrorDialog(context, "An Unexpected Error Occurred", e.toString());
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
                  height: 120,
                ),
                Image.asset(
                  'lib/images/dental_logo.png',
                  height: 120,
                ),
                SizedBox(
                  height: 20,
                ),
          
                //line
          
                Text(
                  'Let\'s create an account for you',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
          
                //username password
                Textfieldcustom(
                    controller: usernamectrl,
                    hinttext: 'Email',
                    obscuretext: false),
                SizedBox(
                  height: 15,
                ),
                Textfieldcustom(
                    controller: passwordctrl,
                    hinttext: 'Password',
                    obscuretext: true),
                SizedBox(
                  height: 15,
                ),
                Textfieldcustom(
                    controller: confirmpassctrl,
                    hinttext: 'Confirm Password',
                    obscuretext: true),
          
                //sign in
          
                Buttonsign(
                  onTap: signupuser,
                  signtext: "Sign Up",
                ),
                SizedBox(
                  height: 20,
                ),
          
                /// for sign up page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTapLogin,
                      child: Text(
                        'Just Sign In',
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
