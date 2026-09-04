import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({super.key});

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<Map<String, dynamic>> direcciones = [];
  List<Map<String, dynamic>> resultados = [];

  bool cargandoDirecciones = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAddresses();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    if (mounted) {
      setState(() {
        cargandoDirecciones = true;
        errorMessage = null;
      });
    }

    try {
      final response = await ApiService.getAddresses();

      if (!mounted) {
        return;
      }

      final int statusCode = response['status_code'] ?? 0;

      if (statusCode == 200) {
        final data = response['addresses'];

        if (data is List) {
          final loadedAddresses = data
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();

          loadedAddresses.sort((a, b) {
            final bool aPrincipal = a['es_principal'] == true;
            final bool bPrincipal = b['es_principal'] == true;

            if (aPrincipal == bPrincipal) {
              return 0;
            }

            return aPrincipal ? -1 : 1;
          });

          setState(() {
            direcciones = loadedAddresses;
            resultados = List<Map<String, dynamic>>.from(loadedAddresses);
            cargandoDirecciones = false;
          });

          return;
        }
      }

      setState(() {
        direcciones = [];
        resultados = [];
        cargandoDirecciones = false;
        errorMessage =
            response['message'] ?? 'No fue posible cargar las direcciones.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        direcciones = [];
        resultados = [];
        cargandoDirecciones = false;
        errorMessage = 'No fue posible conectar con el servidor.';
      });
    }
  }

  void buscarDireccion(String texto) {
    final busqueda = texto.trim().toLowerCase();

    setState(() {
      if (busqueda.isEmpty) {
        resultados = List<Map<String, dynamic>>.from(direcciones);
        return;
      }

      resultados = direcciones.where((addressData) {
        final nombre = (addressData['nombre'] ?? '').toString().toLowerCase();
        final direccion = (addressData['direccion'] ?? '')
            .toString()
            .toLowerCase();
        final comuna = (addressData['comuna'] ?? '').toString().toLowerCase();
        final referencia = (addressData['referencia'] ?? '')
            .toString()
            .toLowerCase();

        return nombre.contains(busqueda) ||
            direccion.contains(busqueda) ||
            comuna.contains(busqueda) ||
            referencia.contains(busqueda);
      }).toList();
    });
  }

  String _formatAddress(Map<String, dynamic> addressData) {
    final direccion = (addressData['direccion'] ?? '').toString().trim();
    final comuna = (addressData['comuna'] ?? '').toString().trim();

    if (comuna.isEmpty) {
      return direccion;
    }

    return '$direccion, $comuna';
  }

  void seleccionarDireccion(Map<String, dynamic> addressData) {
    Navigator.pop(context, _formatAddress(addressData));
  }

  void usarUbicacionActual() {
    final principal = direcciones.where((addressData) {
      return addressData['es_principal'] == true;
    }).toList();

    if (principal.isNotEmpty) {
      seleccionarDireccion(principal.first);
      return;
    }

    if (direcciones.isNotEmpty) {
      seleccionarDireccion(direcciones.first);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No tienes una dirección guardada para usar como ubicación actual.',
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),

            Expanded(
              child: RefreshIndicator(
                color: primaryColor,
                onRefresh: _loadAddresses,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      const Text(
                        'Busca una dirección',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF303030),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Selecciona una de tus direcciones guardadas para recibir el pedido.',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: Color(0xFF777777),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 48,
                        child: TextField(
                          controller: searchController,
                          focusNode: searchFocusNode,
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.search,
                          onChanged: buscarDireccion,
                          decoration: InputDecoration(
                            hintText: 'Buscar dirección',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFA7A7A7),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 21,
                              color: Color(0xFF777777),
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      buscarDireccion('');
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Color(0xFF777777),
                                    ),
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                color: Color(0xFFD8D8D8),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 1.3,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      InkWell(
                        onTap: cargandoDirecciones ? null : usarUbicacionActual,
                        borderRadius: BorderRadius.circular(7),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          child: Row(
                            children: [
                              Icon(
                                Icons.my_location,
                                size: 20,
                                color: primaryColor,
                              ),

                              SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  'Usar mi dirección principal',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.chevron_right,
                                size: 20,
                                color: Color(0xFF999999),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 1, color: Color(0xFFEAEAEA)),

                      const SizedBox(height: 19),

                      const Text(
                        'DIRECCIONES GUARDADAS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF777777),
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (cargandoDirecciones)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        )
                      else if (errorMessage != null)
                        _buildError()
                      else if (resultados.isEmpty)
                        _buildSinResultados()
                      else
                        ...resultados.map(
                          (addressData) => _buildDireccion(addressData),
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 57,
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xFF252525),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Dirección de entrega',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202020),
              ),
            ),
          ),
          const SizedBox(width: 56),
        ],
      ),
    );
  }

  Widget _buildDireccion(Map<String, dynamic> addressData) {
    final nombre = (addressData['nombre'] ?? 'Dirección').toString();
    final direccion = _formatAddress(addressData);
    final referencia = (addressData['referencia'] ?? '').toString();
    final bool esPrincipal = addressData['es_principal'] == true;

    return InkWell(
      onTap: () {
        seleccionarDireccion(addressData);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getAddressIcon(nombre),
              size: 21,
              color: const Color(0xFF303030),
            ),

            const SizedBox(width: 11),

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
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF303030),
                          ),
                        ),
                      ),

                      if (esPrincipal) ...[
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Principal',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 3),

                  Text(
                    direccion,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: Color(0xFF555555),
                    ),
                  ),

                  if (referencia.trim().isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Referencia: $referencia',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 42),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 42,
            color: Color(0xFFBDBDBD),
          ),

          const SizedBox(height: 12),

          Text(
            errorMessage ?? 'No fue posible cargar las direcciones.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF777777)),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: _loadAddresses,
            child: const Text(
              'Reintentar',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSinResultados() {
    final bool hayBusqueda = searchController.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Icon(
            Icons.location_off_outlined,
            size: 42,
            color: Color(0xFFBDBDBD),
          ),

          const SizedBox(height: 12),

          Text(
            hayBusqueda
                ? 'No encontramos direcciones'
                : 'Aún no tienes direcciones guardadas',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            hayBusqueda ? 'Intenta realizar una búsqueda diferente.' : 'Puedes agregar una dirección desde Mi perfil > Mis direcciones.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}
