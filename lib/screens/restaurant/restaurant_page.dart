import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  bool isLoading = true;
  int cartQuantity = 0;
  int cartTotal = 0;
  String selectedCategory = 'Sandwich';

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

  Future<void> _openProduct({
    required String name,
    required String image,
    required String description,
    required int price,
  }) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: {
        'name': name,
        'image': image,
        'description': description,
        'price': price,
      },
    );

    if (result is Map<String, dynamic> && mounted) {
      final int quantity = result['quantity'] ?? 1;
      final int total = result['total'] ?? price;

      setState(() {
        cartQuantity += quantity;
        cartTotal += total;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: isLoading ? _buildSkeleton() : _buildRestaurant()),
      bottomNavigationBar: !isLoading && cartQuantity > 0
          ? _buildCartButton()
          : null,
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(height: 220, color: const Color(0xFFE8E8E8)),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeletonBox(width: 240, height: 24),
              const SizedBox(height: 10),
              _skeletonBox(width: 180, height: 16),
              const SizedBox(height: 24),
              Row(
                children: [
                  _skeletonBox(width: 90, height: 36),
                  const SizedBox(width: 10),
                  _skeletonBox(width: 90, height: 36),
                  const SizedBox(width: 10),
                  _skeletonBox(width: 90, height: 36),
                ],
              ),
              const SizedBox(height: 28),
              _skeletonProduct(),
              const SizedBox(height: 14),
              _skeletonProduct(),
              const SizedBox(height: 14),
              _skeletonProduct(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _skeletonProduct() {
    return Container(
      height: 115,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  Widget _skeletonBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildRestaurant() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.asset(
                'assets/images/churrasco_italiano.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 19,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'La Casa de la Hamburguesa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202124),
                ),
              ),

              const SizedBox(height: 8),

              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 19),
                  SizedBox(width: 4),
                  Text('4.9', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(width: 14),
                  Icon(Icons.access_time, size: 18, color: Colors.black54),
                  SizedBox(width: 5),
                  Text('25-35 min', style: TextStyle(color: Colors.black54)),
                ],
              ),

              const SizedBox(height: 7),

              const Text(
                'Hamburguesas • Sandwich • Comida rápida',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),

              const SizedBox(height: 24),

              _buildCategories(),

              const SizedBox(height: 26),

              Text(
                selectedCategory,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              if (selectedCategory == 'Sandwich') ...[
                _buildProduct(
                  name: 'Doble Carne',
                  description: 'Hamburguesa doble carne, queso, tomate y salsa especial.',
                  price: 8990,
                  image: 'assets/images/churrasco_italiano.jpg',
                ),
                const SizedBox(height: 14),
                _buildProduct(
                  name: 'Barros Luco',
                  description:
                      'Carne a la plancha con abundante queso fundido.',
                  price: 7990,
                  image: 'assets/images/barros_luco.jpeg',
                ),
                const SizedBox(height: 14),
                _buildUnavailableProduct(),
                const SizedBox(height: 14),
                _buildProduct(
                  name: 'Chacarero',
                  description: 'Carne, tomate, porotos verdes y ají verde.',
                  price: 7490,
                  image: 'assets/images/churrasco_italiano.jpg',
                ),
                const SizedBox(height: 14),
                _buildProduct(
                  name: 'Aliado',
                  description: 'Jamón y queso caliente en pan tostado.',
                  price: 4990,
                  image: 'assets/images/barros_luco.jpeg',
                ),
              ],

              if (selectedCategory == 'Combos') ...[
                _buildProduct(
                  name: 'Combo Doble Carne',
                  description: 'Doble Carne acompañada de papas y bebida.',
                  price: 11990,
                  image: 'assets/images/churrasco_italiano.jpg',
                ),
                const SizedBox(height: 14),
                _buildProduct(
                  name: 'Combo Barros Luco',
                  description: 'Barros Luco acompañado de papas y bebida.',
                  price: 10990,
                  image: 'assets/images/barros_luco.jpeg',
                ),
              ],

              if (selectedCategory == 'Bebidas') ...[
                _buildProduct(
                  name: 'Coca-Cola',
                  description: 'Bebida Coca-Cola individual.',
                  price: 1990,
                  image: 'assets/images/coca_cola.jpeg',
                ),
                const SizedBox(height: 14),
                _buildProduct(
                  name: 'Fanta',
                  description: 'Bebida Fanta individual.',
                  price: 1990,
                  image: 'assets/images/fanta.jpeg',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    const categories = ['Sandwich', 'Combos', 'Bebidas'];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedCategory == category;

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? primaryBlue : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProduct({
    required String name,
    required String description,
    required int price,
    required String image,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        _openProduct(
          name: name,
          image: image,
          description: description,
          price: price,
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE4E4E4)),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(13),
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
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${_formatPrice(price)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 115,
              height: double.infinity,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableProduct() {
    return Opacity(
      opacity: 0.45,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4E4E4)),
        ),
        padding: const EdgeInsets.all(14),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Italiana',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Producto no disponible temporalmente.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Spacer(),
                  Text(
                    'No disponible',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Icon(Icons.block, size: 38, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Tu pedido contiene $cartQuantity '
                    'producto${cartQuantity == 1 ? '' : 's'}',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.white,
                  child: Text(
                    '$cartQuantity',
                    style: const TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  'Ver pedido',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_formatPrice(cartTotal)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
