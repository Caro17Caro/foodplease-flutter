import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_page.dart';
import '../screens/auth/google_login_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/auth/verify_email_page.dart';

import '../screens/home/home_page.dart';

import '../screens/checkout/add_card_page.dart';
import '../screens/checkout/address_search_page.dart';
import '../screens/checkout/card_result_page.dart';
import '../screens/checkout/checkout_page.dart';
import '../screens/checkout/payment_method_page.dart';

import '../screens/checkout/order_summary_page.dart';

import '../screens/checkout/order_processing_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';

  static const String forgotPassword =
      '/forgot-password';

  static const String googleLogin =
      '/google-login';

  static const String register =
      '/register';

  static const String verifyEmail =
      '/verify-email';

  static const String checkout =
      '/checkout';

  static const String addressSearch =
      '/address-search';

  static const String paymentMethod =
      '/payment-method';

  static const String addCard =
      '/add-card';

  static const String cardResult =
      '/card-result';
  
  static const String orderSummary =
    '/order-summary';

  static const String orderProcessing =
    '/order-processing';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) =>
          const LoginPage(),

      home: (context) =>
          const HomePage(),

      forgotPassword: (context) =>
          const ForgotPasswordPage(),

      googleLogin: (context) =>
          const GoogleLoginPage(),

      register: (context) =>
          const RegisterPage(),

      verifyEmail: (context) =>
          const VerifyEmailPage(),

      checkout: (context) =>
          const CheckoutPage(),

      addressSearch: (context) =>
          const AddressSearchPage(),

      paymentMethod: (context) =>
          const PaymentMethodPage(),

      addCard: (context) =>
          const AddCardPage(),

      cardResult: (context) =>
          const CardResultPage(),

      orderSummary: (context) =>
          const OrderSummaryPage(),

      orderProcessing: (context) =>
          const OrderProcessingPage(),
    };
  }
}