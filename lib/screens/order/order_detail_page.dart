import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  static const Color primaryColor =
      Color(0xFF29ABE2);

  @override
  Widget build(BuildContext context) {
    final Object? arguments =
        ModalRoute.of(context)?.settings.arguments;

    final Map<String, dynamic> order =
        arguments is Map<String, dynamic>
            ? arguments
            : <String, dynamic>{};

    final String orderNumber =
        order['orderNumber'] ?? 'FP-1523';

    final String restaurant =
        order['restaurant'] ??
            'Pizzería Napoli';

    final String product =
        order['product'] ??
            'Pizza Burrata - Pesto';

    final String imagePath =
        order['image'] ??
            'assets/images/pizza_napolitana_pesto.jpeg';

    final String date =
        order['date'] ??
            '12 ago 2026 • 20:15 hrs.';

    final String address =
        order['address'] ??
            'Pasaje Matucana 8853, La Reina';

    final String payment =
        order['payment'] ??
            'Tarjeta terminada en •••••5623';

    final String subtotal =
        order['subtotal'] ?? '\$9.400.-';

    final String shipping =
        order['shipping'] ?? '\$1.000.-';

    final String service =
        order['service'] ?? '\$590.-';

    final String total =
        order['total'] ?? '\$10.990.-';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            const Divider(
              height: 1,
              color: Color(0xFFEAEAEA),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  12,
                  22,
                  25,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // PEDIDO
                    // ==================================================

                    Text(
                      'Pedido #$orderNumber',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor:
                              Color(0xFF2ECC40),
                        ),

                        SizedBox(width: 8),

                        Text(
                          'Entregado',
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color:
                            Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==================================================
                    // DIRECCIÓN
                    // ==================================================

                    const Text(
                      'Dirección de entrega',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          size: 25,
                          color:
                              Color(0xFF303030),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            address,
                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .w600,
                              color:
                                  Color(
                                0xFF202020,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ==================================================
                    // TU PEDIDO
                    // ==================================================

                    const Text(
                      'Tu pedido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                          child: Image.asset(
                            imagePath,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                width: 80,
                                height: 80,
                                color:
                                    const Color(
                                  0xFFE8E8E8,
                                ),
                                child: const Icon(
                                  Icons
                                      .fastfood_outlined,
                                  size: 45,
                                  color:
                                      Color(
                                    0xFF888888,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 28),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                product,
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .w500,
                                  color:
                                      Color(
                                    0xFF202020,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 2,
                              ),

                              Text(
                                restaurant,
                                style:
                                    const TextStyle(
                                  fontSize: 11,
                                  color:
                                      Color(
                                    0xFF888888,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                '1 x $subtotal',
                                style:
                                    const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color:
                                      Color(
                                    0xFF202020,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ==================================================
                    // MÉTODO DE PAGO
                    // ==================================================

                    const Text(
                      'Método de pago',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(
                          Icons.credit_card,
                          size: 34,
                          color:
                              Color(0xFF173B44),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            payment,
                            style:
                                const TextStyle(
                              fontSize: 16,
                              color:
                                  Color(
                                0xFF202020,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // ==================================================
                    // RESUMEN
                    // ==================================================

                    const Text(
                      'Resumen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _DetailTotalRow(
                      label: 'Subtotal',
                      value: subtotal,
                    ),

                    const SizedBox(height: 12),

                    _DetailTotalRow(
                      label: 'Envío',
                      value: shipping,
                    ),

                    const SizedBox(height: 12),

                    _DetailTotalRow(
                      label:
                          'Tarifa por servicio',
                      value: service,
                    ),

                    const SizedBox(height: 12),

                    _DetailTotalRow(
                      label: 'Total',
                      value: total,
                    ),
                  ],
                ),
              ),
            ),

            _bottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
  ) {
    return SizedBox(
      height: 57,
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons
                    .arrow_back_ios_new_rounded,
                size: 20,
                color:
                    Color(0xFF202020),
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Detalle del pedido',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF202020),
              ),
            ),
          ),

          const SizedBox(width: 56),
        ],
      ),
    );
  }

  // ============================================================
  // BARRA INFERIOR
  // ============================================================

  Widget _bottomNavigation() {
    return Container(
      height: 72,
      decoration:
          const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color:
                Color(0xFFEAEAEA),
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.home,
            size: 27,
            color:
                Color(0xFF666666),
          ),

          Icon(
            Icons.explore_outlined,
            size: 27,
            color:
                Color(0xFF666666),
          ),

          Icon(
            Icons.shopping_cart_outlined,
            size: 27,
            color:
                Color(0xFF666666),
          ),

          Icon(
            Icons.notifications_none,
            size: 27,
            color:
                Color(0xFF666666),
          ),

          Icon(
            Icons.person_outline,
            size: 27,
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RESUMEN DEL PEDIDO
// ============================================================

class _DetailTotalRow
    extends StatelessWidget {
  final String label;
  final String value;

  const _DetailTotalRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: [
        Text(
          label,
          style:
              const TextStyle(
            fontSize: 14,
            color:
                Color(0xFF202020),
          ),
        ),

        const SizedBox(width: 4),

        Expanded(
          child: Text(
            '.' * 45,
            maxLines: 1,
            overflow:
                TextOverflow.clip,
            style:
                const TextStyle(
              fontSize: 12,
              color:
                  Color(0xFF777777),
            ),
          ),
        ),

        Text(
          value,
          style:
              const TextStyle(
            fontSize: 14,
            color:
                Color(0xFF202020),
          ),
        ),
      ],
    );
  }
}