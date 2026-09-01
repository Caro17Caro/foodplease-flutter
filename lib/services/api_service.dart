import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Android Emulator:
  // 10.0.2.2 apunta al computador donde está corriendo Flask.
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static String? _token;

  static String? get token => _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> _headers({
    bool authenticated = false,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (authenticated && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // ============================================================
  // HEALTH
  // ============================================================

  static Future<Map<String, dynamic>> health() async {
    final response = await http.get(
      Uri.parse('$baseUrl/health'),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // LOGIN
  // ============================================================

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = _decodeResponse(response);

    if (response.statusCode == 200 &&
        data['access_token'] != null) {
      setToken(data['access_token']);
    }

    return data;
  }

  // ============================================================
  // REGISTRO
  // ============================================================

  static Future<Map<String, dynamic>> register({
    required String nombre,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _headers(),
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'password': password,
      }),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // PERFIL
  // ============================================================

  static Future<Map<String, dynamic>> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: _headers(
        authenticated: true,
      ),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> updateMe({
    required String nombre,
    required String email,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/me'),
      headers: _headers(
        authenticated: true,
      ),
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
      }),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // RESTAURANTES
  // ============================================================

  static Future<Map<String, dynamic>> getRestaurants() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurants'),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> getRestaurant(
    int restaurantId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/restaurants/$restaurantId',
      ),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // PRODUCTOS
  // ============================================================

  static Future<Map<String, dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> getRestaurantProducts(
    int restaurantId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/restaurants/$restaurantId/products',
      ),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> getProduct(
    int productId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/products/$productId',
      ),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // DIRECCIONES
  // ============================================================

  static Future<Map<String, dynamic>> getAddresses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/addresses'),
      headers: _headers(
        authenticated: true,
      ),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> createAddress({
    required String nombre,
    required String direccion,
    required String comuna,
    String referencia = '',
    bool esPrincipal = false,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addresses'),
      headers: _headers(
        authenticated: true,
      ),
      body: jsonEncode({
        'nombre': nombre,
        'direccion': direccion,
        'comuna': comuna,
        'referencia': referencia,
        'es_principal': esPrincipal,
      }),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> updateAddress({
    required int addressId,
    required String nombre,
    required String direccion,
    required String comuna,
    String referencia = '',
    bool esPrincipal = false,
  }) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/addresses/$addressId',
      ),
      headers: _headers(
        authenticated: true,
      ),
      body: jsonEncode({
        'nombre': nombre,
        'direccion': direccion,
        'comuna': comuna,
        'referencia': referencia,
        'es_principal': esPrincipal,
      }),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> deleteAddress(
    int addressId,
  ) async {
    final response = await http.delete(
      Uri.parse(
        '$baseUrl/addresses/$addressId',
      ),
      headers: _headers(
        authenticated: true,
      ),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // METODOS DE PAGO
  // ============================================================

  static Future<Map<String, dynamic>> getPaymentMethods() async {
    final response = await http.get(
      Uri.parse('$baseUrl/payment-methods'),
      headers: _headers(
        authenticated: true,
      ),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> createPaymentMethod({
    required String marca,
    required String ultimos4,
    bool esPrincipal = false,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payment-methods'),
      headers: _headers(
        authenticated: true,
      ),
      body: jsonEncode({
        'marca': marca,
        'ultimos_4': ultimos4,
        'es_principal': esPrincipal,
      }),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> deletePaymentMethod(
    int paymentMethodId,
  ) async {
    final response = await http.delete(
      Uri.parse(
        '$baseUrl/payment-methods/$paymentMethodId',
      ),
      headers: _headers(
        authenticated: true,
      ),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // PEDIDOS
  // ============================================================

  static Future<Map<String, dynamic>> getOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: _headers(
        authenticated: true,
      ),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> getOrder(
    int orderId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: _headers(
        authenticated: true,
      ),
    );

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> createOrder({
    required String restaurante,
    required String producto,
    required String direccion,
    required String metodoPago,
    required int subtotal,
    int cantidad = 1,
    String? adicionales,
    String? imagen,
    String estado = 'confirmado',
    int envio = 1000,
    int tarifaServicio = 590,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: _headers(
        authenticated: true,
      ),
      body: jsonEncode({
        'restaurante': restaurante,
        'producto': producto,
        'cantidad': cantidad,
        'adicionales': adicionales,
        'imagen': imagen,
        'estado': estado,
        'direccion': direccion,
        'metodo_pago': metodoPago,
        'subtotal': subtotal,
        'envio': envio,
        'tarifa_servicio': tarifaServicio,
      }),
    );

    return _decodeResponse(response);
  }

  // ============================================================
  // RESPUESTAS
  // ============================================================

  static Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    Map<String, dynamic> data;

    try {
      data = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
    } catch (_) {
      data = {
        'status': 'error',
        'message': 'Respuesta inválida del servidor',
      };
    }

    data['status_code'] = response.statusCode;

    return data;
  }
}