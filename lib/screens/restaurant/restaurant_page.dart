import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../state/cart_state.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  bool isLoading = true;
  bool initializedFromArguments = false;

  String restaurantName = 'La Casa de la Hamburguesa';
  String restaurantImage =
      'assets/images/restaurante_la_casa_de_la_hamburguesa.jpeg';
  String restaurantRating = '4.9';
  String restaurantTime = '25-35 min';
  String restaurantDescription = 'Hamburguesas • Sandwich • Comida rápida';

  String selectedCategory = 'Sandwich';

  List<String> categories = ['Sandwich', 'Combos', 'Bebidas'];

  Map<String, List<Map<String, dynamic>>> productsByCategory = {};

  int get cartQuantity => CartState.quantity;
  int get cartTotal => CartState.total;

  @override
  void initState() {
    super.initState();

    _configureHamburgerRestaurant();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initializedFromArguments) {
      return;
    }

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      final restaurant = arguments['restaurant'];

      if (restaurant is String) {
        _configureRestaurant(restaurant);
      }

      final addedProduct = arguments['addedProduct'];

      if (addedProduct is Map) {
        CartState.addProduct(Map<String, dynamic>.from(addedProduct));
      }
    }

    initializedFromArguments = true;
  }

  void _configureRestaurant(String restaurant) {
    switch (restaurant) {
      case 'Pizzería Napoli':
        _configurePizzaRestaurant();
        break;

      case 'El Maestro del Completo':
        _configureCompletoRestaurant();
        break;

      case 'FoodPlease Bebidas':
        _configureBeverageRestaurant();
        break;

      case 'La Casa de la Hamburguesa':
      default:
        _configureHamburgerRestaurant();
        break;
    }
  }

  void _configureHamburgerRestaurant() {
    restaurantName = 'La Casa de la Hamburguesa';
    restaurantImage =
        'assets/images/restaurante_la_casa_de_la_hamburguesa.jpeg';
    restaurantRating = '4.9';
    restaurantTime = '25-35 min';
    restaurantDescription = 'Hamburguesas • Sandwich • Comida rápida';

    categories = ['Sandwich', 'Combos', 'Bebidas'];

    selectedCategory = 'Sandwich';

    productsByCategory = {
      'Sandwich': [
        {
          'name': 'Doble Carne',
          'description':
              'Hamburguesa doble carne, queso, tomate y salsa especial.',
          'price': 8990,
          'image': 'assets/images/doble_carne.jpeg',
        },
        {
          'name': 'Barros Luco',
          'description': 'Carne a la plancha con abundante queso fundido.',
          'price': 7990,
          'image': 'assets/images/barros_luco.jpeg',
        },
        {
          'name': 'Italiana',
          'description': 'Producto no disponible temporalmente.',
          'price': 0,
          'image': '',
          'available': false,
        },
        {
          'name': 'Chacarero',
          'description': 'Carne, tomate, porotos verdes y ají verde.',
          'price': 7490,
          'image': 'assets/images/chacarero.jpeg',
        },
        {
          'name': 'Aliado',
          'description': 'Jamón y queso caliente en pan tostado.',
          'price': 4990,
          'image': 'assets/images/aliado.jpeg',
        },
      ],
      'Combos': [
        {
          'name': 'Combo Doble Carne',
          'description': 'Doble Carne acompañada de papas y bebida.',
          'price': 11990,
          'image': 'assets/images/combo_doble_carne.jpeg',
        },
        {
          'name': 'Combo Barros Luco',
          'description': 'Barros Luco acompañado de papas y bebida.',
          'price': 10990,
          'image': 'assets/images/combo_barros_luco.jpeg',
        },
      ],
      'Bebidas': [
        {
          'name': 'Coca-Cola',
          'description': 'Bebida Coca-Cola individual.',
          'price': 1990,
          'image': 'assets/images/coca_cola_clean.jpeg',
        },
        {
          'name': 'Fanta',
          'description': 'Bebida Fanta individual.',
          'price': 1990,
          'image': 'assets/images/fanta.jpeg',
        },
      ],
    };
  }

  void _configurePizzaRestaurant() {
    restaurantName = 'Pizzería Napoli';
    restaurantImage = 'assets/images/restaurante_pizzeria_napoli.jpeg';
    restaurantRating = '4.8';
    restaurantTime = '30-40 min';
    restaurantDescription = 'Pizzas • Cocina italiana • Artesanal';

    categories = ['Pizzas', 'Bebidas'];

    selectedCategory = 'Pizzas';

    productsByCategory = {
      'Pizzas': [
        {
          'name': 'Pizza Burrata - Pesto',
          'description': 'Pizza con burrata, pesto, tomate y masa artesanal.',
          'price': 10990,
          'image': 'assets/images/pizza_burrata.jpeg',
        },
        {
          'name': 'Pizza Carbonara',
          'description': 'Pizza cremosa estilo carbonara con queso y tocino.',
          'price': 11990,
          'image': 'assets/images/pizza_carbonara.jpeg',
        },
        {
          'name': 'Pizza Napolitana Pesto',
          'description': 'Pizza napolitana con tomate, queso y pesto.',
          'price': 9990,
          'image': 'assets/images/pizza_napolitana_pesto.jpeg',
        },
      ],
      'Bebidas': [
        {
          'name': 'Coca-Cola',
          'description': 'Bebida Coca-Cola individual.',
          'price': 1990,
          'image': 'assets/images/coca_cola_clean.jpeg',
        },
        {
          'name': 'Sprite',
          'description': 'Bebida Sprite individual.',
          'price': 1990,
          'image': 'assets/images/sprite.jpeg',
        },
      ],
    };
  }

  void _configureCompletoRestaurant() {
    restaurantName = 'El Maestro del Completo';
    restaurantImage = 'assets/images/restaurante_maestro_completo.jpeg';
    restaurantRating = '4.7';
    restaurantTime = '20-30 min';
    restaurantDescription = 'Completos • Sandwich • Comida rápida';

    categories = ['Completos', 'Bebidas'];

    selectedCategory = 'Completos';

    productsByCategory = {
      'Completos': [
        {
          'name': 'Completo Italiano',
          'description': 'Completo con tomate, palta, mayonesa y salchicha.',
          'price': 4990,
          'image': 'assets/images/completo_italiano.jpeg',
        },
        {
          'name': 'Completo Dinámico',
          'description': 'Completo con tomate, palta, chucrut, salsa americana y mayonesa.',
          'price': 5490,
          'image': 'assets/images/completo_dinamico.jpeg',
        },
      ],
      'Bebidas': [
        {
          'name': 'Coca-Cola',
          'description': 'Bebida Coca-Cola individual.',
          'price': 1990,
          'image': 'assets/images/coca_cola_clean.jpeg',
        },
        {
          'name': 'Fanta',
          'description': 'Bebida Fanta individual.',
          'price': 1990,
          'image': 'assets/images/fanta.jpeg',
        },
      ],
    };
  }

  void _configureBeverageRestaurant() {
    restaurantName = 'FoodPlease Bebidas';
    restaurantImage = 'assets/images/coca_cola_clean.jpeg';
    restaurantRating = '4.8';
    restaurantTime = '15-25 min';
    restaurantDescription = 'Bebidas • Refrescos';

    categories = ['Bebidas'];

    selectedCategory = 'Bebidas';

    productsByCategory = {
      'Bebidas': [
        {
          'name': 'Coca-Cola',
          'description': 'Bebida Coca-Cola individual.',
          'price': 1990,
          'image': 'assets/images/coca_cola_clean.jpeg',
        },
        {
          'name': 'Fanta',
          'description': 'Bebida Fanta individual.',
          'price': 1990,
          'image': 'assets/images/fanta.jpeg',
        },
        {
          'name': 'Sprite',
          'description': 'Bebida Sprite individual.',
          'price': 1990,
          'image': 'assets/images/sprite.jpeg',
        },
      ],
    };
  }

  int _getBaseProductQuantity({required String name}) {
    return CartState.getBaseProductQuantity(
      name: name,
      restaurant: restaurantName,
    );
  }

  void _addBaseProduct({
    required String name,
    required String image,
    required String description,
    required int price,
  }) {
    setState(() {
      CartState.addBaseProduct(
        name: name,
        image: image,
        description: description,
        restaurant: restaurantName,
        unitPrice: price,
      );
    });
  }

  void _increaseBaseProduct({required String name}) {
    setState(() {
      CartState.increaseBaseProduct(name: name, restaurant: restaurantName);
    });
  }

  void _decreaseBaseProduct({required String name}) {
    setState(() {
      CartState.decreaseBaseProduct(name: name, restaurant: restaurantName);
    });
  }

  Future<void> _openProduct({
    required String name,
    required String image,
    required String description,
    required int price,
  }) async {
    final bool allowExtras =
        selectedCategory != 'Bebidas' && selectedCategory != 'Pizzas';

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: {
        'name': name,
        'image': image,
        'description': description,
        'price': price,
        'restaurant': restaurantName,
        'allowExtras': allowExtras,
      },
    );

    if (!mounted) {
      return;
    }

    if (result is Map<String, dynamic>) {
      final productResult = Map<String, dynamic>.from(result);

      final int resultUnitPrice = (productResult['unitPrice'] ?? 0) as int;

      final int resultQuantity = (productResult['quantity'] ?? 1) as int;

      final bool isBaseProduct = resultUnitPrice == price;

      if (isBaseProduct) {
        setState(() {
          for (int i = 0; i < resultQuantity; i++) {
            CartState.addBaseProduct(
              name: name,
              image: image,
              description: description,
              restaurant: restaurantName,
              unitPrice: price,
            );
          }
        });
      } else {
        productResult['isBaseProduct'] = false;

        setState(() {
          CartState.addProduct(productResult);
        });
      }
    }
  }

  Future<void> _openCart() async {
    await Navigator.pushNamed(context, AppRoutes.cart);

    if (mounted) {
      setState(() {});
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
      height: 130,
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
    final currentProducts = productsByCategory[selectedCategory] ?? [];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.asset(
                restaurantImage,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
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
              Text(
                restaurantName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202124),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 19),

                  const SizedBox(width: 4),

                  Text(
                    restaurantRating,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(width: 14),

                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: Colors.black54,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    restaurantTime,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                restaurantDescription,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
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

              ...currentProducts.asMap().entries.map((entry) {
                final product = entry.value;

                final bool available = product['available'] ?? true;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == currentProducts.length - 1 ? 0 : 14,
                  ),
                  child: available
                      ? _buildProduct(
                          name: product['name'],
                          description: product['description'],
                          price: product['price'],
                          image: product['image'],
                        )
                      : _buildUnavailableProduct(
                          name: product['name'],
                          description: product['description'],
                        ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
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
    final int quantity = _getBaseProductQuantity(name: name);

    return Container(
      height: 132,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E4E4)),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _openProduct(
                    name: name,
                    image: image,
                    description: description,
                    price: price,
                  );
                },
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 115,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 8,
            bottom: 8,
            child: _buildQuickAddControl(
              quantity: quantity,
              onAdd: () {
                _addBaseProduct(
                  name: name,
                  image: image,
                  description: description,
                  price: price,
                );
              },
              onIncrease: () {
                _increaseBaseProduct(name: name);
              },
              onDecrease: () {
                _decreaseBaseProduct(name: name);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddControl({
    required int quantity,
    required VoidCallback onAdd,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    if (quantity <= 0) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.add, size: 21, color: Colors.white),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryBlue),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onDecrease,
              borderRadius: BorderRadius.circular(18),
              child: const SizedBox(
                width: 28,
                height: 34,
                child: Icon(Icons.remove, size: 18, color: primaryBlue),
              ),
            ),

            SizedBox(
              width: 25,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF303030),
                ),
              ),
            ),

            InkWell(
              onTap: onIncrease,
              borderRadius: BorderRadius.circular(18),
              child: const SizedBox(
                width: 28,
                height: 34,
                child: Icon(Icons.add, size: 18, color: primaryBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableProduct({
    required String name,
    required String description,
  }) {
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
        child: Row(
          children: [
            Expanded(
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

                  const SizedBox(height: 7),

                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54),
                  ),

                  const Spacer(),

                  const Text(
                    'No disponible',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const Icon(Icons.block, size: 38, color: Colors.black38),
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
            onPressed: _openCart,
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
