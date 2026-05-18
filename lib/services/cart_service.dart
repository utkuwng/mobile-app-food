class CartService {

  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<Map<String, dynamic>> _cartItems = [];


  List<Map<String, dynamic>> get cartItems => _cartItems;


  int get totalItems {
    int total = 0;
    for (var item in _cartItems) {
      total += item['quantity'] as int;
    }
    return total;
  }


  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    return total;
  }

  void addItem(String title, double price, {int quantity = 1}) {

    int existingIndex = -1;
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i]['title'] == title) {
        existingIndex = i;
        break;
      }
    }

    if (existingIndex >= 0) {

      _cartItems[existingIndex]['quantity'] =
          (_cartItems[existingIndex]['quantity'] as int) + quantity;
    } else {

      _cartItems.add({
        'title': title,
        'price': price,
        'quantity': quantity,
      });
    }
  }


  void increaseQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index]['quantity'] =
          (_cartItems[index]['quantity'] as int) + 1;
    }
  }

  void decreaseQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      int currentQuantity = _cartItems[index]['quantity'] as int;
      if (currentQuantity > 1) {
        _cartItems[index]['quantity'] = currentQuantity - 1;
      } else {

        removeItem(index);
      }
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  void clearCart() {
    _cartItems.clear();
  }
}

