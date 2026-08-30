import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../state/app_state.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  final AppState appState = AppState.instance;

  // ============================================================
  // SELECCIONAR MÉTODO
  // ============================================================

  void seleccionarMetodo(String metodo) {
    appState.seleccionarMetodoPago(metodo);

    Navigator.pop(
      context,
      metodo,
    );
  }

  // ============================================================
  // AGREGAR TARJETA
  // ============================================================

  Future<void> agregarMetodoPago() async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.addCard,
    );

    if (!mounted) {
      return;
    }

    if (resultado is String &&
        resultado.startsWith('Visa')) {
      setState(() {
        appState.agregarTarjeta(resultado);
      });
    }
  }

  // ============================================================
  // ELIMINAR TARJETA
  // ============================================================

  Future<void> eliminarTarjeta(String tarjeta) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Eliminar tarjeta',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            '¿Deseas eliminar la tarjeta $tarjeta?',
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Color(0xFF777777),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  color: Color(0xFFFF4D4D),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        appState.eliminarTarjeta(tarjeta);
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tarjeta eliminada.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // PANTALLA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            _divider(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        20,
                        24,
                        10,
                      ),
                      child: Text(
                        'Métodos de pago',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),

                    // ============================================
                    // TARJETAS GUARDADAS
                    // ============================================

                    ...appState.tarjetasGuardadas.map(
                      (tarjeta) {
                        return Column(
                          children: [
                            _cardOption(
                              tarjeta: tarjeta,
                            ),
                            _divider(),
                          ],
                        );
                      },
                    ),

                    // ============================================
                    // MERCADO PAGO
                    // ============================================

                    _paymentOption(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: const Color(0xFF1976D2),
                      title: 'Mercado Pago',
                      selected:
                          appState.metodoPagoSeleccionado ==
                              'Mercado Pago',
                      onTap: () {
                        seleccionarMetodo(
                          'Mercado Pago',
                        );
                      },
                    ),

                    _divider(),

                    // ============================================
                    // EFECTIVO
                    // ============================================

                    _paymentOption(
                      icon: Icons.payments_outlined,
                      iconColor: const Color(0xFF66BB6A),
                      title: 'Efectivo',
                      selected:
                          appState.metodoPagoSeleccionado ==
                              'Efectivo',
                      onTap: () {
                        seleccionarMetodo(
                          'Efectivo',
                        );
                      },
                    ),

                    _divider(),

                    // ============================================
                    // AGREGAR MÉTODO
                    // ============================================

                    InkWell(
                      onTap: agregarMetodoPago,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 21,
                              color: primaryColor,
                            ),

                            SizedBox(width: 14),

                            Expanded(
                              child: Text(
                                'Agregar un método de pago',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF303030),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    _divider(),
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
  // TARJETA
  // ============================================================

  Widget _cardOption({
    required String tarjeta,
  }) {
    final bool seleccionada =
        appState.metodoPagoSeleccionado == tarjeta;

    return InkWell(
      onTap: () {
        seleccionarMetodo(tarjeta);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 15,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.credit_card,
              size: 21,
              color: Color(0xFF1565C0),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                tarjeta,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),
            ),

            if (seleccionada)
              const Padding(
                padding: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 20,
                  color: primaryColor,
                ),
              ),

            // ELIMINAR TARJETA
            IconButton(
              tooltip: 'Eliminar tarjeta',
              onPressed: () {
                eliminarTarjeta(tarjeta);
              },
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // OTROS MÉTODOS
  // ============================================================

  Widget _paymentOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: iconColor,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_circle,
                size: 20,
                color: primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
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
                Icons.close,
                size: 22,
                color: Color(0xFF252525),
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Paga con',
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

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFEAEAEA),
    );
  }
}