import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../state/cart_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  bool initializedFromArguments = false;
  bool guardandoCambios = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initializedFromArguments) {
      return;
    }

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      nameController.text = arguments['name'] ?? 'Usuario Usuario';
      emailController.text = arguments['email'] ?? 'usuario@email.com';
      phoneController.text = arguments['phone'] ?? '+56 9 1234 5678';
    } else {
      nameController.text = 'Usuario Usuario';
      emailController.text = 'usuario@email.com';
      phoneController.text = '+56 9 1234 5678';
    }

    initializedFromArguments = true;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  Future<void> _saveChanges() async {
    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos antes de guardar.'),
        ),
      );

      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo electrónico válido.')),
      );

      return;
    }

    setState(() {
      guardandoCambios = true;
    });

    try {
      final response = await ApiService.updateMe(nombre: name, email: email);

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        final user = response['user'];

        String updatedName = name;
        String updatedEmail = email;

        if (user is Map<String, dynamic>) {
          updatedName = user['nombre'] ?? name;
          updatedEmail = user['email'] ?? email;
        }

        Navigator.pop(context, {
          'name': updatedName,
          'email': updatedEmail,
          'phone': phone,
        });

        return;
      }

      if (statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ??
                  'Ya existe una cuenta asociada a este correo.',
            ),
          ),
        );

        return;
      }

      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La sesión ha expirado. Inicia sesión nuevamente.'),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible actualizar el perfil.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible conectar con el servidor.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          guardandoCambios = false;
        });
      }
    }
  }

  Future<void> _openCart() async {
    if (CartState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega un producto para comenzar un carrito.'),
        ),
      );

      return;
    }

    await Navigator.pushNamed(context, AppRoutes.cart);

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildCartIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart_outlined),
        if (CartState.quantity > 0)
          Positioned(
            right: -8,
            top: -7,
            child: Container(
              constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: primaryBlue,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${CartState.quantity}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: guardandoCambios
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),
        title: const Text(
          'Editar perfil',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFFF1F1F1),
                child: Icon(Icons.person, size: 58, color: Colors.black45),
              ),

              const SizedBox(height: 32),

              _buildField(
                label: 'Nombre completo',
                controller: nameController,
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 18),

              _buildField(
                label: 'Correo electrónico',
                controller: emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              _buildField(
                label: 'Teléfono',
                controller: phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 34),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: guardandoCambios ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: guardandoCambios
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Guardar cambios',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: !guardandoCambios,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black45),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE3E3E3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 4,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.black54,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: guardandoCambios
          ? null
          : (index) async {
              switch (index) {
                case 0:
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                  break;

                case 1:
                  await Navigator.pushNamed(context, AppRoutes.search);

                  if (mounted) {
                    setState(() {});
                  }

                  break;

                case 2:
                  await _openCart();
                  break;

                case 3:
                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No tienes notificaciones nuevas.'),
                    ),
                  );
                  break;

                case 4:
                  Navigator.pop(context);
                  break;
              }
            },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explorar',
        ),
        BottomNavigationBarItem(icon: _buildCartIcon(), label: 'Carrito'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notificaciones',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
