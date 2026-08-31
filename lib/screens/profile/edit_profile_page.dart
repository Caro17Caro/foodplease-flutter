import 'package:flutter/material.dart';

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

  void _saveChanges() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos antes de guardar.'),
        ),
      );

      return;
    }

    Navigator.pop(context, {'name': name, 'email': email, 'phone': phone});
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

              const SizedBox(height: 8),

              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selección de fotografía simulada.'),
                    ),
                  );
                },
                child: const Text(
                  'Cambiar foto',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
