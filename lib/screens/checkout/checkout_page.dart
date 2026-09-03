import 'dart:async';

import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../state/app_state.dart';
import '../../state/cart_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  static const int deliveryCost = 1000;
  static const int serviceFee = 590;

  bool cargando = true;

  int get cartQuantity => CartState.quantity;
  int get cartSubtotal => CartState.total;
  int get orderTotal => cartSubtotal + deliveryCost + serviceFee;

  final TextEditingController promoController = TextEditingController();

  String direccionSeleccionada = AppState.instance.direccionSeleccionada;

  String metodoPagoSeleccionado = AppState.instance.metodoPagoSeleccionado;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1300), () {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    });
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void aplicarPromocion() {
    FocusScope.of(context).unfocus();

    final codigo = promoController.text.trim();

    if (codigo.isEmpty) {
      mostrarMensaje('Ingresa un código de promoción.');
      return;
    }

    mostrarMensaje('Código "$codigo" aplicado en modo simulación.');
  }

  Future<void> abrirBuscadorDireccion() async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.addressSearch,
    );

    if (!mounted) {
      return;
    }

    if (resultado is String && resultado.isNotEmpty) {
      setState(() {
        direccionSeleccionada = resultado;
        AppState.instance.seleccionarDireccion(resultado);
      });
    }
  }

  Future<void> abrirMetodosPago() async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.paymentMethod,
    );

    if (!mounted) {
      return;
    }

    if (resultado is String && resultado.isNotEmpty) {
      setState(() {
        metodoPagoSeleccionado = resultado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: cargando ? _buildSkeletonCheckout() : _buildCheckout(),
      ),
    );
  }

  // ============================================================
  // 33 - SKELETON CHECKOUT
  // ============================================================

  Widget _buildSkeletonCheckout() {
    return Column(
      children: [
        _buildHeader(),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _skeletonOptionRow(),
                _divider(),

                _skeletonOptionRow(),
                _divider(),

                _skeletonOptionRow(),
                _divider(),

                _skeletonPromo(),
                _divider(),

                const SizedBox(height: 12),

                _buildTableHeader(),

                const SizedBox(height: 10),

                _skeletonProduct(),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      _skeletonTotalRow(leftWidth: 82, rightWidth: 55),
                      const SizedBox(height: 10),
                      _skeletonTotalRow(leftWidth: 65, rightWidth: 45),
                      const SizedBox(height: 10),
                      _skeletonTotalRow(leftWidth: 105, rightWidth: 48),
                      const SizedBox(height: 10),
                      _skeletonTotalRow(leftWidth: 45, rightWidth: 60),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: _skeletonBox(
                    height: 48,
                    width: double.infinity,
                    radius: 7,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _skeletonOptionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          _skeletonBox(width: 48, height: 10),

          const SizedBox(width: 28),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonBox(width: 155, height: 13),
                const SizedBox(height: 6),
                _skeletonBox(width: 65, height: 9),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, size: 20, color: Color(0xFFD0D0D0)),
        ],
      ),
    );
  }

  Widget _skeletonPromo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          _skeletonBox(width: 72, height: 10),

          const SizedBox(width: 20),

          Expanded(
            child: _skeletonBox(height: 34, width: double.infinity, radius: 7),
          ),
        ],
      ),
    );
  }

  Widget _skeletonProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(width: 76, height: 76, radius: 7),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonBox(width: 145, height: 12),
                const SizedBox(height: 8),
                _skeletonBox(width: 105, height: 11),
                const SizedBox(height: 7),
                _skeletonBox(width: 125, height: 11),
                const SizedBox(height: 7),
                _skeletonBox(width: 70, height: 11),
              ],
            ),
          ),

          const SizedBox(width: 10),

          _skeletonBox(width: 48, height: 12),
        ],
      ),
    );
  }

  Widget _skeletonTotalRow({
    required double leftWidth,
    required double rightWidth,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _skeletonBox(width: leftWidth, height: 10),
        _skeletonBox(width: rightWidth, height: 10),
      ],
    );
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    double radius = 3,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // ============================================================
  // 34 - CHECKOUT
  // ============================================================

  Widget _buildCheckout() {
    return Column(
      children: [
        _buildHeader(),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ENVÍO
                _checkoutOption(
                  title: 'ENVÍO',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 19,
                        color: Color(0xFF303030),
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          direccionSeleccionada,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: abrirBuscadorDireccion,
                ),

                _divider(),

                // ENTREGA
                _checkoutOption(
                  title: 'ENTREGA',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${_formatPrice(deliveryCost)}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF303030),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '25–30 minutos',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                  showArrow: false,
                  onTap: () {
                    mostrarMensaje('Entrega estimada: 25–30 minutos.');
                  },
                ),

                _divider(),

                // PAGO
                _checkoutOption(
                  title: 'PAGO',
                  child: Text(
                    metodoPagoSeleccionado,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF303030),
                    ),
                  ),
                  onTap: abrirMetodosPago,
                ),

                _divider(),

                // PROMOCIONES
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 82,
                        child: Text(
                          'PROMOCIONES',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF303030),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: TextField(
                            controller: promoController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              aplicarPromocion();
                            },
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Aplicar código de promoción',
                              hintStyle: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFA5A5A5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBDBDBD),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 7),

                      SizedBox(
                        height: 36,
                        child: FilledButton(
                          onPressed: aplicarPromocion,
                          style: FilledButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'Aplicar',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                _divider(),

                const SizedBox(height: 13),

                _buildTableHeader(),

                const SizedBox(height: 11),

                // ====================================================
                // PRODUCTOS REALES DEL CARRITO
                // ====================================================
                ...CartState.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      bottom: 16,
                    ),
                    child: _buildCheckoutProduct(
                      restaurant: item['restaurant'] ?? 'FoodPlease',
                      name: item['name'] ?? 'Producto',
                      description: item['description'] ?? '',
                      image: item['image'] ?? '',
                      quantity: item['quantity'] ?? 1,
                      total: item['total'] ?? 0,
                    ),
                  ),
                ),

                // ====================================================
                // OFERTAS AGREGADAS AL CARRITO
                // ====================================================
                ...CartState.offerQuantities.entries
                    .where((entry) => entry.value > 0)
                    .map((entry) {
                      final offer = _offerData(entry.key);

                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          bottom: 16,
                        ),
                        child: _buildCheckoutProduct(
                          restaurant: 'FoodPlease',
                          name: entry.key,
                          description: offer['description'] as String,
                          image: offer['image'] as String,
                          quantity: entry.value,
                          total: (offer['price'] as int) * entry.value,
                        ),
                      );
                    }),

                const SizedBox(height: 40),

                // ====================================================
                // TOTALES REALES
                // ====================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      _TotalRow(
                        title: 'Subtotal ($cartQuantity)',
                        value: '\$${_formatPrice(cartSubtotal)}',
                      ),

                      const SizedBox(height: 9),

                      _TotalRow(
                        title: 'Total de envío',
                        value: '\$${_formatPrice(deliveryCost)}',
                      ),

                      const SizedBox(height: 9),

                      _TotalRow(
                        title: 'Tarifa por servicio',
                        value: '\$${_formatPrice(serviceFee)}',
                      ),

                      const SizedBox(height: 9),

                      _TotalRow(
                        title: 'Total',
                        value: '\$${_formatPrice(orderTotal)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.orderSummary);
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
                        'Hacer pedido',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCTO DEL CHECKOUT
  // ============================================================

  Widget _buildCheckoutProduct({
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

        const SizedBox(width: 16),

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

        const SizedBox(width: 10),

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
      child: const Icon(Icons.lunch_dining, size: 40, color: Color(0xFF8E8E8E)),
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
  // COMPONENTES GENERALES
  // ============================================================

  Widget _buildHeader() {
    return SizedBox(
      height: 57,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Terminar y pagar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202020),
              ),
            ),
          ),

          Positioned(
            left: 12,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xFF252525),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkoutOption({
    required String title,
    required Widget child,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 82,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF303030),
                ),
              ),
            ),

            Expanded(child: child),

            if (showArrow) ...[
              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF9D9D9D),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(
              'ARTÍCULOS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF303030),
              ),
            ),
          ),

          Expanded(
            child: Text(
              'DESCRIPCIÓN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF303030),
              ),
            ),
          ),

          Text(
            'PRECIO',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF303030),
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

class _TotalRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _TotalRow({
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
            fontSize: 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xFF303030),
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xFF303030),
          ),
        ),
      ],
    );
  }
}
