import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  bool obscurePassword = true;
  bool loginIncorrecto = false;

  // Credenciales simuladas para probar el prototipo.
  static const String correoPrueba = 'usuario@prueba.com';
  static const String passwordPrueba = '123456';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void iniciarSesion() {
    FocusScope.of(context).unfocus();

    final String email = emailController.text.trim();
    final String password = passwordController.text;

    // Si falta algún dato, se muestra el mismo estado de error
    // definido para el prototipo.
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        loginIncorrecto = true;
      });
      return;
    }

    // Inicio de sesión simulado.
    if (email == correoPrueba && password == passwordPrueba) {
      setState(() {
        loginIncorrecto = false;
      });

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
    } else {
      setState(() {
        loginIncorrecto = true;
      });
    }
  }

  void limpiarError() {
    if (loginIncorrecto) {
      setState(() {
        loginIncorrecto = false;
      });
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 22),

                    // Título
                    const Text(
                      '¡Bienvenido!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF252525),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/images/logo_foodplease.png',
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 47),

                    // Correo
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
                        focusNode: emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        stylusHandwritingEnabled: false,
                        onChanged: (_) => limpiarError(),
                        onSubmitted: (_) {
                          passwordFocusNode.requestFocus();
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

                    const SizedBox(height: 15),

                    // Contraseña
                    const Text(
                      'Contraseña',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF303030),
                      ),
                    ),

                    const SizedBox(height: 6),

                    SizedBox(
                      height: 48,
                      child: TextField(
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              obscureText: obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              stylusHandwritingEnabled: false,
                              onChanged: (_) => limpiarError(),
                              onSubmitted: (_) {
                                iniciarSesion();
                              },
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF303030),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ingresa tu contraseña',
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
                          suffixIcon: IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: const Color(0xFFD0D0D0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Mensaje pantalla 02
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: loginIncorrecto
                          ? Padding(
                              key: const ValueKey('login-error'),
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 2,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    size: 17,
                                    color: Color(0xFFFF4D4D),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Correo o contraseña incorrectos. Intenta nuevamente',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFFFF4D4D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(
                              key: ValueKey('no-login-error'),
                              height: 10,
                            ),
                    ),

                    const SizedBox(height: 8),

                    // Iniciar sesión
                    SizedBox(
                      height: 46,
                      child: FilledButton(
                        onPressed: iniciarSesion,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF29ABE2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Recuperar contraseña
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPassword,
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                        ),
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF74C8E9),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Separador
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE5E5E5),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'o',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE5E5E5),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Google
                    SizedBox(
                      height: 45,
                      child: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'El inicio con Google se implementará en el siguiente flujo.',
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F3F3),
                          foregroundColor: const Color(0xFF303030),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'G',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4285F4),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Continuar con Google',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Crear cuenta
                    SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'La creación de cuenta se implementará en el siguiente flujo.',
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF29ABE2),
                          side: const BorderSide(
                            color: Color(0xFF29ABE2),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Crear cuenta',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    const Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                        bottom: 20,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: 'Al hacer clic en continuar, aceptas nuestros ',
                          children: [
                            TextSpan(
                              text: 'Términos de servicio',
                              style: TextStyle(
                                color: Color(0xFF444444),
                              ),
                            ),
                            TextSpan(
                              text: ' y\n',
                            ),
                            TextSpan(
                              text: 'Política de privacidad',
                              style: TextStyle(
                                color: Color(0xFF444444),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          height: 1.5,
                          color: Color(0xFF969696),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}