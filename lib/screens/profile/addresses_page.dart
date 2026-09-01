import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../state/cart_state.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  List<Map<String, dynamic>> addresses = [];

  bool cargandoDirecciones = true;
  bool procesandoDireccion = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final response = await ApiService.getAddresses();

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        final data = response['addresses'];

        if (data is List) {
          setState(() {
            addresses = data
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList();

            cargandoDirecciones = false;
          });

          return;
        }
      }

      setState(() {
        addresses = [];
        cargandoDirecciones = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible cargar las direcciones.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        addresses = [];
        cargandoDirecciones = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible conectar con el servidor.'),
        ),
      );
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

  Future<void> _showAddressDialog({Map<String, dynamic>? addressData}) async {
    final bool isEditing = addressData != null;

    String nombre = isEditing ? (addressData['nombre'] ?? '').toString() : '';

    String direccion = isEditing
        ? (addressData['direccion'] ?? '').toString()
        : '';

    String comuna = isEditing ? (addressData['comuna'] ?? '').toString() : '';

    String referencia = isEditing
        ? (addressData['referencia'] ?? '').toString()
        : '';

    bool esPrincipal = isEditing ? addressData['es_principal'] == true : false;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                isEditing ? 'Editar dirección' : 'Agregar nueva dirección',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: nombre,
                      onChanged: (value) {
                        nombre = value;
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
                      initialValue: direccion,
                      onChanged: (value) {
                        direccion = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Ej: Av. Providencia 1234',
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
                      initialValue: comuna,
                      onChanged: (value) {
                        comuna = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Comuna',
                        hintText: 'Ej: Providencia',
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
                      initialValue: referencia,
                      onChanged: (value) {
                        referencia = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Referencia',
                        hintText: 'Ej: Depto. 402, portón azul',
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

                    const SizedBox(height: 10),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: primaryBlue,
                      title: const Text(
                        'Dirección principal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Será la dirección predeterminada para tus pedidos.',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: esPrincipal,
                      onChanged: (value) {
                        setDialogState(() {
                          esPrincipal = value;
                        });
                      },
                    ),
                  ],
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
                TextButton(
                  onPressed: () {
                    final cleanNombre = nombre.trim();
                    final cleanDireccion = direccion.trim();
                    final cleanComuna = comuna.trim();
                    final cleanReferencia = referencia.trim();

                    if (cleanNombre.isEmpty ||
                        cleanDireccion.isEmpty ||
                        cleanComuna.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Completa nombre, dirección y comuna.'),
                        ),
                      );

                      return;
                    }

                    Navigator.pop(dialogContext, {
                      'nombre': cleanNombre,
                      'direccion': cleanDireccion,
                      'comuna': cleanComuna,
                      'referencia': cleanReferencia,
                      'es_principal': esPrincipal,
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
      },
    );

    if (result == null || !mounted) {
      return;
    }

    if (isEditing) {
      await _updateAddress(
        addressId: addressData['id'] as int,
        nombre: result['nombre'] as String,
        direccion: result['direccion'] as String,
        comuna: result['comuna'] as String,
        referencia: result['referencia'] as String,
        esPrincipal: result['es_principal'] as bool,
      );
    } else {
      await _createAddress(
        nombre: result['nombre'] as String,
        direccion: result['direccion'] as String,
        comuna: result['comuna'] as String,
        referencia: result['referencia'] as String,
        esPrincipal: result['es_principal'] as bool,
      );
    }
  }

  Future<void> _createAddress({
    required String nombre,
    required String direccion,
    required String comuna,
    required String referencia,
    required bool esPrincipal,
  }) async {
    if (!mounted) {
      return;
    }

    setState(() {
      procesandoDireccion = true;
    });

    try {
      final response = await ApiService.createAddress(
        nombre: nombre,
        direccion: direccion,
        comuna: comuna,
        referencia: referencia,
        esPrincipal: esPrincipal,
      );

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 201) {
        await _loadAddresses();

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dirección agregada correctamente.')),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible agregar la dirección.',
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
          procesandoDireccion = false;
        });
      }
    }
  }

  Future<void> _updateAddress({
    required int addressId,
    required String nombre,
    required String direccion,
    required String comuna,
    required String referencia,
    required bool esPrincipal,
  }) async {
    if (!mounted) {
      return;
    }

    setState(() {
      procesandoDireccion = true;
    });

    try {
      final response = await ApiService.updateAddress(
        addressId: addressId,
        nombre: nombre,
        direccion: direccion,
        comuna: comuna,
        referencia: referencia,
        esPrincipal: esPrincipal,
      );

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        await _loadAddresses();

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dirección actualizada correctamente.')),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible actualizar la dirección.',
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
          procesandoDireccion = false;
        });
      }
    }
  }

  Future<void> _confirmDeleteAddress(Map<String, dynamic> addressData) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Eliminar dirección',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('¿Deseas eliminar "${addressData['nombre']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Eliminar',
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

    if (confirm != true || !mounted) {
      return;
    }

    await _deleteAddress(addressData['id'] as int);
  }

  Future<void> _deleteAddress(int addressId) async {
    if (!mounted) {
      return;
    }

    setState(() {
      procesandoDireccion = true;
    });

    try {
      final response = await ApiService.deleteAddress(addressId);

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        await _loadAddresses();

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dirección eliminada correctamente.')),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message'] ?? 'No fue posible eliminar la dirección.',
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
          procesandoDireccion = false;
        });
      }
    }
  }

  IconData _getAddressIcon(String nombre) {
    final normalized = nombre.trim().toLowerCase();

    if (normalized.contains('casa') || normalized.contains('hogar')) {
      return Icons.home_outlined;
    }

    if (normalized.contains('trabajo') || normalized.contains('oficina')) {
      return Icons.work_outline;
    }

    return Icons.location_on_outlined;
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
          onPressed: procesandoDireccion
              ? null
              : () {
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
        child: cargandoDirecciones
            ? const Center(child: CircularProgressIndicator(color: primaryBlue))
            : RefreshIndicator(
                color: primaryBlue,
                onRefresh: _loadAddresses,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  children: [
                    const Text(
                      'Direcciones guardadas',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (addresses.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.location_off_outlined,
                              size: 42,
                              color: Colors.black38,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Aún no tienes direcciones guardadas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...List.generate(addresses.length, (index) {
                        final item = addresses[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == addresses.length - 1 ? 0 : 12,
                          ),
                          child: _buildAddress(addressData: item),
                        );
                      }),

                    const SizedBox(height: 24),

                    OutlinedButton.icon(
                      onPressed: procesandoDireccion
                          ? null
                          : () {
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

                    if (procesandoDireccion) ...[
                      const SizedBox(height: 20),
                      const Center(
                        child: CircularProgressIndicator(
                          color: primaryBlue,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildAddress({required Map<String, dynamic> addressData}) {
    final nombre = (addressData['nombre'] ?? 'Dirección').toString();

    final direccion = (addressData['direccion'] ?? '').toString();

    final comuna = (addressData['comuna'] ?? '').toString();

    final referencia = (addressData['referencia'] ?? '').toString();

    final bool esPrincipal = addressData['es_principal'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: esPrincipal
              ? primaryBlue.withValues(alpha: 0.45)
              : const Color(0xFFE4E4E4),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: primaryBlue.withValues(alpha: 0.10),
            child: Icon(_getAddressIcon(nombre), color: primaryBlue),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        nombre,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (esPrincipal) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: primaryBlue.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Principal',
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  comuna.isEmpty ? direccion : '$direccion, $comuna',
                  style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                ),

                if (referencia.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Referencia: $referencia',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ],
            ),
          ),

          PopupMenuButton<String>(
            enabled: !procesandoDireccion,
            icon: const Icon(Icons.more_vert, color: Colors.black45),
            onSelected: (value) {
              if (value == 'edit') {
                _showAddressDialog(addressData: addressData);
              }

              if (value == 'delete') {
                _confirmDeleteAddress(addressData);
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 10),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
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
      onTap: procesandoDireccion
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
