import 'package:flutter/material.dart';

class CartItem {
  final String nombre;
  final String imagen;
  final double precio;
  final String tamanio;
  final String sabor;
  final int pisos;
  final int porciones;
  final String colorDecoracion;
  final String mensaje;
  int cantidad;

  CartItem({
    required this.nombre,
    required this.imagen,
    required this.precio,
    required this.tamanio,
    required this.sabor,
    required this.pisos,
    required this.porciones,
    required this.colorDecoracion,
    required this.mensaje,
    this.cantidad = 1,
  });

  double get subtotal => precio * cantidad;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.subtotal);

  void addItem(
    Map<String, dynamic> torta, 
    String tamanio, 
    double precioFinal,
    String sabor,
    int pisos,
    int porciones,
    String colorDecoracion,
    String mensaje,
  ) {
    final index = _items.indexWhere(
          (item) => item.nombre == torta["nombre"] && 
                    item.tamanio == tamanio &&
                    item.sabor == sabor &&
                    item.pisos == pisos &&
                    item.porciones == porciones &&
                    item.colorDecoracion == colorDecoracion &&
                    item.mensaje == mensaje,
    );

    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(CartItem(
        nombre: torta["nombre"],
        imagen: torta["imagen"],
        precio: precioFinal,
        tamanio: tamanio,
        sabor: sabor,
        pisos: pisos,
        porciones: porciones,
        colorDecoracion: colorDecoracion,
        mensaje: mensaje,
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