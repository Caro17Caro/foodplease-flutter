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
import '../screens/profile/payment_methods_page.dart';

import '../screens/checkout/add_card_page.dart';
import '../screens/checkout/address_search_page.dart';
import '../screens/checkout/card_result_page.dart';
import '../screens/checkout/checkout_page.dart';
import '../screens/checkout/payment_method_page.dart';
import '../screens/checkout/order_summary_page.dart';
import '../screens/checkout/order_processing_page.dart';

import '../screens/order/order_tracking_page.dart';
import '../screens/order/orders_page.dart';
import '../screens/order/order_detail_page.dart';

class AppRoutes {
  // ============================================================
  // AUTENTICACION
  // ============================================================

  static const String login = '/';
  static const String forgotPassword = '/forgot-password';
  static const String googleLogin = '/google-login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';

  // ============================================================
  // HOME, UBICACION Y BUSQUEDA
  // ============================================================

  static const String home = '/home';
  static const String location = '/location';
  static const String locationDenied = '/location-denied';
  static const String search = '/search';
  static const String searchResults = '/search-results';
  static const String noResults = '/no-results';

  // ============================================================
  // RESTAURANTE Y PRODUCTOS
  // ============================================================

  static const String restaurant = '/restaurant';
  static const String productDetail = '/product-detail';

  // ============================================================
  // CARRITO
  // ============================================================

  static const String cart = '/cart';

  // ============================================================
  // PERFIL
  // ============================================================

  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String addresses = '/addresses';
  static const String profilePaymentMethods = '/profile-payment-methods';

  // ============================================================
  // CHECKOUT
  // ============================================================

  static const String checkout = '/checkout';
  static const String addressSearch = '/address-search';
  static const String paymentMethod = '/payment-method';
  static const String addCard = '/add-card';
  static const String cardResult = '/card-result';
  static const String orderSummary = '/order-summary';
  static const String orderProcessing = '/order-processing';

  // ============================================================
  // PEDIDOS
  // ============================================================

  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String orderTracking = '/order-tracking';

  // ============================================================
  // RUTAS
  // ============================================================

  static Map<String, WidgetBuilder> get routes {
    return {
      // Autenticacion
      login: (context) => const LoginPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      googleLogin: (context) => const GoogleLoginPage(),
      register: (context) => const RegisterPage(),
      verifyEmail: (context) => const VerifyEmailPage(),

      // Home, ubicacion y busqueda
      home: (context) => const HomePage(),
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
      profilePaymentMethods: (context) => const PaymentMethodsPage(),

      // Checkout
      checkout: (context) => const CheckoutPage(),
      addressSearch: (context) => const AddressSearchPage(),
      paymentMethod: (context) => const PaymentMethodPage(),
      addCard: (context) => const AddCardPage(),
      cardResult: (context) => const CardResultPage(),
      orderSummary: (context) => const OrderSummaryPage(),
      orderProcessing: (context) => const OrderProcessingPage(),

      // Pedidos
      orders: (context) => const OrdersPage(),
      orderDetail: (context) => const OrderDetailPage(),
      orderTracking: (context) => const OrderTrackingPage(),
    };
  }
}
