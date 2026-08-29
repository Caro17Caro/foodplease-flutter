import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_page.dart';
import '../screens/auth/google_login_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/auth/verify_email_page.dart';
import '../screens/home/home_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';

  static const String forgotPassword = '/forgot-password';
  static const String googleLogin = '/google-login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const HomePage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      googleLogin: (context) => const GoogleLoginPage(),
      register: (context) => const RegisterPage(),
      verifyEmail: (context) => const VerifyEmailPage(),
    };
  }
}