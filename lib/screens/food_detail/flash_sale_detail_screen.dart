import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/food_item.dart';
import '../../models/cart_manager.dart';
import '../../models/cart_item.dart';
import '../cart/cart_screen.dart';
import 'delivery_flash_sale.dart';
import '../../reviews/reviews_screen.dart';
import '../../data/data_manager.dart';
import 'pickup_flash_sale_screen.dart';
import '../../data/restaurant_data.dart';
import '../../models/restaurant_item.dart';
import 'suggested_restaurant.dart';

class FlashSaleDetailScreen extends StatefulWidget {
  final FoodItem item;
  final Duration initialTimeLeft;

  const FlashSaleDetailScreen({
    super.key,
    required this.item,
    required this.initialTimeLeft,
  });

  @override
  State<FlashSaleDetailScreen> createState() => _FlashSaleDetailScreenState();
}

class _FlashSaleDetailScreenState extends State<FlashSaleDetailScreen> {
  late Timer _timer;
  late Duration _timeLeft;
  int _quantity = 1;

  double get _discountedPrice {
    if (widget.item.salePercentage != null && widget.item.salePercentage! > 0) {
      return widget.item.price * (1 - widget.item.salePercentage! / 100);
    }
    return widget.item.price;
  }

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.initialTimeLeft;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _timeLeft -= const Duration(seconds: 1);
          });
        }
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatVND(double price) {
    return "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(duration.inHours);
    final m = twoDigits(duration.inMinutes.remainder(60));
    final s = twoDigits(duration.inSeconds.remainder(60));
    return "$h:$m:$s";
  }

  void _toggleFavorite() {
    setState(() {
      DataManager().toggleFavorite(widget.item.id);
    });
  }

  void _handleAddToCart() {
    final finalItem = widget.item.copyWith(price: _discountedPrice);
    CartManager().addToCart(finalItem, _quantity);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm $_quantity món vào giỏ!'),
        backgroundColor: const Color(0xFFFEA731),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'XEM GIỎ',
          textColor: Colors.white,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
        ),
      ),
    );
  }

  void _navigateToDelivery() {
    final discountedItem = widget.item.copyWith(price: _discountedPrice);
    final tempCartItem = CartItem(food: discountedItem, quantity: _quantity);
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => DeliveryFlashSaleScreen(
          selectedItems: [tempCartItem],
        )
    ));
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
                    _buildFlashSaleHeader(),
                    _buildTopInfo(context, widget.item),
                    _buildQuantitySelector(),
                    _buildStatsRow(widget.item),
                    _buildActionButtons(context),

                    const SizedBox(height: 24),
                    _buildSuggestedRestaurants(context),
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

  Widget _buildFlashSaleHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFF4081), Color(0xFFFF80AB)]),
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Text("FLASH SALE ĐANG DIỄN RA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
            child: Text(_formatDuration(_timeLeft), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildTopInfo(BuildContext context, FoodItem item) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              if (item.salePercentage != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                  child: Text("-${item.salePercentage}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewsScreen(rating: item.rating, reviewCount: item.reviewCount))),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(" ${item.rating} (${item.reviewCount} đánh giá)", style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                const Text("BITOO Verified", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Số lượng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                IconButton(onPressed: () => setState(() { if(_quantity > 1) _quantity--; }), icon: const Icon(Icons.remove)),
                Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add, color: Colors.pinkAccent)),
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
      pinned: true,
      backgroundColor: Colors.pinkAccent,
      leading: IconButton(
        icon: const CircleAvatar(backgroundColor: Colors.black26, child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.black26,
            child: Icon(widget.item.isFavorite ? Icons.favorite : Icons.favorite_border, color: widget.item.isFavorite ? Colors.red : Colors.white),
          ),
          onPressed: _toggleFavorite,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(background: Image.asset(imageUrl, fit: BoxFit.cover)),
    );
  }

  Widget _buildStatsRow(FoodItem item) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem("Giá gốc", formatVND(item.price)),
          _statItem("Khoảng cách", item.description.split('•')[0]),
          _statItem("Giao trong", item.deliveryTime),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: () => _navigateToDelivery(),
                  icon: const Icon(Icons.delivery_dining),
                  label: const Text("Giao hàng")
              )
          ),
          const SizedBox(width: 10),
          Expanded(
              child: ElevatedButton.icon(
                  onPressed: () {
                    final discountedItem = widget.item.copyWith(price: _discountedPrice);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => PickupFlashSaleScreen(
                            item: discountedItem,
                            quantity: _quantity
                        )
                    ));
                  },
                  icon: const Icon(Icons.store),
                  label: const Text("Đến lấy"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white
                  )
              )
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedRestaurants(BuildContext context) {
    final restaurants = RestaurantDataManager().allRestaurants.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(width: 4, height: 24, decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              const Text("Có thể bạn sẽ thích", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final res = restaurants[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SuggestedRestaurantScreen(
                    restaurantName: res.name,
                    restaurantMenu: res.menu,
                    initRating: res.rating,
                    initTime: res.deliveryTime,
                    initDistance: "${res.distance}km",
                  )));
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(res.imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(res.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Row(children: [
                              const Icon(Icons.star, size: 12, color: Colors.amber),
                              Text(" ${res.rating}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(res.deliveryTime, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ]),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text("Giảm 30%", style: const TextStyle(color: Colors.pinkAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )
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

  Widget _buildOrderBar(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatVND(_discountedPrice * _quantity), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                  Text("Tiết kiệm: ${formatVND((widget.item.price - _discountedPrice) * _quantity)}", style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _handleAddToCart,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.all(15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Icon(Icons.add_shopping_cart, color: Colors.white),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _navigateToDelivery(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("Giao hàng", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}