import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../routes/app_routes.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  final TextEditingController cardController =
      TextEditingController();

  final TextEditingController expirationController =
      TextEditingController();

  final TextEditingController cvvController =
      TextEditingController();

  final TextEditingController nicknameController =
      TextEditingController();

  final FocusNode cardFocusNode = FocusNode();
  final FocusNode expirationFocusNode = FocusNode();
  final FocusNode cvvFocusNode = FocusNode();
  final FocusNode nicknameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    cardController.addListener(_actualizarFormulario);
    expirationController.addListener(_actualizarFormulario);
    cvvController.addListener(_actualizarFormulario);
    nicknameController.addListener(_actualizarFormulario);
  }

  @override
  void dispose() {
    cardController.removeListener(_actualizarFormulario);
    expirationController.removeListener(_actualizarFormulario);
    cvvController.removeListener(_actualizarFormulario);
    nicknameController.removeListener(_actualizarFormulario);

    cardController.dispose();
    expirationController.dispose();
    cvvController.dispose();
    nicknameController.dispose();

    cardFocusNode.dispose();
    expirationFocusNode.dispose();
    cvvFocusNode.dispose();
    nicknameFocusNode.dispose();

    super.dispose();
  }

  void _actualizarFormulario() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get numeroTarjetaValido {
    final numero =
        cardController.text.replaceAll(' ', '');

    return numero.length == 16;
  }

  bool get fechaValida {
    final fecha = expirationController.text.trim();

    return RegExp(
      r'^(0[1-9]|1[0-2])\/\d{2}$',
    ).hasMatch(fecha);
  }

  bool get cvvValido {
    final cvv = cvvController.text.trim();

    return cvv.length == 3 || cvv.length == 4;
  }

  bool get sobrenombreValido {
    return nicknameController.text.trim().isNotEmpty;
  }

  bool get formularioCompleto {
    return numeroTarjetaValido &&
        fechaValida &&
        cvvValido &&
        sobrenombreValido;
  }

  Future<void> siguiente() async {
    FocusScope.of(context).unfocus();

    if (!formularioCompleto) {
      return;
    }

    final numeroTarjeta =
        cardController.text.replaceAll(' ', '');

    /*
      SIMULACIÓN:

      Tarjeta terminada en 0000 → error.
      Cualquier otra tarjeta de 16 dígitos → éxito.
    */
    final bool simularError =
        numeroTarjeta.endsWith('0000');

    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.cardResult,
      arguments: simularError
          ? 'error'
          : 'success',
    );

    if (!mounted) {
      return;
    }

    // Pantalla 39
    if (resultado == 'success') {
      final ultimosCuatro =
          numeroTarjeta.substring(
        numeroTarjeta.length - 4,
      );

      Navigator.pop(
        context,
        'Visa •••• $ultimosCuatro',
      );

      return;
    }

    // Pantalla 40 → Intentar nuevamente
    if (resultado == 'retry') {
      return;
    }

    // Pantalla 40 → volver a métodos de pago
    if (resultado == 'backToMethods') {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Número de tarjeta',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF303030),
                        ),
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 44,
                        child: TextField(
                          controller: cardController,
                          focusNode: cardFocusNode,
                          keyboardType:
                              TextInputType.number,
                          textInputAction:
                              TextInputAction.next,
                          onSubmitted: (_) {
                            expirationFocusNode
                                .requestFocus();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                            CardNumberFormatter(),
                          ],
                          decoration: _inputDecoration(
                            hint: '1234 5678 9012 1234',
                            prefixIcon: const Icon(
                              Icons.credit_card,
                              size: 19,
                              color: Color(0xFF34515E),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fecha de Vencimiento',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF303030),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                SizedBox(
                                  height: 44,
                                  child: TextField(
                                    controller:
                                        expirationController,
                                    focusNode:
                                        expirationFocusNode,
                                    keyboardType:
                                        TextInputType.number,
                                    textInputAction:
                                        TextInputAction.next,
                                    onSubmitted: (_) {
                                      cvvFocusNode
                                          .requestFocus();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly,
                                      ExpirationDateFormatter(),
                                    ],
                                    decoration:
                                        _inputDecoration(
                                      hint: 'MM/AA',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CVV',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF303030),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                SizedBox(
                                  height: 44,
                                  child: TextField(
                                    controller:
                                        cvvController,
                                    focusNode:
                                        cvvFocusNode,
                                    obscureText: true,
                                    keyboardType:
                                        TextInputType.number,
                                    textInputAction:
                                        TextInputAction.next,
                                    onSubmitted: (_) {
                                      nicknameFocusNode
                                          .requestFocus();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                        4,
                                      ),
                                    ],
                                    decoration:
                                        _inputDecoration(
                                      hint: '123',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Sobrenombre',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF303030),
                        ),
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 44,
                        child: TextField(
                          controller:
                              nicknameController,
                          focusNode:
                              nicknameFocusNode,
                          textInputAction:
                              TextInputAction.done,
                          onSubmitted: (_) {
                            if (formularioCompleto) {
                              siguiente();
                            }
                          },
                          decoration: _inputDecoration(
                            hint: 'Ej.: principal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  12,
                  18,
                  18,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed:
                        formularioCompleto
                            ? siguiente
                            : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFFF2F2F2),
                      disabledForegroundColor:
                          const Color(0xFF909090),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
              icon: const Icon(
                Icons.close,
                size: 22,
                color: Color(0xFF252525),
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Agregar tarjeta',
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

  InputDecoration _inputDecoration({
    required String hint,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFA7A7A7),
      ),
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFF303030),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.3,
        ),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits =
        newValue.text.replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (digits.length > 16) {
      digits = digits.substring(0, 16);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }

      buffer.write(digits[i]);
    }

    final texto = buffer.toString();

    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(
        offset: texto.length,
      ),
    );
  }
}

class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits =
        newValue.text.replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    String texto;

    if (digits.length <= 2) {
      texto = digits;
    } else {
      texto =
          '${digits.substring(0, 2)}/${digits.substring(2)}';
    }

    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(
        offset: texto.length,
      ),
    );
  }
}