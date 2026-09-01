import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../state/cart_state.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  final List<Map<String, dynamic>> addresses = [
    {
      'title': 'Casa',
      'address': 'Pasaje Matucana 8853, La Reina',
      'icon': Icons.home_outlined,
    },
    {
      'title': 'Trabajo',
      'address': 'Av. Beaucheff 1425, Santiago',
      'icon': Icons.work_outline,
    },
  ];

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

  Future<void> _showAddressDialog({int? index}) async {
    final bool isEditing = index != null;

    String title = isEditing ? addresses[index]['title'] as String : '';

    String address = isEditing ? addresses[index]['address'] as String : '';

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            isEditing ? 'Editar dirección' : 'Agregar nueva dirección',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: title,
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej: Casa, Trabajo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: primaryBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: address,
                onChanged: (value) {
                  address = value;
                },
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Ingresa la dirección',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: primaryBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                final cleanTitle = title.trim();
                final cleanAddress = address.trim();

                if (cleanTitle.isEmpty || cleanAddress.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos.')),
                  );
                  return;
                }

                Navigator.pop(dialogContext, {
                  'title': cleanTitle,
                  'address': cleanAddress,
                });
              },
              child: Text(
                isEditing ? 'Guardar' : 'Agregar',
                style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (isEditing) {
        addresses[index] = {
          'title': result['title'],
          'address': result['address'],
          'icon': addresses[index]['icon'],
        };
      } else {
        addresses.add({
          'title': result['title'],
          'address': result['address'],
          'icon': Icons.location_on_outlined,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? 'Dirección actualizada correctamente.'
              : 'Dirección agregada correctamente.',
        ),
      ),
    );
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

            ...List.generate(addresses.length, (index) {
              final item = addresses[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == addresses.length - 1 ? 0 : 12,
                ),
                child: _buildAddress(
                  icon: item['icon'],
                  title: item['title'],
                  address: item['address'],
                  onEdit: () {
                    _showAddressDialog(index: index);
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: () {
                _showAddressDialog();
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
    required IconData icon,
    required String title,
    required String address,
    required VoidCallback onEdit,
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
            onTap: onEdit,
            borderRadius: BorderRadius.circular(8),
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
      onTap: (index) async {
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
              const SnackBar(content: Text('No tienes notificaciones nuevas.')),
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
