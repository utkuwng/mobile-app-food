import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/food_item.dart';
import '../../models/cart_manager.dart';
import '../../models/cart_item.dart';
import '../cart/cart_screen.dart';
import 'delivery_flash_sale.dart';
import 'pickup_flash_sale_screen.dart';
import '../../reviews/reviews_screen.dart';
import '../../data/data_manager.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem item;
  final List<FoodItem> relatedItems;

  const FoodDetailScreen({
    super.key,
    required this.item,
    required this.relatedItems,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;

  double get _finalPrice {
    if (widget.item.salePercentage != null && widget.item.salePercentage! > 0) {
      return widget.item.price * (1 - widget.item.salePercentage! / 100);
    }
    return widget.item.price;
  }

  String formatVND(double price) {
    return "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";
  }

  void _shareItem() async {
    final String textToShare = 'Thử xem qua món ${widget.item.name} trên ứng dụng BITOO nhé!';
    try {
      await Share.share(textToShare);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể chia sẻ lúc này.')),
        );
      }
    }
  }

  void _toggleFavorite() {
    setState(() {
      DataManager().toggleFavorite(widget.item.id);
    });
  }

  void _incrementQuantity() => setState(() => _quantity++);
  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _handleAddToCart() {
    final itemWithPrice = widget.item.copyWith(price: _finalPrice);
    CartManager().addToCart(itemWithPrice, _quantity);

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text('Đã thêm $_quantity món vào giỏ hàng!'),
        backgroundColor: const Color(0xFFFEA731),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 95, left: 15, right: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        action: SnackBarAction(
          label: 'XEM GIỎ',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, widget.item.imageUrl),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopInfo(context, widget.item),
                    _buildQuantitySelector(),
                    _buildStatsRow(widget.item),
                    _buildActionButtons(context),
                    _buildMostPopularSection(context, widget.relatedItems),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildOrderBar(context),
        ],
      ),
    );
  }


  Widget _buildTopInfo(BuildContext context, FoodItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              if (item.salePercentage != null && item.salePercentage! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                  child: Text("-${item.salePercentage}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewsScreen(rating: item.rating, reviewCount: item.reviewCount)));
            },
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(item.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 4),
                Text('(${item.reviewCount} đánh giá)', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Chọn số lượng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Container(
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                IconButton(onPressed: _decrementQuantity, icon: const Icon(Icons.remove)),
                Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: _incrementQuantity, icon: const Icon(Icons.add, color: Colors.pinkAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String imageUrl) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: false,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: Icon(
                      widget.item.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.item.isFavorite ? Colors.redAccent : Colors.white,
                      size: 20
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white, size: 20),
                  onPressed: _shareItem,
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(background: Image.asset(imageUrl, fit: BoxFit.cover)),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
              child: OutlinedButton.icon(
                  icon: const Icon(Icons.two_wheeler, color: Colors.blue),
                  label: const Text('Giao hàng', style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    final itemWithPrice = widget.item.copyWith(price: _finalPrice);
                    final tempCartItem = CartItem(food: itemWithPrice, quantity: _quantity);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryFlashSaleScreen(selectedItems: [tempCartItem])));
                  },
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
              )
          ),
          const SizedBox(width: 10),
          Expanded(
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  label: const Text('Đến lấy', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    final itemWithPrice = widget.item.copyWith(price: _finalPrice);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PickupFlashSaleScreen(item: itemWithPrice, quantity: _quantity)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
              )
          ),
        ],
      ),
    );
  }

  Widget _buildOrderBar(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatVND(_finalPrice * _quantity), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text('Tổng tiền', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _handleAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Icon(Icons.add_shopping_cart, color: Colors.white),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final itemWithPrice = widget.item.copyWith(price: _finalPrice);
                  final tempCartItem = CartItem(food: itemWithPrice, quantity: _quantity);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryFlashSaleScreen(selectedItems: [tempCartItem])));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Giao hàng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(FoodItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('Giá', formatVND(item.price), Colors.black),
          _buildStatItem('Khoảng cách', item.description.split('•')[0], Colors.black),
          _buildStatItem('Thời gian', item.deliveryTime, Colors.black),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMostPopularSection(BuildContext context, List<FoodItem> popularItems) {
    final filteredItems = popularItems.where((i) => i.id != widget.item.id).take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(left: 20, bottom: 10), child: Text('Các món ăn phổ biến khác', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item, relatedItems: popularItems)));
                },
                child: Container(
                  width: 140, margin: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(item.imageUrl, height: 100, width: 140, fit: BoxFit.cover)),
                      const SizedBox(height: 5),
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                      Text(formatVND(item.price), style: const TextStyle(color: Colors.pinkAccent)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}