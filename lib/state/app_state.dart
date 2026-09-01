class AppState {
  AppState._internal();

  static final AppState instance = AppState._internal();

  // ============================================================
  // TARJETAS GUARDADAS
  // ============================================================

  final List<String> tarjetasGuardadas = [
    'Visa •••• 5623',
  ];

  // ============================================================
  // MÉTODO DE PAGO
  // ============================================================

  String metodoPagoSeleccionado =
      'Visa •••• 5623';

  // ============================================================
  // DIRECCIÓN
  // ============================================================

  String direccionSeleccionada =
      'Pasaje Matucana 8853, La Reina';

  // ============================================================
  // TARJETAS
  // ============================================================

  void agregarTarjeta(String tarjeta) {
    if (!tarjetasGuardadas.contains(tarjeta)) {
      tarjetasGuardadas.add(tarjeta);
    }

    metodoPagoSeleccionado = tarjeta;
  }

  void eliminarTarjeta(String tarjeta) {
    tarjetasGuardadas.remove(tarjeta);

    if (metodoPagoSeleccionado == tarjeta) {
      if (tarjetasGuardadas.isNotEmpty) {
        metodoPagoSeleccionado =
            tarjetasGuardadas.first;
      } else {
        metodoPagoSeleccionado =
            'Mercado Pago';
      }
    }
  }

  // ============================================================
  // SELECCIONAR MÉTODO DE PAGO
  // ============================================================

  void seleccionarMetodoPago(String metodo) {
    metodoPagoSeleccionado = metodo;
  }

  // ============================================================
  // SELECCIONAR DIRECCIÓN
  // ============================================================

  void seleccionarDireccion(String direccion) {
    direccionSeleccionada = direccion;
  }
}