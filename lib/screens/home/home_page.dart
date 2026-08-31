import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String selectedCategory = 'Hamburguesas';

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading ? _buildSkeletonHome() : _buildHomeContent(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSkeletonHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(height: 44, borderRadius: 10),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, _) {
                return _skeletonBox(width: 95, height: 38, borderRadius: 8);
              },
            ),
          ),
          const SizedBox(height: 16),
          _skeletonBox(height: 125, borderRadius: 10),
          const SizedBox(height: 18),
          _skeletonBox(width: 110, height: 16, borderRadius: 4),
          const SizedBox(height: 18),
          SizedBox(
            height: 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 18),
              itemBuilder: (_, _) {
                return Column(
                  children: [
                    _skeletonCircle(size: 64),
                    const SizedBox(height: 8),
                    _skeletonBox(width: 70, height: 10, borderRadius: 4),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _skeletonBox(width: 120, height: 16, borderRadius: 4),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSkeletonFoodCard()),
              const SizedBox(width: 16),
              Expanded(child: _buildSkeletonFoodCard()),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getRecommendedProducts() {
    switch (selectedCategory) {
      case 'Pizzas':
        return [
          {
            'imagePath': 'assets/images/pizza_burrata.jpeg',
            'title': 'Pizza Burrata - Pesto',
            'restaurant': 'Pizzería Napoli',
            'price': '\$10.990',
            'rating': '4.8',
            'reviews': '(1,500+)',
          },
          {
            'imagePath': 'assets/images/pizza_carbonara.jpeg',
            'title': 'Pizza Carbonara',
            'restaurant': 'Pizzería Napoli',
            'price': '\$11.490',
            'rating': '4.7',
            'reviews': '(980+)',
          },
        ];

      case 'Completos':
        return [
          {
            'imagePath': 'assets/images/completo_italiano.jpeg',
            'title': 'Completo Italiano',
            'restaurant': 'El Maestro del Completo',
            'price': '\$4.990',
            'rating': '4.8',
            'reviews': '(1,200+)',
          },
          {
            'imagePath': 'assets/images/completo_dinamico.jpeg',
            'title': 'Completo Dinámico',
            'restaurant': 'El Maestro del Completo',
            'price': '\$5.490',
            'rating': '4.7',
            'reviews': '(870+)',
          },
        ];

      case 'Bebidas':
        return [
          {
            'imagePath': 'assets/images/coca_cola.jpeg',
            'title': 'Coca-Cola',
            'restaurant': 'FoodPlease',
            'price': '\$1.990',
            'rating': '4.9',
            'reviews': '(2,100+)',
          },
          {
            'imagePath': 'assets/images/fanta.jpeg',
            'title': 'Fanta',
            'restaurant': 'FoodPlease',
            'price': '\$1.990',
            'rating': '4.8',
            'reviews': '(1,400+)',
          },
        ];

      case 'Hamburguesas':
      default:
        return [
          {
            'imagePath': 'assets/images/churrasco_italiano.jpg',
            'title': 'Doble Carne',
            'restaurant': 'La Casa de la Hamburguesa',
            'price': '\$8.990',
            'rating': '4.9',
            'reviews': '(2,000+)',
          },
          {
            'imagePath': 'assets/images/barros_luco.jpeg',
            'title': 'Barros Luco',
            'restaurant': 'La Casa de la Hamburguesa',
            'price': '\$7.990',
            'rating': '4.8',
            'reviews': '(1,300+)',
          },
        ];
    }
  }

  int _parsePrice(String price) {
    return int.parse(price.replaceAll('\$', '').replaceAll('.', ''));
  }

  Future<void> _openRecommendedProduct(Map<String, String> product) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: {
        'name': product['title']!,
        'image': product['imagePath']!,
        'description': _getProductDescription(product['title']!),
        'price': _parsePrice(product['price']!),
      },
    );

    if (result is Map<String, dynamic> && mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.restaurant,
        arguments: {'addedProduct': result},
      );
    }
  }

  String _getProductDescription(String productName) {
    switch (productName) {
      case 'Doble Carne':
        return 'Hamburguesa doble carne, queso, tomate y salsa especial.';

      case 'Barros Luco':
        return 'Carne a la plancha con abundante queso fundido.';

      case 'Pizza Burrata - Pesto':
        return 'Pizza con burrata, pesto y selección de ingredientes frescos.';

      case 'Pizza Carbonara':
        return 'Pizza estilo carbonara con queso y salsa cremosa.';

      case 'Completo Italiano':
        return 'Completo con tomate, palta y mayonesa.';

      case 'Completo Dinámico':
        return 'Completo acompañado de tomate, palta, chucrut y salsas.';

      case 'Coca-Cola':
        return 'Bebida Coca-Cola individual.';

      case 'Fanta':
        return 'Bebida Fanta individual.';

      default:
        return 'Producto disponible en FoodPlease.';
    }
  }

  Widget _buildHomeContent() {
    final recommendedProducts = _getRecommendedProducts();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 10),
          _buildCategories(),
          const SizedBox(height: 16),
          _buildBanner(),
          const SizedBox(height: 18),

          const Text(
            'Restaurantes destacados',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 14),

          _buildRestaurants(),

          const SizedBox(height: 22),

          const Text(
            'Recomendados para ti',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRecommendedCard(
                  imagePath: recommendedProducts[0]['imagePath']!,
                  title: recommendedProducts[0]['title']!,
                  restaurant: recommendedProducts[0]['restaurant']!,
                  price: recommendedProducts[0]['price']!,
                  rating: recommendedProducts[0]['rating']!,
                  reviews: recommendedProducts[0]['reviews']!,
                  onTap: () {
                    _openRecommendedProduct(recommendedProducts[0]);
                  },
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _buildRecommendedCard(
                  imagePath: recommendedProducts[1]['imagePath']!,
                  title: recommendedProducts[1]['title']!,
                  restaurant: recommendedProducts[1]['restaurant']!,
                  price: recommendedProducts[1]['price']!,
                  rating: recommendedProducts[1]['rating']!,
                  reviews: recommendedProducts[1]['reviews']!,
                  onTap: () {
                    _openRecommendedProduct(recommendedProducts[1]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.search);
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.black54),
            SizedBox(width: 10),
            Text(
              'Buscar',
              style: TextStyle(color: Colors.black45, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    const categories = ['Hamburguesas', 'Pizzas', 'Completos', 'Bebidas'];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedCategory == category
                    ? const Color(0xFF29ABE2)
                    : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selectedCategory == category
                      ? const Color(0xFF29ABE2)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selectedCategory == category
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/pizza_burrata.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.72), Colors.transparent],
          ),
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué quieres\ncomer hoy?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Encuentra tus favoritos\nen FoodPlease',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurants() {
    final restaurants = [
      {
        'image': 'assets/images/barros_luco.jpeg',
        'name': 'La Casa de la\nHamburguesa',
      },
      {
        'image': 'assets/images/pizza_carbonara.jpeg',
        'name': 'Pizzería\nNapoli',
      },
      {
        'image': 'assets/images/completo_italiano.jpeg',
        'name': 'El Maestro del\nCompleto',
      },
      {'image': 'assets/images/lomito.jpeg', 'name': 'Empanadas\nAldina'},
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: restaurants.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

          return InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.restaurant);
            },
            child: SizedBox(
              width: 80,
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      image: DecorationImage(
                        image: AssetImage(restaurant['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant['name']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, height: 1.15),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedCard({
    required String imagePath,
    required String title,
    required String restaurant,
    required String price,
    required String rating,
    required String reviews,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1.15,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 2),

          Text(
            restaurant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                '$price.-',
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),

              const SizedBox(width: 6),

              const Icon(Icons.star, size: 14, color: Colors.amber),

              const SizedBox(width: 2),

              Text(rating, style: const TextStyle(fontSize: 11)),

              const SizedBox(width: 3),

              Expanded(
                child: Text(
                  reviews,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: Colors.black45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: const Color(0xFF29ABE2),
      unselectedItemColor: Colors.black54,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 4) {
          Navigator.pushNamed(context, AppRoutes.profile);
        }

        if (index == 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agrega un producto para comenzar un carrito.'),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explorar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrito',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }

  Widget _buildSkeletonFoodCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _skeletonBox(height: 150, borderRadius: 8),
        const SizedBox(height: 10),
        _skeletonBox(width: 70, height: 12, borderRadius: 4),
        const SizedBox(height: 8),
        _skeletonBox(width: 100, height: 10, borderRadius: 4),
      ],
    );
  }

  Widget _skeletonBox({
    double? width,
    required double height,
    double borderRadius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _skeletonCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEDEDED),
        shape: BoxShape.circle,
      ),
    );
  }
}
