import 'package:flutter/material.dart';

class CartItem {
  final String nombre;
  final String imagen;
  final double precio;
  final String tamanio;
  int cantidad;

  CartItem({
    required this.nombre,
    required this.imagen,
    required this.precio,
    required this.tamanio,
    this.cantidad = 1,
  });

  double get subtotal => precio * cantidad;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.subtotal);

  void addItem(Map<String, dynamic> torta, String tamanio) {
    final index = _items.indexWhere(
          (item) => item.nombre == torta["nombre"] && item.tamanio == tamanio,
    );

    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(CartItem(
        nombre: torta["nombre"],
        imagen: torta["imagen"],
        precio: torta["precio"],
        tamanio: tamanio,
      ));
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index].cantidad++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_items[index].cantidad > 1) {
      _items[index].cantidad--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}