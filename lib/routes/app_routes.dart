import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/home/home_page.dart';
import '../screens/home/location_page.dart';
import '../screens/home/location_denied_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
  static const String location = '/location';
  static const String locationDenied = '/location-denied';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const HomePage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      location: (context) => const LocationPage(),
      locationDenied: (context) => const LocationDeniedPage(),
    };
  }
}
