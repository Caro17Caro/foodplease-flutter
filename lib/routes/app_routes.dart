import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/home/home_page.dart';
import '../screens/home/location_page.dart';
import '../screens/home/location_denied_page.dart';
import '../screens/home/search_page.dart';
import '../screens/home/search_results_page.dart';
import '../screens/home/no_results_page.dart';
import '../screens/restaurant/restaurant_page.dart';
import '../screens/restaurant/product_detail_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
  static const String location = '/location';
  static const String locationDenied = '/location-denied';
  static const String search = '/search';
  static const String searchResults = '/search-results';
  static const String noResults = '/no-results';
  static const String restaurant = '/restaurant';
  static const String productDetail = '/product-detail';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const HomePage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      location: (context) => const LocationPage(),
      locationDenied: (context) => const LocationDeniedPage(),
      search: (context) => const SearchPage(),
      searchResults: (context) => const SearchResultsPage(),
      noResults: (context) => const NoResultsPage(),
      restaurant: (context) => const RestaurantPage(),
      productDetail: (context) => const ProductDetailPage(),
    };
  }
}
