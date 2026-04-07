import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../providers/cart_provider.dart';
import 'map_screen.dart';
import 'app_main_screen.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {

  // VALORES SELECCIONADOS
  String _tipoEntrega = "delivery";
  String _ubicacion = "";
  DateTime? _fechaEntrega;
  TimeOfDay? _horaEntrega;

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              surface: Color(0xFF1A2340),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (fecha != null) setState(() => _fechaEntrega = fecha);
  }

  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              surface: Color(0xFF1A2340),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (hora != null) setState(() => _horaEntrega = hora);
  }

  Future<void> _seleccionarUbicacion() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );
    if (resultado != null) {
      setState(() => _ubicacion = resultado);
    }
  }

  Future<void> _enviarPedido() async {
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (_fechaEntrega == null || _horaEntrega == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor selecciona fecha y hora de entrega"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_tipoEntrega == "delivery" && _ubicacion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor selecciona tu ubicación en el mapa"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final orderNumber = "TY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final whatsappNumber = "51919576034";
    final fecha = "${_fechaEntrega!.day}/${_fechaEntrega!.month}/${_fechaEntrega!.year}";
    final hora = "${_horaEntrega!.hour.toString().padLeft(2, '0')}:${_horaEntrega!.minute.toString().padLeft(2, '0')}";
    final total = _tipoEntrega == "delivery" ? cart.totalPrice + 5 : cart.totalPrice;

    final StringBuffer mensaje = StringBuffer();
    mensaje.writeln("🎂 *NUEVO PEDIDO - Tortas Yani*");
    mensaje.writeln("─────────────────────────");
    mensaje.writeln("📋 *N° Pedido:* $orderNumber");
    mensaje.writeln();
    mensaje.writeln("🛒 *Productos y Detalles:*");
    for (final item in cart.items) {
      mensaje.writeln("• ${item.cantidad}x ${item.nombre} - S/ ${item.subtotal.toStringAsFixed(0)}");
      mensaje.writeln("  📏 Talla: ${item.tamanio}  |  🍰 ${item.sabor}  |  🏗️ ${item.pisos} pisos  |  👥 ${item.porciones} porc.");
      if (item.colorDecoracion != "Sin color específico" && item.colorDecoracion.isNotEmpty) {
        mensaje.writeln("  🎨 Color: ${item.colorDecoracion}");
      }
      if (item.mensaje != "Sin mensaje" && item.mensaje.isNotEmpty) {
        mensaje.writeln("  ✍️ Mensaje: \"${item.mensaje}\"");
      }
    }
    mensaje.writeln();
    mensaje.writeln("📅 *Entrega:*");
    mensaje.writeln("🗓️ Fecha: $fecha");
    mensaje.writeln("⏰ Hora: $hora");
    mensaje.writeln("🚚 Tipo: ${_tipoEntrega == "delivery" ? "Delivery" : "Recojo en local"}");
    if (_tipoEntrega == "delivery" && _ubicacion.isNotEmpty) {
      mensaje.writeln("📍 Ubicación: $_ubicacion");
    }
    mensaje.writeln();
    mensaje.writeln("💰 *Subtotal:* S/ ${cart.totalPrice.toStringAsFixed(0)}");
    if (_tipoEntrega == "delivery") {
      mensaje.writeln("🚚 *Delivery:* S/ 5");
    }
    mensaje.writeln("💰 *TOTAL: S/ ${total.toStringAsFixed(0)}*");
    mensaje.writeln();
    mensaje.writeln("⏳ Por favor confirmar disponibilidad y coordinar el pago. ¡Gracias! 🙏");

    cart.clearCart();

    final url = "https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(mensaje.toString())}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderNumber: orderNumber)),
      (route) => false,
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE91E63), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final total = _tipoEntrega == "delivery" ? cart.totalPrice + 5 : cart.totalPrice;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 17, 41),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1035),
        title: const Text(
          "Detalles del pedido 🎂",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // RESUMEN DE PRODUCTOS
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Tus productos", Icons.shopping_cart_outlined),
                  ...cart.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${item.cantidad}x ${item.nombre}",
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "S/ ${item.subtotal.toStringAsFixed(0)}",
                          style: const TextStyle(color: Color(0xFFE91E63), fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            // FECHA Y HORA
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Fecha y hora de entrega", Icons.calendar_today),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _seleccionarFecha,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _fechaEntrega != null ? const Color(0xFFE91E63) : Colors.white12,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month, color: Color(0xFFE91E63), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  _fechaEntrega != null
                                      ? "${_fechaEntrega!.day}/${_fechaEntrega!.month}/${_fechaEntrega!.year}"
                                      : "Seleccionar fecha",
                                  style: TextStyle(
                                    color: _fechaEntrega != null ? Colors.white : Colors.white38,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: _seleccionarHora,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _horaEntrega != null ? const Color(0xFFE91E63) : Colors.white12,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, color: Color(0xFFE91E63), size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  _horaEntrega != null
                                      ? "${_horaEntrega!.hour.toString().padLeft(2, '0')}:${_horaEntrega!.minute.toString().padLeft(2, '0')}"
                                      : "Seleccionar hora",
                                  style: TextStyle(
                                    color: _horaEntrega != null ? Colors.white : Colors.white38,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // TIPO DE ENTREGA
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Tipo de entrega", Icons.local_shipping_outlined),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tipoEntrega = "delivery"),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _tipoEntrega == "delivery"
                                  ? const Color(0xFFE91E63)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _tipoEntrega == "delivery"
                                    ? const Color(0xFFE91E63)
                                    : Colors.white12,
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.delivery_dining, color: Colors.white, size: 26),
                                SizedBox(height: 4),
                                Text("Delivery", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                Text("S/ 5", style: TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _tipoEntrega = "recojo";
                            _ubicacion = "";
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _tipoEntrega == "recojo"
                                  ? const Color(0xFFE91E63)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _tipoEntrega == "recojo"
                                    ? const Color(0xFFE91E63)
                                    : Colors.white12,
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.store, color: Colors.white, size: 26),
                                SizedBox(height: 4),
                                Text("Recojo en local", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                Text("Gratis", style: TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_tipoEntrega == "delivery") ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _seleccionarUbicacion,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _ubicacion.isNotEmpty
                              ? Colors.green.withOpacity(0.15)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _ubicacion.isNotEmpty ? Colors.green : Colors.white12,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _ubicacion.isNotEmpty ? Icons.location_on : Icons.map,
                              color: _ubicacion.isNotEmpty ? Colors.green : const Color(0xFFE91E63),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _ubicacion.isNotEmpty
                                    ? "✅ Ubicación seleccionada en el mapa"
                                    : "Toca para seleccionar en el mapa 🗺️",
                                style: TextStyle(
                                  color: _ubicacion.isNotEmpty ? Colors.green : Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (_tipoEntrega == "recojo") ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFFE91E63), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Plaza Tupac Amaru, Cusco\nHorario: 9am - 8pm",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // TOTAL
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Subtotal", style: TextStyle(color: Colors.white54, fontSize: 14)),
                      Text("S/ ${cart.totalPrice.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery", style: TextStyle(color: Colors.white54, fontSize: 14)),
                      Text(
                        _tipoEntrega == "delivery" ? "S/ 5" : "Gratis",
                        style: TextStyle(color: _tipoEntrega == "delivery" ? Colors.white : Colors.green, fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TOTAL", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        "S/ ${total.toStringAsFixed(0)}",
                        style: const TextStyle(color: Color(0xFFE91E63), fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // BOTÓN ENVIAR POR WHATSAPP (SWIPE TO PAY)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: SlideAction(
                onSubmit: () async {
                  await _enviarPedido();
                  return null;
                },
                borderRadius: 16,
                elevation: 0,
                innerColor: Colors.white,
                outerColor: const Color(0xFF25D366),
                sliderButtonIcon: const Icon(Icons.chevron_right, color: Color(0xFF25D366), size: 28),
                text: "Desliza para pedir 🛒",
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                sliderRotate: false,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class OrderSuccessScreen extends StatelessWidget {
  final String orderNumber;

  const OrderSuccessScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 17, 41),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Color(0xFF25D366), size: 80),
              ),

              const SizedBox(height: 24),

              const Text(
                "¡Pedido enviado! 🎂",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              const SizedBox(height: 8),

              const Text(
                "Tu pedido fue enviado por WhatsApp",
                style: TextStyle(fontSize: 14, color: Colors.white54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2340),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("N° Pedido", style: TextStyle(color: Colors.white54, fontSize: 13)),
                    Text(
                      orderNumber,
                      style: const TextStyle(color: Color(0xFFE91E63), fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2340),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFFE91E63), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "El negocio confirmará tu pedido y coordinará el pago por WhatsApp.",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Color(0xFFE91E63), size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Tiempo de respuesta: ~30 minutos",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AppMainScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Volver al inicio",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}