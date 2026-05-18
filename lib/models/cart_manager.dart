import '../models/food_item.dart';
import 'cart_item.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  void addToCart(FoodItem food, int quantity) {
    for (var item in _items) {
      if (item.food.id == food.id) {
        item.quantity += quantity;
        return;
      }
    }
    _items.add(CartItem(food: food, quantity: quantity));
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
    }
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  void clearCart() => _items.clear();

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }
}