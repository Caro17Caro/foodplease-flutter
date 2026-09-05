import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../state/app_state.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  final AppState appState = AppState.instance;

  List<Map<String, dynamic>> paymentMethods = [];

  bool cargandoMetodos = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    if (mounted) {
      setState(() {
        cargandoMetodos = true;
        errorMessage = null;
      });
    }

    try {
      final response = await ApiService.getPaymentMethods();

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        final data = response['payment_methods'];

        if (data is List) {
          final loadedMethods = data
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();

          loadedMethods.sort((a, b) {
            final bool aPrincipal = a['es_principal'] == true;
            final bool bPrincipal = b['es_principal'] == true;

            if (aPrincipal == bPrincipal) {
              return 0;
            }

            return aPrincipal ? -1 : 1;
          });

          _syncSelectedPaymentMethod(loadedMethods);

          setState(() {
            paymentMethods = loadedMethods;
            cargandoMetodos = false;
          });

          return;
        }
      }

      setState(() {
        paymentMethods = [];
        cargandoMetodos = false;
        errorMessage =
            response['message'] ?? 'No fue posible cargar los métodos de pago.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        paymentMethods = [];
        cargandoMetodos = false;
        errorMessage = 'No fue posible conectar con el servidor.';
      });
    }
  }

  void _syncSelectedPaymentMethod(List<Map<String, dynamic>> loadedMethods) {
    final String currentMethod = appState.metodoPagoSeleccionado.trim();

    if (currentMethod == 'Mercado Pago' || currentMethod == 'Efectivo') {
      return;
    }

    final bool currentMethodExists = loadedMethods.any(
      (paymentMethod) => _formatPaymentMethod(paymentMethod) == currentMethod,
    );

    if (currentMethodExists) {
      return;
    }

    Map<String, dynamic>? principalMethod;

    for (final paymentMethod in loadedMethods) {
      if (paymentMethod['es_principal'] == true) {
        principalMethod = paymentMethod;
        break;
      }
    }

    if (principalMethod != null) {
      appState.seleccionarMetodoPago(_formatPaymentMethod(principalMethod));
      return;
    }

    if (loadedMethods.isNotEmpty) {
      appState.seleccionarMetodoPago(_formatPaymentMethod(loadedMethods.first));
      return;
    }

    appState.seleccionarMetodoPago('Mercado Pago');
  }

  String _formatPaymentMethod(Map<String, dynamic> paymentMethod) {
    final marca = (paymentMethod['marca'] ?? 'Tarjeta').toString().trim();

    final ultimos4 = (paymentMethod['ultimos_4'] ?? '').toString().trim();

    final descripcion = paymentMethod['descripcion']?.toString().trim();

    if (descripcion != null && descripcion.isNotEmpty) {
      return descripcion;
    }

    if (ultimos4.isEmpty) {
      return marca;
    }

    return '$marca •••• $ultimos4';
  }

  void seleccionarMetodo(Map<String, dynamic> paymentMethod) {
    final metodo = _formatPaymentMethod(paymentMethod);

    appState.seleccionarMetodoPago(metodo);

    Navigator.pop(context, metodo);
  }

  void seleccionarMercadoPago() {
    appState.seleccionarMetodoPago('Mercado Pago');

    Navigator.pop(context, 'Mercado Pago');
  }

  void seleccionarEfectivo() {
    appState.seleccionarMetodoPago('Efectivo');

    Navigator.pop(context, 'Efectivo');
  }

  Future<void> agregarTarjeta() async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.addCard,
      arguments: {
        'fromProfile': false,
        'esPrincipalInicial': paymentMethods.isEmpty,
      },
    );

    if (!mounted) {
      return;
    }

    await _loadPaymentMethods();

    if (!mounted) {
      return;
    }

    if (resultado is String && resultado.trim().isNotEmpty) {
      appState.seleccionarMetodoPago(resultado);
      Navigator.pop(context, resultado);
    }
  }

  IconData _getCardIcon(String marca) {
    final normalized = marca.trim().toLowerCase();

    if (normalized.contains('débito') || normalized.contains('debito')) {
      return Icons.account_balance_outlined;
    }

    return Icons.credit_card;
  }

  bool _isSelected(Map<String, dynamic> paymentMethod) {
    final metodo = _formatPaymentMethod(paymentMethod);

    return appState.metodoPagoSeleccionado == metodo;
  }

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
              child: RefreshIndicator(
                color: primaryColor,
                onRefresh: _loadPaymentMethods,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                      child: Text(
                        'Métodos de pago guardados',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),

                    if (cargandoMetodos)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      )
                    else if (errorMessage != null)
                      _buildError()
                    else if (paymentMethods.isEmpty)
                      _buildEmpty()
                    else
                      ...paymentMethods.map((paymentMethod) {
                        return Column(
                          children: [
                            _cardOption(paymentMethod: paymentMethod),
                            _divider(),
                          ],
                        );
                      }),

                    _paymentOption(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: const Color(0xFF009EE3),
                      title: 'Mercado Pago',
                      subtitle: 'Paga con tu cuenta de Mercado Pago',
                      selected:
                          appState.metodoPagoSeleccionado == 'Mercado Pago',
                      onTap: seleccionarMercadoPago,
                    ),

                    _divider(),

                    _paymentOption(
                      icon: Icons.payments_outlined,
                      iconColor: const Color(0xFF66BB6A),
                      title: 'Efectivo',
                      subtitle: 'Paga al momento de recibir tu pedido',
                      selected: appState.metodoPagoSeleccionado == 'Efectivo',
                      onTap: seleccionarEfectivo,
                    ),

                    _divider(),

                    InkWell(
                      onTap: agregarTarjeta,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_card_outlined,
                              size: 21,
                              color: primaryColor,
                            ),

                            SizedBox(width: 14),

                            Expanded(
                              child: Text(
                                'Agregar tarjeta',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF303030),
                                ),
                              ),
                            ),

                            Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: Color(0xFF999999),
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

  Widget _cardOption({required Map<String, dynamic> paymentMethod}) {
    final marca = (paymentMethod['marca'] ?? 'Tarjeta').toString();

    final descripcion = _formatPaymentMethod(paymentMethod);

    final bool esPrincipal = paymentMethod['es_principal'] == true;

    final bool seleccionada = _isSelected(paymentMethod);

    return InkWell(
      onTap: () {
        seleccionarMetodo(paymentMethod);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(_getCardIcon(marca), size: 21, color: const Color(0xFF1565C0)),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          descripcion,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF303030),
                          ),
                        ),
                      ),

                      if (esPrincipal) ...[
                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Principal',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    esPrincipal
                        ? 'Método predeterminado'
                        : 'Método de pago guardado',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            if (seleccionada)
              const Icon(Icons.check_circle, size: 20, color: primaryColor)
            else
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF999999),
              ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 21, color: iconColor),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF303030),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              const Icon(Icons.check_circle, size: 20, color: primaryColor)
            else
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF999999),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 45),
      child: Column(
        children: [
          const Icon(
            Icons.credit_card_off_outlined,
            size: 42,
            color: Color(0xFFBDBDBD),
          ),

          const SizedBox(height: 12),

          const Text(
            'Aún no tienes métodos de pago guardados',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Puedes pagar con Mercado Pago, en efectivo o agregar un método de pago guardado.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, color: Color(0xFF888888)),
          ),

          const SizedBox(height: 14),

          TextButton(
            onPressed: agregarTarjeta,
            child: const Text(
              'Agregar método de pago',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 45),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 42,
            color: Color(0xFFBDBDBD),
          ),

          const SizedBox(height: 12),

          Text(
            errorMessage ?? 'No fue posible cargar los métodos de pago.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF777777)),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: _loadPaymentMethods,
            child: const Text(
              'Reintentar',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              icon: const Icon(Icons.close, size: 22, color: Color(0xFF252525)),
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
    return const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA));
  }
}
