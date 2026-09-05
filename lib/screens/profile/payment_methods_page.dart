import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  List<Map<String, dynamic>> paymentMethods = [];

  bool cargandoMetodos = true;
  bool procesandoMetodo = false;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final response = await ApiService.getPaymentMethods();

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        final data = response['payment_methods'];

        if (data is List) {
          setState(() {
            paymentMethods = data
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList();

            cargandoMetodos = false;
          });

          return;
        }
      }

      setState(() {
        paymentMethods = [];
        cargandoMetodos = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible cargar los métodos de pago.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        paymentMethods = [];
        cargandoMetodos = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible conectar con el servidor.'),
        ),
      );
    }
  }

  Future<void> _addPaymentMethod() async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.addCard,
      arguments: {
        'fromProfile': true,
        'esPrincipalInicial': paymentMethods.isEmpty,
      },
    );

    if (!mounted) {
      return;
    }

    if (resultado != null) {
      await _loadPaymentMethods();
    }
  }

  Future<void> _confirmDeletePaymentMethod(
    Map<String, dynamic> paymentMethod,
  ) async {
    final descripcion =
        (paymentMethod['descripcion'] ??
                '${paymentMethod['marca']} •••• ${paymentMethod['ultimos_4']}')
            .toString();

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Eliminar método de pago',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('¿Deseas eliminar $descripcion?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) {
      return;
    }

    final dynamic rawId = paymentMethod['id'];

    if (rawId is! int) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible identificar el método de pago.'),
        ),
      );

      return;
    }

    await _deletePaymentMethod(rawId);
  }

  Future<void> _deletePaymentMethod(int paymentMethodId) async {
    setState(() {
      procesandoMetodo = true;
    });

    try {
      final response = await ApiService.deletePaymentMethod(paymentMethodId);

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        await _loadPaymentMethods();

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Método de pago eliminado correctamente.'),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible eliminar el método de pago.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible conectar con el servidor.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          procesandoMetodo = false;
        });
      }
    }
  }

  IconData _getCardIcon(String marca) {
    final normalized = marca.trim().toLowerCase();

    if (normalized.contains('débito') || normalized.contains('debito')) {
      return Icons.account_balance_outlined;
    }

    return Icons.credit_card;
  }

  Widget _buildPaymentMethod(Map<String, dynamic> paymentMethod) {
    final marca = (paymentMethod['marca'] ?? 'Tarjeta').toString();

    final ultimos4 = (paymentMethod['ultimos_4'] ?? '').toString();

    final descripcion =
        (paymentMethod['descripcion'] ?? '$marca •••• $ultimos4').toString();

    final bool esPrincipal = paymentMethod['es_principal'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: esPrincipal
              ? primaryBlue.withValues(alpha: 0.45)
              : const Color(0xFFE4E4E4),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: primaryBlue.withValues(alpha: 0.10),
            child: Icon(_getCardIcon(marca), color: primaryBlue),
          ),

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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (esPrincipal) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: primaryBlue.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Principal',
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  'Método de pago guardado',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          IconButton(
            tooltip: 'Eliminar',
            onPressed: procesandoMetodo
                ? null
                : () {
                    _confirmDeletePaymentMethod(paymentMethod);
                  },
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: procesandoMetodo
              ? null
              : () {
                  Navigator.pop(context);
                },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
        ),
        title: const Text(
          'Métodos de pago',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: cargandoMetodos
            ? const Center(child: CircularProgressIndicator(color: primaryBlue))
            : RefreshIndicator(
                color: primaryBlue,
                onRefresh: _loadPaymentMethods,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  children: [
                    const Text(
                      'Métodos guardados',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (paymentMethods.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.credit_card_off_outlined,
                              size: 42,
                              color: Colors.black38,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Aún no tienes métodos de pago guardados.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...List.generate(paymentMethods.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == paymentMethods.length - 1 ? 0 : 12,
                          ),
                          child: _buildPaymentMethod(paymentMethods[index]),
                        );
                      }),

                    const SizedBox(height: 24),

                    OutlinedButton.icon(
                      onPressed: procesandoMetodo
                          ? null
                          : _addPaymentMethod,
                      icon: const Icon(Icons.add, color: primaryBlue),
                      label: const Text(
                        'Agregar método de pago',
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        side: const BorderSide(color: primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    if (procesandoMetodo) ...[
                      const SizedBox(height: 20),
                      const Center(
                        child: CircularProgressIndicator(
                          color: primaryBlue,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
