import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  static const Color primaryBlue = Color(0xFF29ABE2);

  bool isLoading = true;
  bool extraCheese = false;
  bool extraBacon = false;
  bool extraSauce = false;
  int quantity = 1;

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
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String name = arguments?['name'] ?? 'Doble Carne';

    final String image =
        arguments?['image'] ?? 'assets/images/churrasco_italiano.jpg';

    final String description =
        arguments?['description'] ??
        'Hamburguesa doble carne, queso, tomate y salsa especial.';

    final int basePrice = arguments?['price'] ?? 8990;

    final String restaurant = arguments?['restaurant'] ?? 'FoodPlease';

    final bool allowExtras = arguments?['allowExtras'] ?? true;

    final int extrasPrice = allowExtras
        ? (extraCheese ? 1000 : 0) +
              (extraBacon ? 1200 : 0) +
              (extraSauce ? 500 : 0)
        : 0;

    final int total = (basePrice + extrasPrice) * quantity;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? _buildSkeleton()
            : _buildContent(
                name: name,
                image: image,
                description: description,
                restaurant: restaurant,
                basePrice: basePrice,
                extrasPrice: extrasPrice,
                total: total,
                allowExtras: allowExtras,
              ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(height: 300, color: const Color(0xFFE8E8E8)),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeletonBox(width: 220, height: 26),
              const SizedBox(height: 14),
              _skeletonBox(width: 110, height: 20),
              const SizedBox(height: 24),
              _skeletonBox(width: double.infinity, height: 16),
              const SizedBox(height: 8),
              _skeletonBox(width: 280, height: 16),
              const SizedBox(height: 32),
              _skeletonBox(width: 180, height: 22),
              const SizedBox(height: 18),
              _skeletonBox(width: double.infinity, height: 55),
              const SizedBox(height: 12),
              _skeletonBox(width: double.infinity, height: 55),
              const SizedBox(height: 12),
              _skeletonBox(width: double.infinity, height: 55),
            ],
          ),
        ),
      ],
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

  Widget _buildContent({
    required String name,
    required String image,
    required String description,
    required String restaurant,
    required int basePrice,
    required int extrasPrice,
    required int total,
    required bool allowExtras,
  }) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(image, fit: BoxFit.cover),
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202124),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '\$${_formatPrice(basePrice)}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),

                    if (allowExtras) ...[
                      const SizedBox(height: 30),

                      const Text(
                        'Agrega extras',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Personaliza tu pedido',
                        style: TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 14),

                      _buildExtra(
                        title: 'Queso extra',
                        price: 1000,
                        value: extraCheese,
                        onChanged: (value) {
                          setState(() {
                            extraCheese = value ?? false;
                          });
                        },
                      ),

                      _buildExtra(
                        title: 'Tocino',
                        price: 1200,
                        value: extraBacon,
                        onChanged: (value) {
                          setState(() {
                            extraBacon = value ?? false;
                          });
                        },
                      ),

                      _buildExtra(
                        title: 'Salsa especial',
                        price: 500,
                        value: extraSauce,
                        onChanged: (value) {
                          setState(() {
                            extraSauce = value ?? false;
                          });
                        },
                      ),
                    ],

                    const SizedBox(height: 24),

                    const Text(
                      'Cantidad',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        _quantityButton(
                          icon: Icons.remove,
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              : null,
                        ),
                        SizedBox(
                          width: 55,
                          child: Text(
                            '$quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _quantityButton(
                          icon: Icons.add,
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),

        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': name,
                    'image': image,
                    'description': description,
                    'restaurant': restaurant,
                    'unitPrice': basePrice + extrasPrice,
                    'quantity': quantity,
                    'total': total,
                  });
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
                    const Text(
                      'Agregar al pedido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_formatPrice(total)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExtra({
    required String title,
    required int price,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: primaryBlue,
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        '+ \$${_formatPrice(price)}',
        style: const TextStyle(color: Colors.black54),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 42,
      height: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue),
        ),
        child: Icon(icon),
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
