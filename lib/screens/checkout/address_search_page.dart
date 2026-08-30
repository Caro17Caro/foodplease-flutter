import 'package:flutter/material.dart';

class AddressSearchPage extends StatefulWidget {
  const AddressSearchPage({super.key});

  @override
  State<AddressSearchPage> createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  static const Color primaryColor = Color(0xFF29ABE2);

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final List<String> direcciones = [
    'Pasaje Matucana 8853, La Reina',
    'Av. Príncipe de Gales 7271, La Reina',
    'Av. Ossa 235, La Reina',
    'Av. Larraín 5862, La Reina',
    'Av. Francisco Bilbao 8750, Las Condes',
  ];

  List<String> resultados = [];

  @override
  void initState() {
    super.initState();
    resultados = List.from(direcciones);

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

  void buscarDireccion(String texto) {
    final busqueda = texto.trim().toLowerCase();

    setState(() {
      if (busqueda.isEmpty) {
        resultados = List.from(direcciones);
      } else {
        resultados = direcciones
            .where(
              (direccion) =>
                  direccion.toLowerCase().contains(busqueda),
            )
            .toList();
      }
    });
  }

  void seleccionarDireccion(String direccion) {
    Navigator.pop(
      context,
      direccion,
    );
  }

  void usarUbicacionActual() {
    const direccionActual =
        'Pasaje Matucana 8853, La Reina';

    Navigator.pop(
      context,
      direccionActual,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEAEAEA),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
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
                      'Ingresa la dirección donde quieres recibir tu pedido.',
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
                          contentPadding:
                              const EdgeInsets.symmetric(
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
                      onTap: usarUbicacionActual,
                      borderRadius: BorderRadius.circular(7),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 13,
                        ),
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
                                'Usar mi ubicación actual',
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

                    const Divider(
                      height: 1,
                      color: Color(0xFFEAEAEA),
                    ),

                    const SizedBox(height: 19),

                    const Text(
                      'DIRECCIONES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (resultados.isEmpty)
                      _buildSinResultados()
                    else
                      ...resultados.map(
                        (direccion) =>
                            _buildDireccion(direccion),
                      ),

                    const SizedBox(height: 20),
                  ],
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
         //Equilibrar el espacio del botón izquierdo.
         const SizedBox(width: 56),
        ],
      ),
    );
  }

  Widget _buildDireccion(String direccion) {
    return InkWell(
      onTap: () {
        seleccionarDireccion(direccion);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 21,
              color: Color(0xFF303030),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Text(
                direccion,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: Color(0xFF303030),
                ),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinResultados() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 50,
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 42,
            color: Color(0xFFBDBDBD),
          ),

          SizedBox(height: 12),

          Text(
            'No encontramos direcciones',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Intenta realizar una búsqueda diferente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }
}