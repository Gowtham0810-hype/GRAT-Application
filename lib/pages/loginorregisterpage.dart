import 'package:dental_new/pages/loginpage.dart';
import 'package:dental_new/pages/resetpass.dart';

import 'package:dental_new/pages/signuppage.dart';
import 'package:flutter/material.dart';

enum AuthPage {
  login,
  signup,
  forgotPassword,
}

class Loginorregisterpage extends StatefulWidget {
  const Loginorregisterpage({super.key});

  @override
  State<Loginorregisterpage> createState() => _LoginorregisterpageState();
}

class _LoginorregisterpageState extends State<Loginorregisterpage> {
  //for three page
  AuthPage _currentPage = AuthPage.login;

  // Function to navigate to a specific page
  void navigateToPage(AuthPage page) {
    setState(() {
      _currentPage = page;
    });
  }


  
  
  //for two page toggle between
  bool showloginpagevssignup = true;

  void togglepage() {
    setState(() {
      showloginpagevssignup = !showloginpagevssignup;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPage == AuthPage.login) {
      return Loginpage(
        // Pass callbacks to allow navigation to other pages
        onTapRegister: () => navigateToPage(AuthPage.signup),
        onTapForgotPassword: () => navigateToPage(AuthPage.forgotPassword),
      );
    } else if (_currentPage == AuthPage.signup) {
      return Signuppage(
        // Pass a callback to allow navigation back to the login page
        onTapLogin: () => navigateToPage(AuthPage.login),
      );
    } else {
      // This is the new ForgotPasswordPage
      return Resetpasspage(
        // Pass a callback to allow navigation back to the login page
        onTapBackToLogin: () => navigateToPage(AuthPage.login),
      );
    }
  }
}
