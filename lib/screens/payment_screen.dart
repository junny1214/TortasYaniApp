import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/cart_provider.dart';
import 'app_main_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String tipoEntrega;
  final String ubicacion;

  const PaymentScreen({
    super.key,
    required this.tipoEntrega,
    required this.ubicacion,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedMethod = 0;
  final _cardNumber = TextEditingController();
  final _cardName = TextEditingController();
  final _cardExpiry = TextEditingController();
  final _cardCvv = TextEditingController();
  bool _isProcessing = false;

  final String yapeNumber = "997691488";
  final String plinNumber = "997691488";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final total = widget.tipoEntrega == "delivery"
        ? cart.totalPrice + 5
        : cart.totalPrice;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 17, 41),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1035),
        title: const Text(
          "Método de pago",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // RESUMEN DEL PEDIDO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total a pagar", style: TextStyle(color: Colors.white54, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                            widget.tipoEntrega == "delivery"
                                ? "Incluye delivery S/ 5"
                                : "Recojo en local - Sin delivery",
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ),
                      Text(
                        "S/ ${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.tipoEntrega == "delivery"
                          ? const Color(0xFFE91E63).withOpacity(0.15)
                          : Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.tipoEntrega == "delivery" ? Icons.delivery_dining : Icons.store,
                          color: widget.tipoEntrega == "delivery" ? const Color(0xFFE91E63) : Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.tipoEntrega == "delivery" ? "Delivery a domicilio" : "Recojo en local",
                          style: TextStyle(
                            color: widget.tipoEntrega == "delivery" ? const Color(0xFFE91E63) : Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Selecciona tu método de pago",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            const SizedBox(height: 16),

            // MÉTODOS DE PAGO
            Row(
              children: [
                _methodButton(0, "Yape", const Color(0xFF6B0AC9), Icons.phone_android),
                const SizedBox(width: 10),
                _methodButton(1, "Plin", const Color(0xFF00B1B0), Icons.phone_android),
                const SizedBox(width: 10),
                _methodButton(2, "Tarjeta", const Color(0xFF1A2340), Icons.credit_card),
              ],
            ),

            const SizedBox(height: 24),

            if (selectedMethod == 0) _yapeSection(total),
            if (selectedMethod == 1) _plinSection(total),
            if (selectedMethod == 2) _cardSection(),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _processPay(context, cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Confirmar pago",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _methodButton(int index, String label, Color color, IconData icon) {
    final isSelected = selectedMethod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedMethod = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color : const Color(0xFF1A2340),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.white12,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _yapeSection(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6B0AC9).withOpacity(0.3),
            const Color(0xFF3D0070).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6B0AC9).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B0AC9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "💜 Paga con Yape",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B0AC9).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774840365/yape_xqlwkp.jpg",
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone, color: Color(0xFF6B0AC9), size: 18),
                const SizedBox(width: 8),
                Text(
                  yapeNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6B0AC9).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Monto a pagar: S/ ${total.toStringAsFixed(0)}",
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          const Text("Ericson David Mendoza Diaz", style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          const Text("Escanea el QR o ingresa el número", style: TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _plinSection(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00B1B0).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00B1B0).withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B1B0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "💚 Paga con Plin",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: "plin://payment?phone=$plinNumber&amount=${total.toStringAsFixed(2)}&description=TortasYani",
              version: QrVersions.auto,
              size: 200,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone, color: Color(0xFF00B1B0), size: 18),
                const SizedBox(width: 8),
                Text(
                  plinNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF00B1B0).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Monto a pagar: S/ ${total.toStringAsFixed(0)}",
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          const Text("Ericson David Mendoza Diaz", style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _cardSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2340),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          const Text(
            "Datos de tu tarjeta",
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _cardField(_cardNumber, "Número de tarjeta", Icons.credit_card, TextInputType.number),
          const SizedBox(height: 12),
          _cardField(_cardName, "Nombre en la tarjeta", Icons.person_outline, TextInputType.text),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _cardField(_cardExpiry, "MM/AA", Icons.calendar_today, TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _cardField(_cardCvv, "CVV", Icons.lock_outline, TextInputType.number)),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.security, color: Colors.white38, size: 14),
              SizedBox(width: 6),
              Text("Pago seguro con encriptación SSL", style: TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardField(TextEditingController controller, String hint, IconData icon, TextInputType keyboard) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Future<void> _processPay(BuildContext context, CartProvider cart) async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isProcessing = false);

    final items = List<CartItem>.from(cart.items);
    final total = widget.tipoEntrega == "delivery"
        ? cart.totalPrice + 5
        : cart.totalPrice;
    final orderNumber = "TY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final whatsappNumber = "51919576034";

    final StringBuffer mensaje = StringBuffer();
    mensaje.writeln("🎂 *NUEVO PEDIDO - Tortas Yani*");
    mensaje.writeln("─────────────────────");
    mensaje.writeln("📋 *Pedido:* $orderNumber");
    mensaje.writeln();
    mensaje.writeln("🛒 *Detalle:*");
    for (final item in items) {
      mensaje.writeln("• ${item.cantidad}x ${item.nombre} (Talla: ${item.tamanio}) - S/ ${item.subtotal.toStringAsFixed(0)}");
    }
    mensaje.writeln();

    if (widget.tipoEntrega == "delivery") {
      mensaje.writeln("🚚 *Tipo:* Delivery");
      mensaje.writeln("🚚 Delivery: S/ 5");
      if (widget.ubicacion.isNotEmpty) {
        mensaje.writeln("📍 *Mi ubicación:* ${widget.ubicacion}");
      }
    } else {
      mensaje.writeln("🏪 *Tipo:* Recojo en local");
      mensaje.writeln("🚚 Delivery: Gratis");
    }

    mensaje.writeln("💰 *Total: S/ ${total.toStringAsFixed(0)}*");
    mensaje.writeln();
    mensaje.writeln("✅ Pago realizado. Por favor confirmar mi pedido. ¡Gracias!");

    cart.clearCart();

    final url = "https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(mensaje.toString())}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(
          items: items,
          total: total,
          orderNumber: orderNumber,
          tipoEntrega: widget.tipoEntrega,
        ),
      ),
          (route) => false,
    );
  }
}

class PaymentSuccessScreen extends StatefulWidget {
  final List<CartItem> items;
  final double total;
  final String orderNumber;
  final String tipoEntrega;

  const PaymentSuccessScreen({
    super.key,
    required this.items,
    required this.total,
    required this.orderNumber,
    required this.tipoEntrega,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  int _rating = 0;
  final String whatsappNumber = "51919576034";

  Future<void> _openWhatsApp() async {
    final mensaje = Uri.encodeComponent(
      "Hola! Acabo de realizar un pedido en Tortas Yani 🎂\n"
          "Número de pedido: ${widget.orderNumber}\n"
          "Total: S/ ${widget.total.toStringAsFixed(0)}\n"
          "Por favor confirmar mi pedido. ¡Gracias!",
    );
    final url = "https://wa.me/$whatsappNumber?text=$mensaje";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 17, 41),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 50),

            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 80),
            ),

            const SizedBox(height: 20),

            const Text(
              "¡Pago exitoso! 🎂",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            const SizedBox(height: 8),

            const Text(
              "Tu pedido está siendo preparado",
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),

            const SizedBox(height: 24),

            // NÚMERO DE PEDIDO
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
                  const Text("Número de pedido", style: TextStyle(color: Colors.white54, fontSize: 13)),
                  Text(
                    widget.orderNumber,
                    style: const TextStyle(color: Color(0xFFE91E63), fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // RESUMEN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Resumen del pedido",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...widget.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${item.cantidad}x ${item.nombre} (${item.tamanio})",
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "S/ ${item.subtotal.toStringAsFixed(0)}",
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  )),
                  const Divider(color: Colors.white12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery", style: TextStyle(color: Colors.white54, fontSize: 13)),
                      Text(
                        widget.tipoEntrega == "delivery" ? "S/ 5" : "Gratis",
                        style: TextStyle(
                          color: widget.tipoEntrega == "delivery" ? Colors.white54 : Colors.green,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        "S/ ${widget.total.toStringAsFixed(0)}",
                        style: const TextStyle(color: Color(0xFFE91E63), fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TIEMPO ESTIMADO
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, color: Color(0xFFE91E63), size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Tiempo estimado de entrega: 30-45 min",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TIPO DE ENTREGA
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.tipoEntrega == "delivery" ? Icons.delivery_dining : Icons.store,
                    color: const Color(0xFFE91E63),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.tipoEntrega == "delivery"
                        ? "Entrega a domicilio 🚚"
                        : "Recojo en local 🏪",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CALIFICACIÓN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2340),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    "¿Cómo calificarías tu experiencia?",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = index + 1),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFE91E63),
                          size: 36,
                        ),
                      );
                    }),
                  ),
                  if (_rating > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _rating == 5 ? "¡Excelente! 🎉" :
                        _rating == 4 ? "¡Muy bueno! 😊" :
                        _rating == 3 ? "Regular 😐" :
                        _rating == 2 ? "Mejorable 😕" : "Malo 😞",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN WHATSAPP
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _openWhatsApp,
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  "Confirmar por WhatsApp",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN VOLVER
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}