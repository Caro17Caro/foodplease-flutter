import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  static const String correoPrueba = 'usuario@prueba.com';

  bool mostrarError = false;
  bool correoEnviado = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void enviarEnlace() {
    FocusScope.of(context).unfocus();

    final String email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      setState(() {
        mostrarError = true;
      });
      return;
    }

    if (email == correoPrueba) {
      setState(() {
        mostrarError = false;
        correoEnviado = true;
      });
    } else {
      setState(() {
        mostrarError = true;
      });
    }
  }

  void limpiarError() {
    if (mostrarError) {
      setState(() {
        mostrarError = false;
      });
    }
  }

  void reenviarEnlace() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Enlace de recuperación reenviado.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (correoEnviado) {
      return _buildCorreoEnviado();
    }

    return _buildRecuperarContrasena();
  }

  Widget _buildRecuperarContrasena() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 6),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 22,
                      color: Color(0xFF252525),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Center(
                  child: Image.asset(
                    'assets/images/logo_foodplease.png',
                    width: 125,
                    height: 125,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Recuperar contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A2A2A),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Ingresa el correo asociado a tu cuenta.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF303030),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Te enviaremos un enlace para restablecer tu contraseña',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF303030),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 38),

                const Text(
                  'Correo electrónico',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF303030),
                  ),
                ),

                const SizedBox(height: 6),

                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    enableSuggestions: false,
                    stylusHandwritingEnabled: false,
                    onChanged: (_) => limpiarError(),
                    onSubmitted: (_) {
                      enviarEnlace();
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF303030),
                    ),
                    decoration: InputDecoration(
                      hintText: 'correoelectrónico@dominio.com',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB5B5B5),
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                          color: Color(0xFFD8D8D8),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                          color: Color(0xFF29ABE2),
                          width: 1.3,
                        ),
                      ),
                    ),
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: mostrarError
                      ? Padding(
                          key: const ValueKey('email-error'),
                          padding: const EdgeInsets.only(
                            top: 9,
                            bottom: 3,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFFF4D4D),
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'No encontramos una cuenta asociada a este correo.\nRevisa la dirección e intenta nuevamente',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    height: 1.3,
                                    color: Color(0xFFFF4D4D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          key: ValueKey('no-email-error'),
                          height: 14,
                        ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 46,
                  child: FilledButton(
                    onPressed: enviarEnlace,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF29ABE2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Enviar enlace',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Volver a iniciar sesión',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF74C8E9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCorreoEnviado() {
    final String email = emailController.text.trim();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      correoEnviado = false;
                    });
                  },
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 22,
                    color: Color(0xFF252525),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: Image.asset(
                  'assets/images/logo_foodplease.png',
                  width: 125,
                  height: 125,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                '¡Revisa tu correo!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2A2A2A),
                ),
              ),

              const SizedBox(height: 8),

              const Icon(
                Icons.mail_outline_rounded,
                size: 52,
                color: Color(0xFF29ABE2),
              ),

              const SizedBox(height: 25),

              const Text(
                'Te enviamos un enlace para restablecer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'tu contraseña:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF252525),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF29ABE2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Volver a iniciar sesión',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 3),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No recibiste el correo? ',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF333333),
                    ),
                  ),
                  TextButton(
                    onPressed: reenviarEnlace,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Reenviar enlace',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF74C8E9),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}