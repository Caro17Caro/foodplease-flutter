class CartState {
  CartState._();

  static final List<Map<String, dynamic>> items = [];

  static final Map<String, int> offerQuantities = {'Coca-Cola': 0, 'Sprite': 0};

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
        (offerQuantities['Coca-Cola'] ?? 0) * 1200 +
        (offerQuantities['Sprite'] ?? 0) * 1200;

    return productTotal + offersTotal;
  }

  static List<String> _normalizeExtras(dynamic rawExtras) {
    if (rawExtras is! List) {
      return <String>[];
    }

    final extras = rawExtras
        .map((extra) => extra.toString().trim())
        .where((extra) => extra.isNotEmpty)
        .toList();

    extras.sort();

    return extras;
  }

  static String _extrasKey(List<String> extras) {
    return extras.join('|');
  }

  static int? _findCustomProductIndex({
    required String name,
    required String restaurant,
    required int unitPrice,
    required List<String> extras,
  }) {
    final extrasKey = _extrasKey(extras);

    final index = items.indexWhere((item) {
      final itemExtras = _normalizeExtras(item['extras']);

      return item['name'] == name &&
          item['restaurant'] == restaurant &&
          item['unitPrice'] == unitPrice &&
          item['isBaseProduct'] == false &&
          _extrasKey(itemExtras) == extrasKey;
    });

    if (index == -1) {
      return null;
    }

    return index;
  }

  static void addProduct(Map<String, dynamic> product) {
    final String name = product['name'] ?? 'Producto';

    final String image = product['image'] ?? '';

    final String description = product['description'] ?? '';

    final String restaurant = product['restaurant'] ?? 'FoodPlease';

    final int unitPrice = (product['unitPrice'] ?? 0) as int;

    final int productQuantity = (product['quantity'] ?? 1) as int;

    final bool isBaseProduct = product['isBaseProduct'] == true;

    if (isBaseProduct) {
      for (int i = 0; i < productQuantity; i++) {
        addBaseProduct(
          name: name,
          image: image,
          description: description,
          restaurant: restaurant,
          unitPrice: unitPrice,
        );
      }

      return;
    }

    final List<String> extras = _normalizeExtras(product['extras']);

    final existingIndex = _findCustomProductIndex(
      name: name,
      restaurant: restaurant,
      unitPrice: unitPrice,
      extras: extras,
    );

    if (existingIndex != null) {
      final item = items[existingIndex];

      final int currentQuantity = (item['quantity'] ?? 1) as int;

      final int newQuantity = currentQuantity + productQuantity;

      item['quantity'] = newQuantity;
      item['total'] = newQuantity * unitPrice;

      return;
    }

    items.add({
      'name': name,
      'image': image,
      'description': description,
      'restaurant': restaurant,
      'unitPrice': unitPrice,
      'quantity': productQuantity,
      'total': unitPrice * productQuantity,
      'extras': extras,
      'isBaseProduct': false,
    });
  }

  static int getBaseProductQuantity({
    required String name,
    required String restaurant,
  }) {
    int totalQuantity = 0;

    for (final item in items) {
      final bool sameProduct =
          item['name'] == name &&
          item['restaurant'] == restaurant &&
          item['isBaseProduct'] == true;

      if (sameProduct) {
        totalQuantity += (item['quantity'] ?? 0) as int;
      }
    }

    return totalQuantity;
  }

  static int? _findBaseProductIndex({
    required String name,
    required String restaurant,
  }) {
    final index = items.indexWhere((item) {
      return item['name'] == name &&
          item['restaurant'] == restaurant &&
          item['isBaseProduct'] == true;
    });

    if (index == -1) {
      return null;
    }

    return index;
  }

  static void addBaseProduct({
    required String name,
    required String image,
    required String description,
    required String restaurant,
    required int unitPrice,
  }) {
    final existingIndex = _findBaseProductIndex(
      name: name,
      restaurant: restaurant,
    );

    if (existingIndex != null) {
      increaseProductQuantity(existingIndex);
      return;
    }

    items.add({
      'name': name,
      'image': image,
      'description': description,
      'restaurant': restaurant,
      'unitPrice': unitPrice,
      'quantity': 1,
      'total': unitPrice,
      'extras': <String>[],
      'isBaseProduct': true,
    });
  }

  static void increaseBaseProduct({
    required String name,
    required String restaurant,
  }) {
    final index = _findBaseProductIndex(name: name, restaurant: restaurant);

    if (index == null) {
      return;
    }

    increaseProductQuantity(index);
  }

  static void decreaseBaseProduct({
    required String name,
    required String restaurant,
  }) {
    final index = _findBaseProductIndex(name: name, restaurant: restaurant);

    if (index == null) {
      return;
    }

    decreaseProductQuantity(index);
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
    if (!offerQuantities.containsKey(name)) {
      return;
    }

    offerQuantities[name] = (offerQuantities[name] ?? 0) + 1;
  }

  static void decreaseOffer(String name) {
    if (!offerQuantities.containsKey(name)) {
      return;
    }

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
