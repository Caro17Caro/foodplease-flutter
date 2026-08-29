import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

enum GoogleLoginView {
  accountSelector,
  manualLogin,
  selectedAccount,
  authorization,
}

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // Al entrar desde FoodPlease mostramos primero
  // las cuentas Google guardadas.
  GoogleLoginView currentView = GoogleLoginView.accountSelector;

  bool obscurePassword = true;
  bool loginIncorrecto = false;

  String selectedAccountName = '';
  String selectedAccountEmail = '';

  // Contraseña simulada para el prototipo.
  static const String passwordPrueba = '123456';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void limpiarError() {
    if (loginIncorrecto) {
      setState(() {
        loginIncorrecto = false;
      });
    }
  }

  // ------------------------------------------------------------
  // Seleccionar una cuenta guardada
  // ------------------------------------------------------------

  void seleccionarCuenta(
    String nombre,
    String correo,
  ) {
    setState(() {
      selectedAccountName = nombre;
      selectedAccountEmail = correo;

      emailController.text = correo;
      passwordController.clear();

      loginIncorrecto = false;
      currentView = GoogleLoginView.selectedAccount;
    });
  }

  // ------------------------------------------------------------
  // Usar otra cuenta
  // ------------------------------------------------------------

  void usarOtraCuenta() {
    setState(() {
      selectedAccountName = '';
      selectedAccountEmail = '';

      emailController.clear();
      passwordController.clear();

      loginIncorrecto = false;
      obscurePassword = true;

      currentView = GoogleLoginView.manualLogin;
    });
  }

  // ------------------------------------------------------------
  // Inicio de sesión Google simulado
  // ------------------------------------------------------------

  void iniciarSesionGoogle() {
    FocusScope.of(context).unfocus();

    final String email = emailController.text.trim().toLowerCase();
    final String password = passwordController.text;

    // Debe existir correo y contraseña.
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        loginIncorrecto = true;
      });
      return;
    }

    // Para este prototipo simulamos únicamente cuentas Gmail.
    if (!email.endsWith('@gmail.com')) {
      setState(() {
        loginIncorrecto = true;
      });
      return;
    }

    // Contraseña simulada correcta.
    if (password == passwordPrueba) {
      setState(() {
        loginIncorrecto = false;

        selectedAccountEmail = email;

        if (selectedAccountName.isEmpty) {
          selectedAccountName = 'Usuario Google';
        }

        currentView = GoogleLoginView.authorization;
      });
    } else {
      setState(() {
        loginIncorrecto = true;
      });
    }
  }

  // ------------------------------------------------------------
  // Navegación hacia atrás
  // ------------------------------------------------------------

  void volver() {
    switch (currentView) {
      case GoogleLoginView.accountSelector:
        Navigator.pop(context);
        break;

      case GoogleLoginView.manualLogin:
        setState(() {
          loginIncorrecto = false;
          emailController.clear();
          passwordController.clear();
          currentView = GoogleLoginView.accountSelector;
        });
        break;

      case GoogleLoginView.selectedAccount:
        setState(() {
          loginIncorrecto = false;
          passwordController.clear();
          currentView = GoogleLoginView.accountSelector;
        });
        break;

      case GoogleLoginView.authorization:
        setState(() {
          loginIncorrecto = false;
          passwordController.clear();
          currentView = GoogleLoginView.selectedAccount;
        });
        break;
    }
  }

  // ------------------------------------------------------------
  // Logo Google simulado
  // ------------------------------------------------------------

  Widget googleLogo({
    double size = 42,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFF4285F4),
            Color(0xFFEA4335),
            Color(0xFFFBBC05),
            Color(0xFF34A853),
            Color(0xFF4285F4),
          ],
        ).createShader(bounds);
      },
      child: Text(
        'G',
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget backButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: volver,
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 22,
          color: Color(0xFF252525),
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFFD8D8D8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFF1A73E8),
          width: 1.3,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (currentView) {
      case GoogleLoginView.accountSelector:
        return buildAccountSelector();

      case GoogleLoginView.manualLogin:
        return buildGoogleLoginForm(
          correoEditable: true,
        );

      case GoogleLoginView.selectedAccount:
        return buildGoogleLoginForm(
          correoEditable: false,
        );

      case GoogleLoginView.authorization:
        return buildAuthorization();
    }
  }

  // ============================================================
  // 07 - SELECCIONAR CUENTA
  // ============================================================

  Widget buildAccountSelector() {
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

              backButton(),

              const SizedBox(height: 30),

              Center(
                child: googleLogo(
                  size: 43,
                ),
              ),

              const SizedBox(height: 34),

              const Text(
                'Iniciar sesión con Google',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Selecciona una cuenta para continuar a\nFoodPlease',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 35),

              accountOption(
                name: 'Usuario Usuario',
                email: 'cuentapersonal@gmail.com',
              ),

              const Divider(
                height: 1,
                color: Color(0xFFE5E5E5),
              ),

              accountOption(
                name: 'Cuenta Empresa',
                email: 'cuentaempresa@gmail.com',
              ),

              const Divider(
                height: 1,
                color: Color(0xFFE5E5E5),
              ),

              // Usar otra cuenta
              InkWell(
                onTap: usarOtraCuenta,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 22,
                        color: Color(0xFF252525),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Usar otra cuenta',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A73E8),
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

  Widget accountOption({
    required String name,
    required String email,
  }) {
    return InkWell(
      onTap: () {
        seleccionarCuenta(
          name,
          email,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 17,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.account_circle,
              size: 22,
              color: Color(0xFF252525),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF555555),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 06 - USAR OTRA CUENTA
  // 08 - CUENTA SELECCIONADA
  // 10 - ERROR GOOGLE
  // ============================================================

  Widget buildGoogleLoginForm({
    required bool correoEditable,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 6),

                backButton(),

                const SizedBox(height: 55),

                Center(
                  child: googleLogo(
                    size: 43,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Iniciar sesión con Google',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF303030),
                  ),
                ),

                const SizedBox(height: 23),

                const Text(
                  'Ingresa tu cuenta para continuar a FoodPlease',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF303030),
                  ),
                ),

                const SizedBox(height: 35),

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
                    enabled: correoEditable,
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
                    decoration: inputDecoration(
                      hint: 'correoelectrónico@gmail.com',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

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
                      iniciarSesionGoogle();
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF303030),
                    ),
                    decoration: inputDecoration(
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

                // Pantalla 10 - Error Google
                AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  child: loginIncorrecto
                      ? const Padding(
                          key: ValueKey('google-error'),
                          padding: EdgeInsets.only(
                            top: 9,
                            bottom: 3,
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                          key: ValueKey(
                            'no-google-error',
                          ),
                          height: 14,
                        ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 46,
                  child: FilledButton(
                    onPressed: iniciarSesionGoogle,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF1A73E8,
                      ),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión con Google',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPassword,
                      );
                    },
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 09 - AUTORIZACIÓN GOOGLE
  // ============================================================

  Widget buildAuthorization() {
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

              backButton(),

              const SizedBox(height: 30),

              Center(
                child: googleLogo(
                  size: 43,
                ),
              ),

              const SizedBox(height: 34),

              const Text(
                'Continuar a FoodPlease',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 35),

              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'FoodPlease ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          'solicita acceso a la siguiente\ninformación de tu cuenta de Google:',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF303030),
                ),
              ),

              const SizedBox(height: 35),

              permissionRow(
                Icons.account_circle_outlined,
                'Nombre y apellido',
              ),

              const SizedBox(height: 27),

              permissionRow(
                Icons.mail_outline,
                'Dirección de correo electrónico',
              ),

              const SizedBox(height: 27),

              permissionRow(
                Icons.image_outlined,
                'Foto de perfil',
              ),

              const SizedBox(height: 34),

              SizedBox(
                height: 46,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.home,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF1A73E8,
                    ),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7),
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

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A73E8),
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

  Widget permissionRow(
    IconData icon,
    String texto,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: const Color(0xFF303030),
        ),

        const SizedBox(width: 10),

        Text(
          texto,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF777777),
          ),
        ),
      ],
    );
  }
}