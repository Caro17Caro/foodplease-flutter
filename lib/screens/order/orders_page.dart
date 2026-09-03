import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  bool loading = true;
  String? errorMessage;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await ApiService.getOrders();

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        final dynamic currentOrders = response['current_orders'];
        final dynamic previousOrders = response['previous_orders'];

        final List<Map<String, dynamic>> loadedOrders = [];

        if (currentOrders is List) {
          for (final item in currentOrders) {
            if (item is Map) {
              loadedOrders.add(Map<String, dynamic>.from(item));
            }
          }
        }

        if (previousOrders is List) {
          for (final item in previousOrders) {
            if (item is Map) {
              loadedOrders.add(Map<String, dynamic>.from(item));
            }
          }
        }

        setState(() {
          orders = loadedOrders;
          loading = false;
        });

        return;
      }

      setState(() {
        loading = false;
        errorMessage =
            response['message'] ?? 'No fue posible cargar tus pedidos.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        loading = false;
        errorMessage = 'No fue posible conectar con el servidor.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
        title: const Text(
          'Mis pedidos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: _loadOrders,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 110),
          const Icon(Icons.cloud_off_outlined, size: 64, color: Colors.black38),
          const SizedBox(height: 18),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 18),
          Center(
            child: TextButton(
              onPressed: _loadOrders,
              child: const Text(
                'Intentar nuevamente',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [
          SizedBox(height: 110),
          Icon(Icons.receipt_long_outlined, size: 70, color: Colors.black26),
          SizedBox(height: 20),
          Text(
            'Aún no tienes pedidos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202020),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Cuando realices un pedido podrás revisarlo aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      children: [
        const Text(
          'Revisa tus pedidos actuales y anteriores',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Color(0xFF777777)),
        ),

        const SizedBox(height: 28),

        ...orders.map(
          (order) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildOrderCard(order),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final String restaurant =
        order['restaurante']?.toString().trim().isNotEmpty == true
        ? order['restaurante'].toString()
        : 'FoodPlease';

    final String product =
        order['producto']?.toString().trim().isNotEmpty == true
        ? order['producto'].toString()
        : 'Pedido FoodPlease';

    final String status = _formatStatus(
      order['estado']?.toString() ?? 'confirmado',
    );

    final int quantity = _toInt(order['cantidad'], fallback: 1);

    final int total = _toInt(order['total']);

    final String orderNumber =
        order['numero_pedido']?.toString().trim().isNotEmpty == true
        ? order['numero_pedido'].toString()
        : 'Pedido';

    final String date = _formatDate(order['fecha']?.toString());

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openOrder(order),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4E4E4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.fastfood_outlined,
                size: 34,
                color: Colors.black45,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202020),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 22,
                        color: Colors.black38,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    orderNumber,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    '$product • $quantity ${quantity == 1 ? 'producto' : 'productos'}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'Total: ${_formatPrice(total)}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),

                  if (date.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openOrder(Map<String, dynamic> order) {
    Navigator.pushNamed(
      context,
      AppRoutes.orderDetail,
      arguments: {
        'orderNumber':
            order['numero_pedido']?.toString() ?? 'Pedido FoodPlease',
        'status': order['estado']?.toString() ?? 'confirmado',
        'restaurant': order['restaurante']?.toString() ?? 'FoodPlease',
        'product': order['producto']?.toString() ?? 'Pedido FoodPlease',
        'image': order['imagen']?.toString() ?? '',
        'date': _formatDate(order['fecha']?.toString()),
        'address': order['direccion']?.toString() ?? 'Dirección no disponible',
        'payment': order['metodo_pago']?.toString() ?? 'Método no disponible',
        'subtotal': _formatPrice(_toInt(order['subtotal'])),
        'shipping': _formatPrice(_toInt(order['envio'])),
        'service': _formatPrice(_toInt(order['tarifa_servicio'])),
        'total': _formatPrice(_toInt(order['total'])),
      },
    );
  }

  int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  String _formatPrice(int value) {
    final String digits = value.toString();
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      final int positionFromRight = digits.length - i;

      buffer.write(digits[i]);

      if (positionFromRight > 1 && positionFromRight % 3 == 1) {
        buffer.write('.');
      }
    }

    return '\$$buffer';
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmado':
        return 'Pedido confirmado';
      case 'preparando':
      case 'en preparación':
      case 'en preparacion':
        return 'En preparación';
      case 'en_camino':
      case 'en camino':
        return 'En camino';
      case 'entregado':
        return 'Entregado';
      case 'cancelado':
        return 'Cancelado';
      default:
        if (status.isEmpty) {
          return 'Pedido confirmado';
        }

        return '${status[0].toUpperCase()}${status.substring(1)}';
    }
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return '';
    }

    final DateTime? date = DateTime.tryParse(rawDate);

    if (date == null) {
      return rawDate;
    }

    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sept',
      'oct',
      'nov',
      'dic',
    ];

    final String day = date.day.toString().padLeft(2, '0');
    final String month = months[date.month - 1];
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');

    return '$day $month ${date.year} • $hour:$minute hrs.';
  }
}
