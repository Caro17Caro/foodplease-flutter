import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const Color primaryColor = Color(0xFF29ABE2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  18,
                  16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // ==================================================
                    // TÍTULO
                    // ==================================================

                    const Text(
                      'Mis pedidos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Revisa tus pedidos actuales y anteriores',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 34),

                    // ==================================================
                    // PEDIDO ACTUAL
                    // ==================================================

                    const Text(
                      'Pedido actual',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 14),

                    _OrderCard(
                      restaurant:
                          'La Casa de la Hamburguesa',
                      status: 'En camino',
                      product:
                          'Doble carne • 1 producto',
                      total: '\$9.990.-',

                      // TEMPORAL:
                      // se reemplazará cuando tengamos
                      // la imagen correcta de Doble carne.
                      imagePath:
                          'assets/images/barros_luco.jpeg',

                      currentOrder: true,

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderTracking,
                          arguments: 'online',
                        );
                      },
                    ),

                    const SizedBox(height: 34),

                    // ==================================================
                    // PEDIDOS ANTERIORES
                    // ==================================================

                    const Text(
                      'Pedidos anteriores',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // PIZZERÍA NAPOLI
                    // ==================================================

                    _OrderCard(
                      restaurant: 'Pizzería Napoli',
                      status: 'Entregado',
                      product:
                          'Pizza Burrata - Pesto • 1 producto',
                      total: '\$10.990.-',
                      date: '12 ago 2026',
                      imagePath:
                          'assets/images/pizza_napolitana_pesto.jpeg',

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderDetail,
                          arguments: {
                            'orderNumber': 'FP-1523',
                            'restaurant':
                                'Pizzería Napoli',
                            'product':
                                'Pizza Burrata - Pesto',
                            'image':
                                'assets/images/pizza_napolitana_pesto.jpeg',
                            'date':
                                '12 ago 2026 • 20:15 hrs.',
                            'address':
                                'Pasaje Matucana 8853, La Reina',
                            'payment':
                                'Tarjeta terminada en •••••5623',

                            // Total:
                            // 9.400 + 1.000 + 590 = 10.990
                            'subtotal': '\$9.400.-',
                            'shipping': '\$1.000.-',
                            'service': '\$590.-',
                            'total': '\$10.990.-',
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // BARROS LUCO
                    // ==================================================

                    _OrderCard(
                      restaurant:
                          'La Casa de la Hamburguesa',
                      status: 'Entregado',
                      product:
                          'Barros Luco • 1 producto',
                      total: '\$6.990.-',
                      date: '15 jul 2026',
                      imagePath:
                          'assets/images/barros_luco.jpeg',

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderDetail,
                          arguments: {
                            'orderNumber': 'FP-1418',
                            'restaurant':
                                'La Casa de la Hamburguesa',
                            'product': 'Barros Luco',
                            'image':
                                'assets/images/barros_luco.jpeg',
                            'date':
                                '15 jul 2026 • 13:40 hrs.',
                            'address':
                                'Pasaje Matucana 8853, La Reina',
                            'payment':
                                'Tarjeta terminada en •••••5623',

                            // Total:
                            // 5.400 + 1.000 + 590 = 6.990
                            'subtotal': '\$5.400.-',
                            'shipping': '\$1.000.-',
                            'service': '\$590.-',
                            'total': '\$6.990.-',
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // BARRA INFERIOR
            // ==================================================

            _bottomNavigation(context),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BARRA DE NAVEGACIÓN INFERIOR
  // ============================================================

  Widget _bottomNavigation(
    BuildContext context,
  ) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEAEAEA),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _navButton(
            icon: Icons.home,
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
          ),

          _navButton(
            icon: Icons.explore_outlined,
            onTap: () {
              _mostrarMensaje(
                context,
                'Explorar se conectará con el módulo Home.',
              );
            },
          ),

          _navButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () {
              _mostrarMensaje(
                context,
                'Carrito disponible al integrar el módulo correspondiente.',
              );
            },
          ),

          _navButton(
            icon: Icons.notifications_none,
            onTap: () {
              _mostrarMensaje(
                context,
                'No tienes notificaciones nuevas.',
              );
            },
          ),

          _navButton(
            icon: Icons.person_outline,
            selected: true,
            onTap: () {
              _mostrarMensaje(
                context,
                'Perfil se conectará con el módulo correspondiente.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 27,
        color: selected
            ? primaryColor
            : const Color(0xFF666666),
      ),
    );
  }

  void _mostrarMensaje(
    BuildContext context,
    String mensaje,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }
}

// ============================================================
// TARJETA DE PEDIDO
// ============================================================

class _OrderCard extends StatelessWidget {
  final String restaurant;
  final String status;
  final String product;
  final String total;
  final String? date;
  final String imagePath;
  final bool currentOrder;
  final VoidCallback onTap;

  const _OrderCard({
    required this.restaurant,
    required this.status,
    required this.product,
    required this.total,
    required this.imagePath,
    required this.onTap,
    this.date,
    this.currentOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        10,
        8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius:
            BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFE2E2E2),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF202020),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: currentOrder
                        ? const Color(
                            0xFF29ABE2,
                          )
                        : const Color(
                            0xFF777777,
                          ),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  product,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color:
                        Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Total: $total',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color:
                        Color(0xFF777777),
                  ),
                ),

                if (date != null) ...[
                  const SizedBox(height: 7),

                  Text(
                    date!,
                    style:
                        const TextStyle(
                      fontSize: 11.5,
                      color:
                          Color(
                        0xFF777777,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 7),

                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    currentOrder
                        ? 'Ver seguimiento >'
                        : 'Ver detalle >',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color:
                          Color(0xFF29ABE2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ====================================================
          // IMAGEN
          // ====================================================

          ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  width: 82,
                  height: 82,
                  color: const Color(
                    0xFFE6E6E6,
                  ),
                  child: const Icon(
                    Icons.fastfood_outlined,
                    size: 40,
                    color:
                        Color(0xFF888888),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}