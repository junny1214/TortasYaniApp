import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import '../providers/favorites_provider.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    "All",
    "Tortas Especiales",
    "Cheesecake y Pyes",
    "Tortas",
    "Matrimoniales",
    "Quinceañeros",
  ];

  final List<Map<String, dynamic>> tortas = [
    {
      "nombre": "Torta de Chocolate",
      "categoria": "Tortas Especiales",
      "precio": 85.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234559/torta_de_chocolate_wv8mi7.png",
      "rating": 4.9,
      "resenas": 124,
      "badge": "Popular",
      "descripcion": "Deliciosa torta de chocolate con capas de bizcocho húmedo y ganache.",
      "ingredientes": ["Chocolate", "Harina", "Huevos", "Mantequilla", "Azúcar"],
      "tamanios": ["S", "M", "L"],
    },
    {
      "nombre": "Cheesecake de Maracuyá",
      "categoria": "Cheesecake y Pyes",
      "precio": 80.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234883/Cheesecake_de_Maracuy%C3%A1_knhn3w.png",
      "rating": 4.9,
      "resenas": 110,
      "badge": "Popular",
      "descripcion": "Refrescante cheesecake con coulis de maracuyá tropical.",
      "ingredientes": ["Maracuyá", "Queso crema", "Galletas", "Crema", "Azúcar"],
      "tamanios": ["S", "M", "L"],
    },
    {
      "nombre": "Torta de Zanahoria",
      "categoria": "Tortas",
      "precio": 65.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234868/Torta_de_Zanahoriaa_ury5wh.png",
      "rating": 4.7,
      "resenas": 76,
      "badge": "Favorito",
      "descripcion": "Esponjosa torta de zanahoria con frosting de queso crema y nueces.",
      "ingredientes": ["Zanahoria", "Harina", "Huevos", "Nueces", "Queso crema"],
      "tamanios": ["S", "M", "L"],
    },
    {
      "nombre": "Torta de Vainilla",
      "categoria": "Tortas",
      "precio": 60.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234876/torta_de_vainilla_vgcfkf.png",
      "rating": 4.6,
      "resenas": 89,
      "badge": "",
      "descripcion": "Clásica torta de vainilla con crema suave y decoración elegante.",
      "ingredientes": ["Vainilla", "Harina", "Huevos", "Mantequilla", "Leche"],
      "tamanios": ["S", "M", "L"],
    },
    {
      "nombre": "Torta Matrimonial",
      "categoria": "Matrimoniales",
      "precio": 250.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234891/Torta_Matrimonial_qhxegx.png",
      "rating": 5.0,
      "resenas": 45,
      "badge": "Premium",
      "descripcion": "Elegante torta matrimonial de varios pisos decorada a medida.",
      "ingredientes": ["Vainilla", "Fondant", "Crema", "Flores", "Perlas"],
      "tamanios": ["M", "L", "XL"],
    },
    {
      "nombre": "Torta de Quinceañera",
      "categoria": "Quinceañeros",
      "precio": 200.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234897/Torta_de_Quincea%C3%B1era_evxzmp.png",
      "rating": 4.8,
      "resenas": 62,
      "badge": "Especial",
      "descripcion": "Torta especial para quinceañeras con decoración rosa y detalles dorados.",
      "ingredientes": ["Vainilla", "Fondant rosa", "Crema", "Flores", "Brillantina"],
      "tamanios": ["M", "L", "XL"],
    },
    {
      "nombre": "Pie de Limón",
      "categoria": "Cheesecake y Pyes",
      "precio": 55.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234905/Pie_de_Lim%C3%B3n_plhcyw.png",
      "rating": 4.7,
      "resenas": 83,
      "badge": "",
      "descripcion": "Clásico pie de limón con merengue tostado y base crocante.",
      "ingredientes": ["Limón", "Huevos", "Azúcar", "Galletas", "Mantequilla"],
      "tamanios": ["S", "M", "L"],
    },
    {
      "nombre": "Red Velvet",
      "categoria": "Tortas Especiales",
      "precio": 90.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234910/Red_Velvet_da5fqq.png",
      "rating": 4.9,
      "resenas": 137,
      "badge": "Top",
      "descripcion": "Irresistible red velvet con frosting de queso crema y color rojo intenso.",
      "ingredientes": ["Cacao", "Colorante rojo", "Queso crema", "Harina", "Buttermilk"],
      "tamanios": ["S", "M", "L"],
    },
    {
      "nombre": "Tres Leches",
      "categoria": "Tortas",
      "precio": 70.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234917/Tres_Leches_d8lm11.png",
      "rating": 4.8,
      "resenas": 91,
      "badge": "Nuevo",
      "descripcion": "Esponjoso bizcocho empapado en tres tipos de leche con crema chantilly.",
      "ingredientes": ["Leche condensada", "Leche evaporada", "Crema", "Huevos", "Harina"],
      "tamanios": ["S", "M", "L"],
    },
    {
      "nombre": "Torta de Frutos del Bosque",
      "categoria": "Tortas Especiales",
      "precio": 95.0,
      "imagen": "https://res.cloudinary.com/ddfzttgyr/image/upload/v1774234923/Torta_de_Frutos_del_Bosque_sfpmtk.png",
      "rating": 4.8,
      "resenas": 72,
      "badge": "Nuevo",
      "descripcion": "Exquisita torta con mix de frutos del bosque frescos y crema.",
      "ingredientes": ["Frutos del bosque", "Crema", "Harina", "Huevos", "Azúcar"],
      "tamanios": ["S", "M", "L"],
    },
  ];

  List<Map<String, dynamic>> get tortasFiltradas {
    if (selectedCategory == 0) return tortas;
    return tortas.where((t) => t["categoria"] == categories[selectedCategory]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 17, 41),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                headerParts(),
                mySearchBar(),
                promoCard(),
                const SizedBox(height: 25),
                categoriesSection(),
                const SizedBox(height: 25),
                sectionTitle("Nuestras Tortas 🎂"),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: tortasFiltradas.length,
                  itemBuilder: (context, index) {
                    return tortaCard(tortasFiltradas[index]);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerParts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenida 💗",
              style: TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
            ),
            SizedBox(height: 5),
            Text(
              "Tortas Yani",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
          ],
        ),
        Row(
          children: [
            // CARRITO
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              child: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Stack(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFE91E63),
                        child: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
                      ),
                      if (cart.totalItems > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${cart.totalItems}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFFE91E63),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            // NOTIFICACIONES
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFFFF3B0),
                child: Icon(Iconsax.notification_bing, color: Colors.amber, size: 26),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget mySearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.whiteColor,
          hintText: "Buscar tortas...",
          prefixIcon: const Icon(Iconsax.search_normal, color: Color.fromARGB(255, 8, 25, 34)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget promoCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/images/torta.png", fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    " Yani 🍰\nEndulzando tus momentos",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFE91E63),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Explorar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Categorías",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final bool isSelected = selectedCategory == index;
              return GestureDetector(
                onTap: () => setState(() => selectedCategory = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
    );
  }

  Widget tortaCard(Map<String, dynamic> torta) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E63).withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                children: [
                  Image.network(
                    torta["imagen"],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: const Color(0xFF1A2340),
                      child: const Center(child: Text("🎂", style: TextStyle(fontSize: 40))),
                    ),
                  ),
                  if (torta["badge"] != "")
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          torta["badge"],
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favorites, child) {
                        final esFavorito = favorites.isFavorite(torta["nombre"]);
                        return GestureDetector(
                          onTap: () => favorites.toggleFavorite(torta),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              esFavorito ? Icons.favorite : Icons.favorite_border,
                              color: const Color(0xFFE91E63),
                              size: 17,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.white, size: 11),
                          SizedBox(width: 3),
                          Text("30-45 min", style: TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    torta["nombre"],
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    torta["descripcion"],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFE91E63), size: 13),
                      const SizedBox(width: 2),
                      Text("${torta["rating"]}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(width: 4),
                      Text("(${torta["resenas"]})", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: torta["rating"] / 5.0,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFFE91E63),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "S/ ${torta["precio"].toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                      ),
                      GestureDetector(
                        onTap: () {
                          final cart = Provider.of<CartProvider>(context, listen: false);
                          cart.addItem(torta, "M");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${torta["nombre"]} agregado 🛒"),
                              backgroundColor: const Color(0xFFE91E63),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE91E63),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}