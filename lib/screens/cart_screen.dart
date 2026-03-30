import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _tipoEntrega = "delivery"; // delivery o recojo
  bool _obteniendoUbicacion = false;
  String _direccionSeleccionada = "";

  Future<void> _obtenerUbicacion() async {
    setState(() => _obteniendoUbicacion = true);

    final permission = await Permission.location.request();
    if (!permission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permiso de ubicación denegado"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _obteniendoUbicacion = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _direccionSeleccionada =
        "https://maps.google.com/?q=${position.latitude},${position.longitude}";
        _obteniendoUbicacion = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Ubicación obtenida correctamente"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _obteniendoUbicacion = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al obtener ubicación"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 17, 41),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1035),
        title: Row(
          children: [
            const Text(
              "Mi Carrito 🛒",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (cart.totalItems > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${cart.totalItems}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: cart.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🛒", style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text(
              "Tu carrito está vacío",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Agrega tus tortas favoritas",
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
              child: const Text("Ver tortas", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // TIPO DE ENTREGA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2340),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tipo de entrega",
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // DELIVERY
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
                            // RECOJO
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _tipoEntrega = "recojo";
                                  _direccionSeleccionada = "";
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

                        // UBICACIÓN SI ES DELIVERY
                        if (_tipoEntrega == "delivery") ...[
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: _obteniendoUbicacion ? null : _obtenerUbicacion,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _direccionSeleccionada.isNotEmpty
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _direccionSeleccionada.isNotEmpty
                                      ? Colors.green
                                      : Colors.white12,
                                ),
                              ),
                              child: Row(
                                children: [
                                  _obteniendoUbicacion
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFE91E63),
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Icon(
                                    _direccionSeleccionada.isNotEmpty
                                        ? Icons.location_on
                                        : Icons.my_location,
                                    color: _direccionSeleccionada.isNotEmpty
                                        ? Colors.green
                                        : const Color(0xFFE91E63),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _direccionSeleccionada.isNotEmpty
                                          ? "✅ Ubicación obtenida"
                                          : "Toca para usar mi ubicación actual",
                                      style: TextStyle(
                                        color: _direccionSeleccionada.isNotEmpty
                                            ? Colors.green
                                            : Colors.white54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        // INFO RECOJO
                        if (_tipoEntrega == "recojo") ...[
                          const SizedBox(height: 14),
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
                                    "Av. El Sol 123, Arequipa\nHorario: 9am - 8pm",
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

                  const SizedBox(height: 16),

                  // LISTA DE ITEMS
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2340),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.imagen,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: const Color(0xFF0A1129),
                                  child: const Center(child: Text("🎂", style: TextStyle(fontSize: 30))),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nombre,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE91E63).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Talla: ${item.tamanio}",
                                      style: const TextStyle(fontSize: 11, color: Color(0xFFE91E63)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "S/ ${item.subtotal.toStringAsFixed(0)}",
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => cart.removeItem(index),
                                  child: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => cart.decreaseQuantity(index),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.remove, color: Colors.white, size: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "${item.cantidad}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => cart.increaseQuantity(index),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE91E63),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // RESUMEN Y BOTÓN PAGAR
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1035),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal", style: TextStyle(color: Colors.white54, fontSize: 14)),
                    Text(
                      "S/ ${cart.totalPrice.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Delivery", style: TextStyle(color: Colors.white54, fontSize: 14)),
                    Text(
                      _tipoEntrega == "delivery" ? "S/ 5" : "Gratis",
                      style: TextStyle(
                        color: _tipoEntrega == "delivery" ? Colors.white : Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      "S/ ${(_tipoEntrega == "delivery" ? cart.totalPrice + 5 : cart.totalPrice).toStringAsFixed(0)}",
                      style: const TextStyle(color: Color(0xFFE91E63), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_tipoEntrega == "delivery" && _direccionSeleccionada.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Por favor obtén tu ubicación para el delivery"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            tipoEntrega: _tipoEntrega,
                            ubicacion: _direccionSeleccionada,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Proceder al pago",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}