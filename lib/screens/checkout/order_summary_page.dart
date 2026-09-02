import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../state/app_state.dart';
import '../../state/cart_state.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  static const int deliveryCost = 1000;
  static const int serviceFee = 590;

  bool _creatingOrder = false;

  int get cartQuantity => CartState.quantity;
  int get cartSubtotal => CartState.total;
  int get orderTotal => cartSubtotal + deliveryCost + serviceFee;

  @override
  Widget build(BuildContext context) {
    final metodoPago = AppState.instance.metodoPagoSeleccionado;
    final direccion = AppState.instance.direccionSeleccionada;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ==================================================
                    // INFORMACIÓN DEL PEDIDO
                    // ==================================================

                    _sectionTitle('Información del pedido'),

                    _infoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Dirección de entrega',
                      value: direccion,
                    ),

                    _divider(),

                    _infoRow(
                      icon: Icons.schedule_outlined,
                      title: 'Tiempo estimado',
                      value: '25–30 minutos',
                    ),

                    _divider(),

                    _infoRow(
                      icon: Icons.credit_card_outlined,
                      title: 'Método de pago',
                      value: metodoPago,
                    ),

                    _divider(),

                    const SizedBox(height: 8),

                    // ==================================================
                    // TU PEDIDO
                    // ==================================================
                    _sectionTitle('Tu pedido'),

                    ...CartState.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        child: _buildOrderProduct(
                          restaurant: item['restaurant'] ?? 'FoodPlease',
                          name: item['name'] ?? 'Producto',
                          description: item['description'] ?? '',
                          image: item['image'] ?? '',
                          quantity: item['quantity'] ?? 1,
                          total: item['total'] ?? 0,
                        ),
                      ),
                    ),

                    ...CartState.offerQuantities.entries
                        .where((entry) => entry.value > 0)
                        .map((entry) {
                          final offer = _offerData(entry.key);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            child: _buildOrderProduct(
                              restaurant: 'FoodPlease',
                              name: entry.key,
                              description: offer['description'] as String,
                              image: offer['image'] as String,
                              quantity: entry.value,
                              total: (offer['price'] as int) * entry.value,
                            ),
                          );
                        }),

                    const SizedBox(height: 25),

                    // ==================================================
                    // TOTALES
                    // ==================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children: [
                          _SummaryTotalRow(
                            title: 'Subtotal ($cartQuantity)',
                            value: '\$${_formatPrice(cartSubtotal)}',
                          ),

                          const SizedBox(height: 10),

                          _SummaryTotalRow(
                            title: 'Total de envío',
                            value: '\$${_formatPrice(deliveryCost)}',
                          ),

                          const SizedBox(height: 10),

                          _SummaryTotalRow(
                            title: 'Tarifa por servicio',
                            value: '\$${_formatPrice(serviceFee)}',
                          ),

                          const SizedBox(height: 13),

                          const Divider(height: 1, color: Color(0xFFEAEAEA)),

                          const SizedBox(height: 13),

                          _SummaryTotalRow(
                            title: 'Total',
                            value: '\$${_formatPrice(orderTotal)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ==================================================
            // CONFIRMAR PEDIDO
            // ==================================================
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _creatingOrder ? null : _confirmOrder,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryColor.withValues(
                      alpha: 0.55,
                    ),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: _creatingOrder
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Confirmar pedido',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CREAR PEDIDO REAL
  // ============================================================

  Future<void> _confirmOrder() async {
    if (_creatingOrder) {
      return;
    }

    if (CartState.isEmpty || cartQuantity <= 0) {
      _showError('Tu carrito está vacío. Agrega productos antes de confirmar.');
      return;
    }

    final direccion = AppState.instance.direccionSeleccionada.trim();

    final metodoPago = AppState.instance.metodoPagoSeleccionado.trim();

    if (direccion.isEmpty) {
      _showError('Selecciona una dirección de entrega.');
      return;
    }

    if (metodoPago.isEmpty) {
      _showError('Selecciona un método de pago.');
      return;
    }

    final String restaurante = _buildRestaurantSummary();

    final String productos = _buildProductSummary();

    final String? imagen = _firstProductImage();

    final int totalPedido = orderTotal;

    setState(() {
      _creatingOrder = true;
    });

    try {
      final response = await ApiService.createOrder(
        restaurante: restaurante,
        producto: productos,
        cantidad: cartQuantity,
        direccion: direccion,
        metodoPago: metodoPago,
        subtotal: cartSubtotal,
        envio: deliveryCost,
        tarifaServicio: serviceFee,
        imagen: imagen,
        estado: 'confirmado',
      );

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      final bool success =
          response['status'] == 'ok' &&
          statusCode == 201 &&
          response['order'] != null;

      if (!success) {
        final String message =
            response['message']?.toString() ??
            'No pudimos crear el pedido. Intenta nuevamente.';

        _showError(message);

        setState(() {
          _creatingOrder = false;
        });

        return;
      }

      final Map<String, dynamic> order = Map<String, dynamic>.from(
        response['order'] as Map,
      );

      final String numeroPedido = order['numero_pedido']?.toString() ?? '';

      final int? orderId = order['id'] is int
          ? order['id'] as int
          : int.tryParse(order['id']?.toString() ?? '');

      // El pedido ya fue creado correctamente en Flask.
      // Recién en este punto limpiamos el carrito.
      CartState.clear();

      if (!mounted) {
        return;
      }

      Navigator.pushNamed(
        context,
        AppRoutes.orderProcessing,
        arguments: {
          'status': 'success',
          'total': totalPedido,
          'numeroPedido': numeroPedido,
          'orderId': orderId,
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError(
        'No fue posible conectar con el servidor. '
        'Verifica que el backend esté ejecutándose.',
      );

      setState(() {
        _creatingOrder = false;
      });
    }
  }

  // ============================================================
  // RESUMEN PARA EL BACKEND
  // ============================================================

  String _buildProductSummary() {
    final List<String> products = [];

    for (final item in CartState.items) {
      final String name = item['name']?.toString() ?? 'Producto';

      final int quantity = item['quantity'] is int
          ? item['quantity'] as int
          : int.tryParse(item['quantity']?.toString() ?? '') ?? 1;

      products.add('$name x$quantity');
    }

    for (final entry in CartState.offerQuantities.entries) {
      if (entry.value > 0) {
        products.add('${entry.key} x${entry.value}');
      }
    }

    if (products.isEmpty) {
      return 'Pedido FoodPlease';
    }

    return _limitText(products.join(', '), 150);
  }

  String _buildRestaurantSummary() {
    final Set<String> restaurants = {};

    for (final item in CartState.items) {
      final String restaurant = item['restaurant']?.toString().trim() ?? '';

      if (restaurant.isNotEmpty) {
        restaurants.add(restaurant);
      }
    }

    final bool hasOffers = CartState.offerQuantities.values.any(
      (quantity) => quantity > 0,
    );

    if (hasOffers) {
      restaurants.add('FoodPlease');
    }

    if (restaurants.isEmpty) {
      return 'FoodPlease';
    }

    if (restaurants.length == 1) {
      return _limitText(restaurants.first, 150);
    }

    return _limitText(restaurants.join(', '), 150);
  }

  String? _firstProductImage() {
    for (final item in CartState.items) {
      final String image = item['image']?.toString().trim() ?? '';

      if (image.isNotEmpty) {
        return image;
      }
    }

    for (final entry in CartState.offerQuantities.entries) {
      if (entry.value > 0) {
        final offer = _offerData(entry.key);

        final String image = offer['image']?.toString() ?? '';

        if (image.isNotEmpty) {
          return image;
        }
      }
    }

    return null;
  }

  String _limitText(String value, int maxLength) {
    if (value.length <= maxLength) {
      return value;
    }

    if (maxLength <= 3) {
      return value.substring(0, maxLength);
    }

    return '${value.substring(0, maxLength - 3)}...';
  }

  // ============================================================
  // MENSAJE DE ERROR
  // ============================================================

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // ============================================================
  // PRODUCTO DEL RESUMEN
  // ============================================================

  Widget _buildOrderProduct({
    required String restaurant,
    required String name,
    required String description,
    required String image,
    required int quantity,
    required int total,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: image.isNotEmpty
              ? Image.asset(
                  image,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _productPlaceholder();
                  },
                )
              : _productPlaceholder(),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant,
                style: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A)),
              ),

              const SizedBox(height: 5),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF303030),
                ),
              ),

              if (description.isNotEmpty) ...[
                const SizedBox(height: 4),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF555555),
                  ),
                ),
              ],

              const SizedBox(height: 5),

              Text(
                'Cantidad: $quantity',
                style: const TextStyle(fontSize: 11, color: Color(0xFF303030)),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Text(
          '\$${_formatPrice(total)}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF303030),
          ),
        ),
      ],
    );
  }

  Widget _productPlaceholder() {
    return Container(
      width: 76,
      height: 76,
      color: const Color(0xFFF2F2F2),
      child: const Icon(Icons.lunch_dining, size: 44, color: Color(0xFF8E8E8E)),
    );
  }

  // ============================================================
  // DATOS DE OFERTAS
  // ============================================================

  Map<String, dynamic> _offerData(String name) {
    switch (name) {
      case 'Tiramisú':
        return {
          'description': 'Exquisito postre italiano',
          'image': 'assets/images/pizza_burrata.jpeg',
          'price': 6990,
        };

      case 'Coca-Cola':
        return {
          'description': 'Lata 350 ml',
          'image': 'assets/images/coca_cola.jpeg',
          'price': 1200,
        };

      case 'Sprite':
        return {
          'description': 'Lata 350 ml',
          'image': 'assets/images/sprite-350-ml.png',
          'price': 1200,
        };

      default:
        return {'description': '', 'image': '', 'price': 0};
    }
  }

  // ============================================================
  // FORMATO DE PRECIOS
  // ============================================================

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 57,
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: IconButton(
              onPressed: _creatingOrder
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xFF252525),
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Resumen del pedido',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202020),
              ),
            ),
          ),

          const SizedBox(width: 56),
        ],
      ),
    );
  }

  // ============================================================
  // TÍTULO DE SECCIÓN
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF303030),
        ),
      ),
    );
  }

  // ============================================================
  // FILA DE INFORMACIÓN
  // ============================================================

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF303030)),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF888888),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF303030),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA));
  }
}

// ============================================================
// FILAS DE TOTALES
// ============================================================

class _SummaryTotalRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _SummaryTotalRow({
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 13 : 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xFF303030),
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 13 : 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xFF303030),
          ),
        ),
      ],
    );
  }
}
