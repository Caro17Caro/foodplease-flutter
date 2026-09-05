import 'package:flutter/material.dart';

class CardResultPage extends StatelessWidget {
  const CardResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? arguments =
        ModalRoute.of(context)?.settings.arguments;

    String status = 'success';
    bool fromProfile = false;

    if (arguments is Map) {
      status = arguments['status']?.toString() ?? 'success';
      fromProfile = arguments['fromProfile'] == true;
    } else if (arguments != null) {
      status = arguments.toString();
    }

    final bool error = status == 'error';

    return error
        ? _buildError(context, fromProfile)
        : _buildSuccess(context, fromProfile);
  }

  Widget _buildSuccess(
    BuildContext context,
    bool fromProfile,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header('Método de pago'),
            const Divider(
              height: 1,
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
                    const Icon(
                      Icons.check_circle_outline,
                      size: 78,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 34),
                    const Text(
                      '¡Tarjeta agregada con éxito!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF303030),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      fromProfile
                          ? 'La tarjeta quedó guardada en tus métodos de pago'
                          : 'Ya puedes continuar con tu pedido',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),
                    const Spacer(flex: 3),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            'success',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF29ABE2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: Text(
                          fromProfile
                              ? 'Volver a métodos de pago'
                              : 'Volver al pago',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    bool fromProfile,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header('Método de pago'),
            const Divider(
              height: 1,
              color: Color(0xFFEAEAEA),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 55),
                    const Text(
                      'No pudimos agregar tu tarjeta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF303030),
                      ),
                    ),
                    const SizedBox(height: 45),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5),
                        border: Border.all(
                          color: const Color(0xFFFF4D4D),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 42,
                            color: Color(0xFFFF4D4D),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Ocurrió un problema mientras intentábamos agregar tu tarjeta',
                              style: TextStyle(
                                fontSize: 11.5,
                                height: 1.4,
                                color: Color(0xFFFF4D4D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    const Text(
                      'Esto puede ocurrir porque los datos ingresados\n'
                      'no son válidos, la tarjeta no pudo ser verificada o\n'
                      'se produjo un problema de conexión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.7,
                        color: Color(0xFF303030),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No se realizó ningún cobro',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF888888),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            'retry',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF29ABE2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Intentar nuevamente',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          'backToMethods',
                        );
                      },
                      child: Text(
                        fromProfile
                            ? 'Volver a métodos de pago'
                            : 'Volver a métodos de pagos',
                        style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF74C8E9),
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

  Widget _header(String title) {
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
