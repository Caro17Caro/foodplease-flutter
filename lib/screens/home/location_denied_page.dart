import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class LocationDeniedPage extends StatelessWidget {
  const LocationDeniedPage({super.key});

  static const Color primaryBlue = Color(0xFF29ABE2);

  Future<void> _enterManualAddress(BuildContext context) async {
    String enteredAddress = '';

    final address = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Ingresar dirección',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            autofocus: true,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              enteredAddress = value;
            },
            decoration: const InputDecoration(
              hintText: 'Ej: Av. Providencia 1234',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
            ),
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
            ElevatedButton(
              onPressed: () {
                final addressValue = enteredAddress.trim();

                if (addressValue.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingresa una dirección válida'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, addressValue);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (address != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dirección seleccionada: $address'),
          duration: const Duration(milliseconds: 700),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 700));

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  void _tryAgain(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 22,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Image.asset(
                'assets/images/logo_foodplease.png',
                height: 90,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 28),

              const Text(
                'No pudimos acceder\na tu ubicación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Color(0xFF202124),
                ),
              ),

              const SizedBox(height: 26),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEF9A9A)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'El permiso de ubicación fue rechazado. Puedes ingresar tu dirección manualmente o intentarlo nuevamente.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Color(0xFFB71C1C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_off,
                  size: 58,
                  color: Colors.black45,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Para continuar, puedes ingresar una dirección manualmente o volver a intentar el acceso a tu ubicación.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    _enterManualAddress(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Ingresar dirección manualmente',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () {
                  _tryAgain(context);
                },
                child: const Text(
                  'Intentar nuevamente',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}
