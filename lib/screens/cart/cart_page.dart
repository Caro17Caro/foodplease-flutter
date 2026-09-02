import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../state/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  bool isLoading = true;

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

  int get cartQuantity => CartState.quantity;
  int get cartTotal => CartState.total;

  void _increaseQuantity(int index) {
    setState(() {
      CartState.increaseProductQuantity(index);
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      CartState.decreaseProductQuantity(index);
    });
  }

  void _increaseOffer(String name) {
    setState(() {
      CartState.increaseOffer(name);
    });
  }

  void _decreaseOffer(String name) {
    setState(() {
      CartState.decreaseOffer(name);
    });
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goBack();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: isLoading
              ? _buildSkeleton()
              : CartState.items.isEmpty
              ? _buildEmptyCart()
              : _buildCart(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          const Expanded(
            child: Text(
              'Carrito de compra',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ARTÍCULOS'),
                  Text('DESCRIPCIÓN'),
                  Text('PRECIO'),
                ],
              ),
              const SizedBox(height: 20),
              _skeletonProduct(),
              const SizedBox(height: 28),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Ofertas para ti',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              _skeletonProduct(),
              const SizedBox(height: 16),
              _skeletonProduct(),
              const SizedBox(height: 16),
              _skeletonProduct(),
              const SizedBox(height: 30),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _skeletonProduct() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeletonLine(140),
              const SizedBox(height: 9),
              _skeletonLine(100),
              const SizedBox(height: 9),
              _skeletonLine(160),
              const SizedBox(height: 9),
              _skeletonLine(80),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _skeletonLine(55),
      ],
    );
  }

  Widget _skeletonLine(double width) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildCart() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('ARTÍCULOS', style: TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    child: Text('DESCRIPCIÓN', style: TextStyle(fontSize: 12)),
                  ),
                  Text('PRECIO', style: TextStyle(fontSize: 12)),
                ],
              ),

              const SizedBox(height: 18),

              ...List.generate(
                CartState.items.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _buildCartItem(index),
                ),
              ),

              const Divider(),

              const SizedBox(height: 16),

              const Text(
                'Ofertas para ti',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 18),

              _buildOffer(
                name: 'Tiramisú',
                description: 'Exquisito postre italiano',
                price: 6990,
                image: 'assets/images/pizza_burrata.jpeg',
              ),

              const SizedBox(height: 16),

              _buildOffer(
                name: 'Coca-Cola',
                description: 'Lata 350 ml',
                price: 1200,
                image: 'assets/images/coca_cola.jpeg',
              ),

              const SizedBox(height: 16),

              _buildOffer(
                name: 'Sprite',
                description: 'Lata 350 ml',
                price: 1200,
                image: 'assets/images/sprite-350-ml.png',
              ),

              const SizedBox(height: 26),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal ($cartQuantity)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'CLP ${_formatPrice(cartTotal)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.checkout);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Finalizar compra',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(int index) {
    final item = CartState.items[index];

    final String name = item['name'] ?? 'Producto';

    final String image =
        item['image'] ?? 'assets/images/churrasco_italiano.jpg';

    final String description = item['description'] ?? '';

    final String restaurant = item['restaurant'] ?? 'FoodPlease';

    final int quantity = item['quantity'] ?? 1;

    final int total = item['total'] ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.asset(image, width: 82, height: 82, fit: BoxFit.cover),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),

              const SizedBox(height: 4),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Text('Cantidad:', style: TextStyle(fontSize: 13)),

                  const SizedBox(width: 8),

                  _quantityControl(
                    icon: Icons.remove,
                    onTap: () {
                      _decreaseQuantity(index);
                    },
                  ),

                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '$quantity',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  _quantityControl(
                    icon: Icons.add,
                    onTap: () {
                      _increaseQuantity(index);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Text(
          '\$${_formatPrice(total)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _quantityControl({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildOffer({
    required String name,
    required String description,
    required int price,
    required String image,
  }) {
    final int quantity = CartState.offerQuantities[name] ?? 0;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(image, width: 76, height: 76, fit: BoxFit.cover),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(height: 4),

              Text(
                description,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),

              const SizedBox(height: 7),

              Row(
                children: [
                  const Text('Cantidad:', style: TextStyle(fontSize: 13)),

                  const SizedBox(width: 8),

                  _quantityControl(
                    icon: Icons.remove,
                    onTap: () {
                      _decreaseOffer(name);
                    },
                  ),

                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      '$quantity',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  _quantityControl(
                    icon: Icons.add,
                    onTap: () {
                      _increaseOffer(name);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        Text(
          '\$${_formatPrice(price)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Column(
      children: [
        _buildHeader(),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 120,
                  color: primaryBlue,
                ),

                const SizedBox(height: 32),

                const Text(
                  'Agrega artículos para comenzar a\nllenar un carrito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 44),

                const Text(
                  'Cuando agregues artículos de un restaurante, '
                  'tu carrito aparecerá aquí',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, height: 1.4),
                ),

                const SizedBox(height: 42),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _goBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Agregar productos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
