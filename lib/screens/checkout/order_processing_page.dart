import 'dart:async';

import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class OrderProcessingPage extends StatefulWidget {
  const OrderProcessingPage({super.key});

  @override
  State<OrderProcessingPage> createState() => _OrderProcessingPageState();
}

class _OrderProcessingPageState extends State<OrderProcessingPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  bool procesando = true;
  bool error = false;
  bool procesoIniciado = false;

  int totalPedido = 0;
  String numeroPedido = '';
  int? orderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!procesoIniciado) {
      procesoIniciado = true;

      final arguments = ModalRoute.of(context)?.settings.arguments;

      bool simularError = false;

      if (arguments is Map) {
        final data = Map<String, dynamic>.from(arguments);

        simularError = data['status'] == 'error';

        totalPedido = data['total'] is int
            ? data['total'] as int
            : int.tryParse(data['total']?.toString() ?? '') ?? 0;

        numeroPedido = data['numeroPedido']?.toString() ?? '';

        orderId = data['orderId'] is int
            ? data['orderId'] as int
            : int.tryParse(data['orderId']?.toString() ?? '');
      } else {
        // Compatibilidad con el flujo anterior.
        simularError = arguments == 'error';
      }

      _procesarPedido(simularError);
    }
  }

  Future<void> _procesarPedido(bool simularError) async {
    setState(() {
      procesando = true;
      error = false;
    });

    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) {
      return;
    }

    setState(() {
      procesando = false;
      error = simularError;
    });
  }

  Future<void> _intentarNuevamente() async {
    await _procesarPedido(false);
  }

  @override
  Widget build(BuildContext context) {
    if (procesando) {
      return _buildProcessing();
    }

    if (error) {
      return _buildError();
    }

    return _buildSuccess();
  }

  // ============================================================
  // 42 - PROCESANDO PEDIDO
  // ============================================================

  Widget _buildProcessing() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(title: 'Procesando pedido'),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),

            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: primaryColor,
                    ),
                  ),

                  SizedBox(height: 35),

                  Text(
                    'Estamos procesando tu pedido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF303030),
                    ),
                  ),

                  SizedBox(height: 14),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45),
                    child: Text(
                      'Esto puede tardar unos segundos.\n'
                      'No cierres la aplicación.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 43 - PEDIDO CONFIRMADO
  // ============================================================

  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(title: 'Pedido confirmado'),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    Container(
                      width: 86,
                      height: 86,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEAF8EF),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 58,
                        color: Color(0xFF4CAF50),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      '¡Tu pedido fue confirmado!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF303030),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'El restaurante ya recibió tu pedido.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
                    ),

                    if (numeroPedido.isNotEmpty) ...[
                      const SizedBox(height: 8),

                      Text(
                        'Pedido $numeroPedido',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const _ConfirmationRow(
                            title: 'Tiempo estimado de entrega',
                            value: '25–30 minutos',
                          ),

                          const SizedBox(height: 14),

                          _ConfirmationRow(
                            title: 'Total',
                            value: '\$${_formatPrice(totalPedido)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // ==================================================
                    // SEGUIR PEDIDO
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.orderTracking,
                            arguments: 'online',
                          );
                        },

                        onLongPress: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.orderTracking,
                            arguments: 'offline',
                          );
                        },

                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),

                        child: const Text(
                          'Seguir pedido',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Volver al inicio',
                        style: TextStyle(fontSize: 12, color: primaryColor),
                      ),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 44 - ERROR AL GENERAR PEDIDO
  // ============================================================

  Widget _buildError() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(title: 'Pedido'),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    Container(
                      width: 86,
                      height: 86,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFEEEE),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 58,
                        color: Color(0xFFFF4D4D),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'No pudimos generar tu pedido',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF303030),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Ocurrió un problema mientras intentábamos '
                      'procesar tu pedido.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'No se realizó ningún cobro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
                    ),

                    const Spacer(flex: 3),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: _intentarNuevamente,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Intentar nuevamente',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Volver al resumen del pedido',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildHeader({required String title}) {
    return SizedBox(
      height: 57,
      child: Row(
        children: [
          const SizedBox(width: 56),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
}

// ============================================================
// INFORMACIÓN DE CONFIRMACIÓN
// ============================================================

class _ConfirmationRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _ConfirmationRow({
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              color: const Color(0xFF555555),
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),

        const SizedBox(width: 15),

        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF303030),
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
