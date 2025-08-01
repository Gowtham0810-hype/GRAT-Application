// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:dental_new/components/buttonsign.dart';
import 'package:dental_new/components/square_tile.dart';
import 'package:dental_new/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginpage extends StatefulWidget {
  final VoidCallback onTapRegister;
  final VoidCallback onTapForgotPassword;

  Loginpage(
      {super.key,
      required this.onTapForgotPassword,
      required this.onTapRegister});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final usernamectrl = TextEditingController();

  final passwordctrl = TextEditingController();

// Function to handle user sign-in attempts
  void signUserIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernamectrl.text,
        password: passwordctrl.text,
      );
      // If sign-in is successful, pop the loading dialog
      Navigator.pop(context); // Pop the loading indicator

      // You might navigate to a new screen here, e.g.:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    } on FirebaseAuthException catch (e) {
      // First, pop the loading dialog even if there's an error
      Navigator.pop(context); // Pop the loading indicator
      print(e.code);
      if (e.code == 'invalid-email') {
        showErrorDialog(context, "User Not Found",
            "No user found for that email."); // Pass context to the helper function
      } else if (e.code == 'invalid-credential') {
        showErrorDialog(context, "Wrong Password",
            "Invalid password provided."); // Pass context to the helper function
      } else {
        // Handle other Firebase exceptions
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sign-in Error'),
              content: Text(e.message ?? 'An unknown error occurred.'),
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
    }
  }

  //google sign in
  gsignin() async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    //if user cancels in google sign in screen
    if (guser == null) {
      return;
    }

    final GoogleSignInAuthentication gauth = await guser.authentication;

    //create new credentials for the user in database

    final credential = GoogleAuthProvider.credential(
        accessToken: gauth.accessToken, idToken: gauth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title), // Use the passed title
          content: Text(content), // Use the passed content
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
                  'Gingivitis Risk Assessment Tool.',
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

                //forgot password

                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: widget.onTapForgotPassword,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),

                //sign in

                Buttonsign(
                  onTap: signUserIn,
                  signtext: "Sign In",
                ),
                SizedBox(
                  height: 30,
                ),

                //continue wih

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.grey.shade400,
                      )),
                      Text(
                        'Or continue with',
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.grey.shade400,
                      ))
                    ],
                  ),
                ),

                //google sign in
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                    onTap: gsignin,
                    child: SquareTile(imagepath: 'lib/images/g.png')),
                SizedBox(
                  height: 30,
                ),

                /// for sign up page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTapRegister,
                      child: Text(
                        'Register now',
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
