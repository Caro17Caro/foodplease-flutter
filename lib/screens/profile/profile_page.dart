import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  String userName = 'Usuario Usuario';
  String userEmail = 'usuario@email.com';
  String userPhone = '+56 9 1234 5678';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Mi perfil',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          children: [
            _buildUserInformation(context),

            const SizedBox(height: 28),

            _buildOption(
              icon: Icons.receipt_long_outlined,
              title: 'Mis pedidos',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Mis pedidos estará disponible al integrar el módulo de pedidos.',
                    ),
                  ),
                );
              },
            ),

            _buildDivider(),

            _buildOption(
              icon: Icons.location_on_outlined,
              title: 'Mis direcciones',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addresses);
              },
            ),

            _buildDivider(),

            _buildOption(
              icon: Icons.credit_card_outlined,
              title: 'Métodos de pago',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Métodos de pago disponible próximamente.'),
                  ),
                );
              },
            ),

            _buildDivider(),

            _buildOption(
              icon: Icons.help_outline,
              title: 'Ayuda y soporte',
              onTap: () {
                _showSupportDialog(context);
              },
            ),

            _buildDivider(),

            _buildOption(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildUserInformation(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 34,
          backgroundColor: Color(0xFFF1F1F1),
          child: Icon(Icons.person, size: 42, color: Colors.black45),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                userEmail,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.editProfile,
              arguments: {
                'name': userName,
                'email': userEmail,
                'phone': userPhone,
              },
            );

            if (!context.mounted) {
              return;
            }

            if (result is Map<String, dynamic>) {
              setState(() {
                userName = result['name'] ?? userName;
                userEmail = result['email'] ?? userEmail;
                userPhone = result['phone'] ?? userPhone;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cambios guardados correctamente.'),
                ),
              );
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                Text(
                  'Editar perfil',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(width: 3),
                Icon(Icons.chevron_right, size: 20, color: Colors.black54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Row(
          children: [
            Icon(icon, size: 23, color: Colors.black87),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFEAEAEA));
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ayuda y soporte'),
          content: const Text(
            '¿Necesitas ayuda con FoodPlease? Nuestro equipo de soporte estará disponible para ayudarte.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Entendido',
                style: TextStyle(color: primaryBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 4,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.black54,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        }

        if (index == 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agrega un producto para comenzar un carrito.'),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explorar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrito',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
