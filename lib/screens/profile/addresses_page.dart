import 'package:flutter/material.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  static const Color primaryBlue = Color(0xFF29ABE2);

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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mis direcciones',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            const Text(
              'Direcciones guardadas',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18),

            _buildAddress(
              context: context,
              icon: Icons.home_outlined,
              title: 'Casa',
              address: 'Pasaje Matucana 8853, La Reina',
            ),

            const SizedBox(height: 12),

            _buildAddress(
              context: context,
              icon: Icons.work_outline,
              title: 'Trabajo',
              address: 'Av. Beaucheff 1425, Santiago',
            ),

            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agregar nueva dirección.')),
                );
              },
              icon: const Icon(Icons.add, color: primaryBlue),
              label: const Text(
                'Agregar nueva dirección',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildAddress({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String address,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E4E4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: primaryBlue.withValues(alpha: 0.10),
            child: Icon(icon, color: primaryBlue),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Editar dirección: $title')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Row(
                children: [
                  Text(
                    'Editar',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Icon(Icons.chevron_right, color: Colors.black45),
                ],
              ),
            ),
          ),
        ],
      ),
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
