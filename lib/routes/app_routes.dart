import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_page.dart';
import '../screens/auth/google_login_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/auth/verify_email_page.dart';

import '../screens/home/home_page.dart';
import '../screens/home/location_page.dart';
import '../screens/home/location_denied_page.dart';
import '../screens/home/search_page.dart';
import '../screens/home/search_results_page.dart';
import '../screens/home/no_results_page.dart';

import '../screens/restaurant/restaurant_page.dart';
import '../screens/restaurant/product_detail_page.dart';

import '../screens/cart/cart_page.dart';

import '../screens/profile/profile_page.dart';
import '../screens/profile/edit_profile_page.dart';
import '../screens/profile/addresses_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';

  // Autenticación
  static const String forgotPassword = '/forgot-password';
  static const String googleLogin = '/google-login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';

  // Home, ubicación y búsqueda
  static const String location = '/location';
  static const String locationDenied = '/location-denied';
  static const String search = '/search';
  static const String searchResults = '/search-results';
  static const String noResults = '/no-results';

  // Restaurante y productos
  static const String restaurant = '/restaurant';
  static const String productDetail = '/product-detail';

  // Carrito
  static const String cart = '/cart';

  // Perfil
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String addresses = '/addresses';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const HomePage(),

      // Autenticación
      forgotPassword: (context) => const ForgotPasswordPage(),
      googleLogin: (context) => const GoogleLoginPage(),
      register: (context) => const RegisterPage(),
      verifyEmail: (context) => const VerifyEmailPage(),

      // Home, ubicación y búsqueda
      location: (context) => const LocationPage(),
      locationDenied: (context) => const LocationDeniedPage(),
      search: (context) => const SearchPage(),
      searchResults: (context) => const SearchResultsPage(),
      noResults: (context) => const NoResultsPage(),

      // Restaurante y productos
      restaurant: (context) => const RestaurantPage(),
      productDetail: (context) => const ProductDetailPage(),

      // Carrito
      cart: (context) => const CartPage(),

      // Perfil
      profile: (context) => const ProfilePage(),
      editProfile: (context) => const EditProfilePage(),
      addresses: (context) => const AddressesPage(),
    };
  }
}
