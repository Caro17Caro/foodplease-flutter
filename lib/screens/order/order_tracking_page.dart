import 'package:flutter/material.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() =>
      _OrderTrackingPageState();
}

class _OrderTrackingPageState
    extends State<OrderTrackingPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  bool sinConexion = false;
  bool argumentosLeidos = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!argumentosLeidos) {
      argumentosLeidos = true;

      final arguments =
          ModalRoute.of(context)?.settings.arguments;

      sinConexion = arguments == 'offline';
    }
  }

  void intentarNuevamente() {
    setState(() {
      sinConexion = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (sinConexion) {
      return _buildOffline();
    }

    return _buildTracking();
  }

  // ============================================================
  // 45 - SEGUIMIENTO DEL PEDIDO
  // ============================================================

  Widget _buildTracking() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

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
                    // ==========================================
                    // MAPA SIMULADO
                    // ==========================================

                    Container(
                      height: 230,
                      margin: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F5),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 22,
                            right: 22,
                            top: 68,
                            child: Container(
                              height: 2,
                              color: const Color(
                                0xFFD7DADD,
                              ),
                            ),
                          ),

                          Positioned(
                            left: 85,
                            top: 20,
                            bottom: 20,
                            child: Container(
                              width: 2,
                              color: const Color(
                                0xFFD7DADD,
                              ),
                            ),
                          ),

                          Positioned(
                            right: 75,
                            top: 20,
                            bottom: 20,
                            child: Container(
                              width: 2,
                              color: const Color(
                                0xFFD7DADD,
                              ),
                            ),
                          ),

                          Positioned(
                            left: 85,
                            top: 111,
                            child: Container(
                              width: 150,
                              height: 4,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                          ),

                          const Positioned(
                            left: 68,
                            top: 95,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  Colors.white,
                              child: Icon(
                                Icons.restaurant,
                                size: 19,
                                color:
                                    Color(0xFF303030),
                              ),
                            ),
                          ),

                          const Positioned(
                            right: 57,
                            top: 95,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  primaryColor,
                              child: Icon(
                                Icons.delivery_dining,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const Positioned(
                            right: 22,
                            bottom: 20,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  Colors.white,
                              child: Icon(
                                Icons.home_outlined,
                                size: 21,
                                color:
                                    Color(0xFF303030),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child: Text(
                        'Tu pedido está en camino',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child: Text(
                        'Llegará aproximadamente en 25–30 minutos',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Divider(
                      height: 1,
                      color: Color(0xFFEAEAEA),
                    ),

                    const Padding(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        18,
                        18,
                        12,
                      ),
                      child: Text(
                        'Estado del pedido',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                      ),
                      child: Column(
                        children: [
                          _TrackingStep(
                            title: 'Pedido confirmado',
                            subtitle:
                                'El restaurante recibió tu pedido',
                            completed: true,
                          ),

                          _TrackingStep(
                            title: 'Preparando tu pedido',
                            subtitle:
                                'El restaurante está preparando tu comida',
                            completed: true,
                          ),

                          _TrackingStep(
                            title: 'Pedido en camino',
                            subtitle:
                                'El repartidor se dirige a tu dirección',
                            completed: true,
                            current: true,
                          ),

                          _TrackingStep(
                            title: 'Entregado',
                            subtitle:
                                'Tu pedido llegará pronto',
                            completed: false,
                            showLine: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            size: 28,
                            color: primaryColor,
                          ),

                          SizedBox(width: 13),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Repartidor en camino',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Color(0xFF303030),
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  'Tu pedido está siendo trasladado hasta tu dirección.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    height: 1.4,
                                    color:
                                        Color(0xFF777777),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
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
  // 46 - SEGUIMIENTO SIN CONEXIÓN
  // ============================================================

  Widget _buildOffline() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEAEAEA),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF2F2F2),
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        size: 46,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Sin conexión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF303030),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'No pudimos actualizar el seguimiento de tu pedido.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Revisa tu conexión a internet e intenta nuevamente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: Color(0xFF999999),
                      ),
                    ),

                    const SizedBox(height: 36),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Último estado disponible',
                            style: TextStyle(
                              fontSize: 10.5,
                              color:
                                  Color(0xFF888888),
                            ),
                          ),

                          SizedBox(height: 7),

                          Text(
                            'Pedido en camino',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  Color(0xFF303030),
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'La información puede no estar actualizada.',
                            style: TextStyle(
                              fontSize: 10.5,
                              color:
                                  Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: intentarNuevamente,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              primaryColor,
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              7,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Intentar nuevamente',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
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
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xFF252525),
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Seguimiento',
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
}

// ============================================================
// PASOS DE SEGUIMIENTO
// ============================================================

class _TrackingStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool current;
  final bool showLine;

  const _TrackingStep({
    required this.title,
    required this.subtitle,
    required this.completed,
    this.current = false,
    this.showLine = true,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor =
        Color(0xFF29ABE2);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completed
                        ? primaryColor
                        : Colors.white,
                    border: Border.all(
                      color: completed
                          ? primaryColor
                          : const Color(
                              0xFFC9C9C9,
                            ),
                      width: 2,
                    ),
                  ),
                  child: completed
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),

                if (showLine)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: completed
                          ? primaryColor
                          : const Color(
                              0xFFE0E0E0,
                            ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 22,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: current
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color:
                                const Color(
                              0xFF303030,
                            ),
                          ),
                        ),
                      ),

                      if (current)
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFE7F6FC,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Text(
                            'Actual',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.4,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
