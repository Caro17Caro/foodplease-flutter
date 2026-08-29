import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

enum VerifyEmailView {
  checkEmail,
  verified,
  verificationError,
}

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  VerifyEmailView currentView = VerifyEmailView.checkEmail;

  String email = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (email.isEmpty) {
      final Object? arguments =
          ModalRoute.of(context)?.settings.arguments;

      if (arguments is String) {
        email = arguments;
      } else {
        email = 'usuario@prueba.com';
      }
    }
  }

  void verificarCorreo() {
    // Correo especial para probar pantalla 16.
    if (email.toLowerCase() == 'error@prueba.com') {
      setState(() {
        currentView = VerifyEmailView.verificationError;
      });
    } else {
      setState(() {
        currentView = VerifyEmailView.verified;
      });
    }
  }

  void reenviarEnlace() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Se reenvió el enlace de verificación a $email.',
        ),
      ),
    );
  }

  void volverLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (currentView) {
      case VerifyEmailView.checkEmail:
        return buildCheckEmail();

      case VerifyEmailView.verified:
        return buildVerified();

      case VerifyEmailView.verificationError:
        return buildVerificationError();
    }
  }

  // ============================================================
  // 14 - CUENTA CREADA / REVISAR CORREO
  // ============================================================

  Widget buildCheckEmail() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
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

              const SizedBox(height: 25),

              Center(
                child: Image.asset(
                  'assets/images/logo_foodplease.png',
                  width: 135,
                  height: 135,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 27),

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
                size: 53,
                color: Color(0xFF29ABE2),
              ),

              const SizedBox(height: 26),

              const Text(
                'Te enviamos un enlace para verificar tu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'correo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 26),

              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF252525),
                ),
              ),

              const SizedBox(height: 29),

              SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: verificarCorreo,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF29ABE2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Verificar correo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 7),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No recibiste el correo? ',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF303030),
                    ),
                  ),
                  TextButton(
                    onPressed: reenviarEnlace,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
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

  // ============================================================
  // 15 - CORREO VERIFICADO
  // ============================================================

  Widget buildVerified() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: volverLogin,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 22,
                    color: Color(0xFF252525),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Image.asset(
                  'assets/images/logo_foodplease.png',
                  width: 135,
                  height: 135,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                '¡Cuenta verificada!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2A2A2A),
                ),
              ),

              const SizedBox(height: 13),

              const Icon(
                Icons.check_circle_outline_rounded,
                size: 62,
                color: Color(0xFF4CAF50),
              ),

              const SizedBox(height: 28),

              const Text(
                'Tu correo fue verificado correctamente.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Ya puedes comenzar a usar FoodPlease',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: volverLogin,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF29ABE2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

  // ============================================================
  // 16 - ERROR DE VERIFICACIÓN
  // ============================================================

  Widget buildVerificationError() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: volverLogin,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 22,
                    color: Color(0xFF252525),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Image.asset(
                  'assets/images/logo_foodplease.png',
                  width: 135,
                  height: 135,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'No pudimos verificar tu correo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2A2A2A),
                ),
              ),

              const SizedBox(height: 18),

              const Icon(
                Icons.warning_amber_rounded,
                size: 62,
                color: Color(0xFFFF4D4D),
              ),

              const SizedBox(height: 28),

              const Text(
                'El enlace de verificación no es válido o',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'ha expirado.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      currentView = VerifyEmailView.checkEmail;
                    });

                    reenviarEnlace();
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
                    'Reenviar enlace',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Center(
                child: TextButton(
                  onPressed: volverLogin,
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
    );
  }
}