import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';

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
  bool iniciandoSesion = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> iniciarSesion() async {
    FocusScope.of(context).unfocus();

    final String email = emailController.text.trim().toLowerCase();
    final String password = passwordController.text;

    setState(() {
      loginIncorrecto = false;
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        loginIncorrecto = true;
      });
      return;
    }

    setState(() {
      iniciandoSesion = true;
    });

    try {
      final response = await ApiService.login(email: email, password: password);

      if (!mounted) return;

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        setState(() {
          loginIncorrecto = false;
        });

        Navigator.pushReplacementNamed(context, AppRoutes.home);

        return;
      }

      if (statusCode == 401 || statusCode == 400) {
        setState(() {
          loginIncorrecto = true;
        });
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible iniciar sesión.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible conectar con el servidor.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          iniciandoSesion = false;
        });
      }
    }
  }

  void limpiarError() {
    if (loginIncorrecto) {
      setState(() {
        loginIncorrecto = false;
      });
    }
  }

  void mostrarInformacionLegal(String titulo, String contenido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Text(
              contenido,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Color(0xFF29ABE2)),
              ),
            ),
          ],
        );
      },
    );
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
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 22),

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

                    Center(
                      child: Image.asset(
                        'assets/images/logo_foodplease.png',
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 47),

                    const Text(
                      'Correo electrónico',
                      style: TextStyle(fontSize: 14, color: Color(0xFF303030)),
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

                    const Text(
                      'Contraseña',
                      style: TextStyle(fontSize: 14, color: Color(0xFF303030)),
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
                          if (!iniciandoSesion) {
                            iniciarSesion();
                          }
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

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: loginIncorrecto
                          ? const Padding(
                              key: ValueKey('login-error'),
                              padding: EdgeInsets.only(top: 8, bottom: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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

                    SizedBox(
                      height: 46,
                      child: FilledButton(
                        onPressed: iniciandoSesion ? null : iniciarSesion,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF29ABE2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: iniciandoSesion
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Iniciar sesión',
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

                    SizedBox(
                      height: 45,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.googleLogin);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F3F3),
                          foregroundColor: const Color(0xFF303030),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

                    SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.register);
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
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: Column(
                        children: [
                          const Text(
                            'Al hacer clic en continuar, aceptas nuestros',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              height: 1.5,
                              color: Color(0xFF969696),
                            ),
                          ),

                          const SizedBox(height: 2),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  mostrarInformacionLegal(
                                    'Términos de servicio',
                                    'FoodPlease es un prototipo académico '
                                        'desarrollado para representar el '
                                        'funcionamiento de una aplicación móvil '
                                        'de pedidos de comida. El uso de esta '
                                        'aplicación está destinado únicamente '
                                        'a fines educativos y demostrativos.',
                                  );
                                },
                                child: const Text(
                                  'Términos de servicio',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF29ABE2),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),

                              const Text(
                                ' y ',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF969696),
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  mostrarInformacionLegal(
                                    'Política de privacidad',
                                    'FoodPlease utiliza la información '
                                        'ingresada para representar funciones '
                                        'como inicio de sesión, pedidos, '
                                        'direcciones y métodos de pago dentro '
                                        'del prototipo académico.',
                                  );
                                },
                                child: const Text(
                                  'Política de privacidad',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF29ABE2),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
