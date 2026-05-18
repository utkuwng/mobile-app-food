import 'package:flutter/material.dart';
import '../../models/cart_manager.dart';
import '../food_detail/delivery_flash_sale.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cart = CartManager();
  final Color primaryPink = const Color(0xFFFF3B77);

  String formatVND(double price) {
    return "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";
  }


  Map<String, List<CartItem>> _getGroupedItems() {
    Map<String, List<CartItem>> grouped = {};
    for (var item in cart.items) {

      String restaurant = item.food.restaurantName ?? "Nhà hàng đối tác";
      if (!grouped.containsKey(restaurant)) {
        grouped[restaurant] = [];
      }
      grouped[restaurant]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = _getGroupedItems();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Giỏ hàng",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart()
          : Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text("Nhấn vào nhóm nhà hàng để thanh toán tất cả món",
                style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: groupedItems.keys.length,
              itemBuilder: (context, index) {
                String restaurantName = groupedItems.keys.elementAt(index);
                List<CartItem> itemsInRes = groupedItems[restaurantName]!;
                return _buildRestaurantGroup(restaurantName, itemsInRes);
              },
            ),
          ),
          _buildTotalSection(),
        ],
      ),
    );
  }


  Widget _buildRestaurantGroup(String name, List<CartItem> items) {
    double resTotal = items.fold(0, (sum, item) => sum + (item.food.price * item.quantity));

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [

          InkWell(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeliveryFlashSaleScreen(selectedItems: items),
                ),
              );
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryPink.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.storefront, color: Colors.pinkAccent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(formatVND(resTotal),
                      style: TextStyle(color: primaryPink, fontWeight: FontWeight.bold)),
                  const Icon(Icons.chevron_right, color: Colors.pinkAccent),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: items.map((item) => _buildMiniCartItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMiniCartItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.food.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.food.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text("${item.quantity} x ${formatVND(item.food.price)}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
            onPressed: () {
              setState(() {

                int idx = cart.items.indexOf(item);
                cart.removeItem(idx);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Giỏ hàng trống", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Tổng tất cả:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(formatVND(cart.totalAmount),
              style: TextStyle(fontSize: 22, color: primaryPink, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}