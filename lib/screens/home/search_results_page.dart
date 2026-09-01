import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  static const Color primaryBlue = Color(0xFF29ABE2);

  Map<String, dynamic> _getResults(String query) {
    switch (query.toLowerCase()) {
      case 'pizzas':
      case 'pizza':
      case 'pizzería napoli':
        return {
          'restaurant': 'Pizzería Napoli',
          'category': 'Pizzas',
          'time': '30-40 min',
          'products': [
            {
              'name': 'Pizza Burrata - Pesto',
              'image': 'assets/images/pizza_burrata.jpeg',
              'price': '\$10.990',
            },
            {
              'name': 'Pizza Carbonara',
              'image': 'assets/images/pizza_carbonara.jpeg',
              'price': '\$11.990',
            },
          ],
        };

      case 'completos':
      case 'completo':
        return {
          'restaurant': 'El Maestro del Completo',
          'category': 'Completos',
          'time': '20-30 min',
          'products': [
            {
              'name': 'Completo Italiano',
              'image': 'assets/images/completo_italiano.jpeg',
              'price': '\$4.990',
            },
            {
              'name': 'Completo Dinámico',
              'image': 'assets/images/completo_dinamico.jpeg',
              'price': '\$5.490',
            },
          ],
        };

      case 'bebidas':
      case 'bebida':
        return {
          'restaurant': 'FoodPlease Bebidas',
          'category': 'Bebidas',
          'time': '15-25 min',
          'products': [
            {
              'name': 'Coca-Cola',
              'image': 'assets/images/coca_cola.jpeg',
              'price': '\$1.990',
            },
            {
              'name': 'Fanta',
              'image': 'assets/images/fanta.jpeg',
              'price': '\$1.990',
            },
          ],
        };

      case 'hamburguesas':
      case 'hamburguesa':
      default:
        return {
          'restaurant': 'La Casa de la Hamburguesa',
          'category': 'Hamburguesas',
          'time': '25-35 min',
          'products': [
            {
              'name': 'Doble Carne',
              'image': 'assets/images/churrasco_italiano.jpg',
              'price': '\$8.990',
            },
            {
              'name': 'Barros Luco',
              'image': 'assets/images/barros_luco.jpeg',
              'price': '\$7.990',
            },
          ],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final query =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Hamburguesas';

    final results = _getResults(query);

    final String restaurant = results['restaurant'];
    final String category = results['category'];
    final String time = results['time'];

    final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(
      results['products'],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black54),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  query,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Resultados para “$query”',
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Restaurantes',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.restaurant);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFF3F3F3),
                    child: Icon(Icons.restaurant, color: primaryBlue, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$category • $time',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Productos',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 14),

          ...products.asMap().entries.map((entry) {
            final product = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == products.length - 1 ? 0 : 14,
              ),
              child: _ProductResult(
                imagePath: product['image'],
                name: product['name'],
                restaurant: restaurant,
                price: product['price'],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ProductResult extends StatelessWidget {
  const _ProductResult({
    required this.imagePath,
    required this.name,
    required this.restaurant,
    required this.price,
  });

  final String imagePath;
  final String name;
  final String restaurant;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 110,
            height: double.infinity,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    restaurant,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const Spacer(),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
