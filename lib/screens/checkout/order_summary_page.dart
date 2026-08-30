import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../state/app_state.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  static const Color primaryColor = Color(0xFF29ABE2);

  @override
  Widget build(BuildContext context) {
    final metodoPago =
        AppState.instance.metodoPagoSeleccionado;

    final direccion =
        AppState.instance.direccionSeleccionada;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEAEAEA),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // ==================================================
                    // INFORMACIÓN DEL PEDIDO
                    // ==================================================

                    _sectionTitle(
                      'Información del pedido',
                    ),

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

                    _sectionTitle(
                      'Tu pedido',
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFF2F2F2),
                              borderRadius:
                                  BorderRadius.circular(7),
                            ),
                            child: const Icon(
                              Icons.lunch_dining,
                              size: 44,
                              color: Color(0xFF8E8E8E),
                            ),
                          ),

                          const SizedBox(width: 15),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Casa de la hamburguesa',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        Color(0xFF8A8A8A),
                                  ),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  'Doble carne',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Color(0xFF303030),
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  'Adicional: mayo y poroto verde',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color:
                                        Color(0xFF555555),
                                  ),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  'Cantidad: 1',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        Color(0xFF303030),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          const Text(
                            '\$12.990',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w500,
                              color:
                                  Color(0xFF303030),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // TOTALES
                    // ==================================================

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child: Column(
                        children: [
                          _SummaryTotalRow(
                            title: 'Subtotal (1)',
                            value: '\$12.990',
                          ),

                          SizedBox(height: 10),

                          _SummaryTotalRow(
                            title: 'Total de envío',
                            value: '\$1.000',
                          ),

                          SizedBox(height: 10),

                          _SummaryTotalRow(
                            title: 'Tarifa por servicio',
                            value: '\$590',
                          ),

                          SizedBox(height: 13),

                          Divider(
                            height: 1,
                            color:
                                Color(0xFFEAEAEA),
                          ),

                          SizedBox(height: 13),

                          _SummaryTotalRow(
                            title: 'Total',
                            value: '\$14.580',
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
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                18,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFEAEAEA),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  // Toque normal:
                  // simula pedido exitoso.
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.orderProcessing,
                      arguments: 'success',
                    );
                  },

                  // Mantener presionado:
                  // simula error al generar pedido.
                  onLongPress: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.orderProcessing,
                      arguments: 'error',
                    );
                  },

                  style: FilledButton.styleFrom(
                    backgroundColor:
                        primaryColor,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7),
                    ),
                  ),

                  child: const Text(
                    'Confirmar pedido',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w500,
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
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color:
                    Color(0xFF252525),
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Resumen del pedido',
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
  // TÍTULO DE SECCIÓN
  // ============================================================

  Widget _sectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight:
              FontWeight.w700,
          color:
              Color(0xFF303030),
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
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 13,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color:
                const Color(0xFF303030),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontSize: 10,
                    color:
                        Color(0xFF888888),
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 12.5,
                    fontWeight:
                        FontWeight.w500,
                    color:
                        Color(0xFF303030),
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
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFEAEAEA),
    );
  }
}

// ============================================================
// FILAS DE TOTALES
// ============================================================

class _SummaryTotalRow
    extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _SummaryTotalRow({
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize:
                bold ? 13 : 12,
            fontWeight: bold
                ? FontWeight.w700
                : FontWeight.w400,
            color:
                const Color(0xFF303030),
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize:
                bold ? 13 : 12,
            fontWeight: bold
                ? FontWeight.w700
                : FontWeight.w400,
            color:
                const Color(0xFF303030),
          ),
        ),
      ],
    );
  }
}