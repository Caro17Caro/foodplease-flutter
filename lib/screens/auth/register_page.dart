import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool passwordsNoCoinciden = false;
  bool correoYaExiste = false;
  bool datosIncompletos = false;
  bool registrando = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  void limpiarErrores() {
    if (passwordsNoCoinciden || correoYaExiste || datosIncompletos) {
      setState(() {
        passwordsNoCoinciden = false;
        correoYaExiste = false;
        datosIncompletos = false;
      });
    }
  }

  Future<void> crearCuenta() async {
    FocusScope.of(context).unfocus();

    final String nombre = nameController.text.trim();
    final String correo = emailController.text.trim().toLowerCase();
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    setState(() {
      passwordsNoCoinciden = false;
      correoYaExiste = false;
      datosIncompletos = false;
    });

    if (nombre.isEmpty ||
        correo.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        datosIncompletos = true;
      });
      return;
    }

    if (!correo.contains('@') || !correo.contains('.')) {
      setState(() {
        datosIncompletos = true;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        passwordsNoCoinciden = true;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        datosIncompletos = true;
      });
      return;
    }

    setState(() {
      registrando = true;
    });

    try {
      final response = await ApiService.register(
        nombre: nombre,
        email: correo,
        password: password,
      );

      if (!mounted) return;

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 201) {
        Navigator.pushNamed(context, AppRoutes.verifyEmail, arguments: correo);
        return;
      }

      if (statusCode == 409) {
        setState(() {
          correoYaExiste = true;
        });
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible crear la cuenta.',
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
          registrando = false;
        });
      }
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

  InputDecoration campoDecoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFF29ABE2), width: 1.3),
      ),
      suffixIcon: suffixIcon,
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

                    const SizedBox(height: 5),

                    Center(
                      child: Image.asset(
                        'assets/images/logo_foodplease.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Crear cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2A2A),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Nombre y Apellido',
                      style: TextStyle(fontSize: 14, color: Color(0xFF303030)),
                    ),

                    const SizedBox(height: 6),

                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: nameController,
                        focusNode: nameFocusNode,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => limpiarErrores(),
                        onSubmitted: (_) {
                          emailFocusNode.requestFocus();
                        },
                        decoration: campoDecoration(hint: 'Ej.: Juan Perez'),
                      ),
                    ),

                    const SizedBox(height: 13),

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
                        onChanged: (_) => limpiarErrores(),
                        onSubmitted: (_) {
                          passwordFocusNode.requestFocus();
                        },
                        decoration: campoDecoration(
                          hint: 'correoelectrónico@dominio.com',
                        ),
                      ),
                    ),

                    if (correoYaExiste)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
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
                                'Correo ya tiene cuenta asociada',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFFFF4D4D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 13),

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
                        textInputAction: TextInputAction.next,
                        stylusHandwritingEnabled: false,
                        onChanged: (_) => limpiarErrores(),
                        onSubmitted: (_) {
                          confirmPasswordFocusNode.requestFocus();
                        },
                        decoration: campoDecoration(
                          hint: 'Ingresa tu contraseña',
                          suffixIcon: IconButton(
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

                    const SizedBox(height: 13),

                    const Text(
                      'Confirma contraseña',
                      style: TextStyle(fontSize: 14, color: Color(0xFF303030)),
                    ),

                    const SizedBox(height: 6),

                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        obscureText: obscureConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        stylusHandwritingEnabled: false,
                        onChanged: (_) => limpiarErrores(),
                        onSubmitted: (_) {
                          crearCuenta();
                        },
                        decoration: campoDecoration(
                          hint: 'Confirmar tu contraseña',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: const Color(0xFFD0D0D0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (passwordsNoCoinciden)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
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
                                'Las contraseñas no coinciden',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFFFF4D4D),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (datosIncompletos)
                      const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Text(
                          'Revisa los datos ingresados. Todos los campos son obligatorios y la contraseña debe tener al menos 6 caracteres.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFFFF4D4D),
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 46,
                      child: FilledButton(
                        onPressed: registrando ? null : crearCuenta,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF29ABE2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: registrando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Crear cuenta',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿Ya tienes cuenta? ',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF303030),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Inicia sesión',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF74C8E9),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 20),
                      child: Column(
                        children: [
                          const Text(
                            'Al crear una cuenta, aceptas los',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
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
                                        'de pedidos de comida.',
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
                                    'FoodPlease utiliza información '
                                        'simulada para representar las '
                                        'funciones del prototipo y no almacena '
                                        'información personal real.',
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
