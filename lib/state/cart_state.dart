class CartState {
  CartState._();

  static final List<Map<String, dynamic>> items = [];

  static final Map<String, int> offerQuantities = {
    'Tiramisú': 0,
    'Coca-Cola': 0,
    'Sprite': 0,
  };

  static bool get isEmpty {
    return items.isEmpty &&
        offerQuantities.values.every((quantity) => quantity == 0);
  }

  static int get quantity {
    final productQuantity = items.fold<int>(
      0,
      (sum, item) => sum + ((item['quantity'] ?? 0) as int),
    );

    final offerQuantity = offerQuantities.values.fold<int>(
      0,
      (sum, quantity) => sum + quantity,
    );

    return productQuantity + offerQuantity;
  }

  static int get total {
    final productTotal = items.fold<int>(
      0,
      (sum, item) => sum + ((item['total'] ?? 0) as int),
    );

    final offersTotal =
        (offerQuantities['Tiramisú'] ?? 0) * 6990 +
        (offerQuantities['Coca-Cola'] ?? 0) * 1200 +
        (offerQuantities['Sprite'] ?? 0) * 1200;

    return productTotal + offersTotal;
  }

  static void addProduct(Map<String, dynamic> product) {
    items.add({
      'name': product['name'] ?? 'Producto',
      'image': product['image'] ?? '',
      'description': product['description'] ?? '',
      'restaurant': product['restaurant'] ?? 'FoodPlease',
      'unitPrice': product['unitPrice'] ?? 0,
      'quantity': product['quantity'] ?? 1,
      'total': product['total'] ?? 0,
    });
  }

  static void increaseProductQuantity(int index) {
    final item = items[index];

    final int quantity = (item['quantity'] ?? 1) as int;
    final int unitPrice = (item['unitPrice'] ?? 0) as int;

    item['quantity'] = quantity + 1;
    item['total'] = (quantity + 1) * unitPrice;
  }

  static void decreaseProductQuantity(int index) {
    final item = items[index];

    final int quantity = (item['quantity'] ?? 1) as int;
    final int unitPrice = (item['unitPrice'] ?? 0) as int;

    if (quantity <= 1) {
      items.removeAt(index);
    } else {
      item['quantity'] = quantity - 1;
      item['total'] = (quantity - 1) * unitPrice;
    }
  }

  static void increaseOffer(String name) {
    offerQuantities[name] = (offerQuantities[name] ?? 0) + 1;
  }

  static void decreaseOffer(String name) {
    final currentQuantity = offerQuantities[name] ?? 0;

    if (currentQuantity > 0) {
      offerQuantities[name] = currentQuantity - 1;
    }
  }

  static void clear() {
    items.clear();

    for (final key in offerQuantities.keys) {
      offerQuantities[key] = 0;
    }
  }
}
