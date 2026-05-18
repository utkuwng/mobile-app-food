import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'delivery_flash_sale.dart';
import 'pickup_flash_sale_screen.dart';
import '../../models/food_item.dart';
import '../../models/cart_item.dart';
import '../../models/cart_manager.dart';
import '../cart/cart_screen.dart';
import '../../data/data_manager.dart';
import '../../models/restaurant_item.dart';
import '../../reviews/reviews_screen.dart';

class SuggestedRestaurantScreen extends StatefulWidget {
  final String restaurantName;
  final List<FoodItem> restaurantMenu;
  final double initRating;
  final String initTime;
  final String initDistance;

  const SuggestedRestaurantScreen({
    super.key,
    required this.restaurantName,
    required this.restaurantMenu,
    // ⭐️ 2. GIÁ TRỊ MẶC ĐỊNH
    this.initRating = 4.5,
    this.initTime = "15-30'",
    this.initDistance = "1.0km",
  });

  @override
  State<SuggestedRestaurantScreen> createState() => _SuggestedRestaurantScreenState();
}

class _SuggestedRestaurantScreenState extends State<SuggestedRestaurantScreen> with SingleTickerProviderStateMixin {
  final Map<String, int> _itemCounts = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final Random _random = Random();

  // 1. CỐ ĐỊNH MÀU HỒNG CAM
  final List<Color> _fixedGradient = [
    const Color(0xFFFF6B9D),
    const Color(0xFFFF8E53)
  ];

  // 2. DANH SÁCH HÌNH NỀN
  final List<String> _bgImagePool = [
    'assets/images/r1.jpg',
    'assets/images/r2.jpg',
    'assets/images/r3.jpg',
    'assets/images/r4.jpg',
    'assets/images/r5.jpg',
    'assets/images/r6.jpg',
    'assets/images/r7.jpg',
    'assets/images/r8.jpg',
    'assets/images/r9.jpg',
    'assets/images/r10.jpg',
    'assets/images/restaurant1.jpg',
    'assets/images/QUANA.jpg',
  ];

  final List<IconData> _iconPool = [
    Icons.restaurant, Icons.lunch_dining, Icons.fastfood, Icons.rice_bowl,
    Icons.local_pizza, Icons.ramen_dining, Icons.kebab_dining, Icons.soup_kitchen
  ];


  Map<String, dynamic> get _currentTheme {
    int hash = widget.restaurantName.hashCode;
    List<Color> gradient = _fixedGradient;
    Color primary = gradient[0];
    String bg = _bgImagePool[hash.abs() % _bgImagePool.length];
    IconData icon = _iconPool[hash.abs() % _iconPool.length];

    return {
      'primaryColor': primary,
      'gradient': gradient,
      'background': bg,
      'icon': icon,
    };
  }

  Color get _primaryColor => _currentTheme['primaryColor'];
  List<Color> get _gradientColors => _currentTheme['gradient'];
  String get _backgroundImage => _currentTheme['background'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    double total = 0.0;
    for (var item in widget.restaurantMenu) {
      int count = _itemCounts[item.name] ?? 0;
      if (count > 0) total += item.price * count;
    }
    return total;
  }

  int get _totalItems => _itemCounts.values.fold(0, (sum, count) => sum + count);

  String formatVND(double price) {
    return "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";
  }

  void _updateItemCount(String itemName, bool isAdding) {
    setState(() {
      int currentCount = _itemCounts[itemName] ?? 0;
      if (isAdding) {
        _itemCounts[itemName] = currentCount + 1;
      } else if (currentCount > 0) {
        _itemCounts[itemName] = currentCount - 1;
      }
    });
  }

  void _handleAddToCart() {
    if (_totalItems == 0) return;

    for (var item in widget.restaurantMenu) {
      int count = _itemCounts[item.name] ?? 0;
      if (count > 0) {
        final itemWithCorrectStore = item.copyWith(
            restaurantName: widget.restaurantName
        );
        CartManager().addToCart(itemWithCorrectStore, count);
      }
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Đã thêm $_totalItems món vào giỏ hàng!'),
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 95, left: 15, right: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'XEM GIỎ',
          textColor: Colors.white,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
        ),
      ),
    );
  }

  void _navigateToDelivery() {
    List<CartItem> selectedItems = [];
    for (var item in widget.restaurantMenu) {
      int qty = _itemCounts[item.name] ?? 0;
      if (qty > 0) {
        final itemWithStore = item.copyWith(restaurantName: widget.restaurantName);
        selectedItems.add(CartItem(food: itemWithStore, quantity: qty));
      }
    }
    if (selectedItems.isEmpty) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => DeliveryFlashSaleScreen(selectedItems: selectedItems)));
  }

  // --- LOGIC YÊU THÍCH ---
  bool get _isFavorite => DataManager().isRestaurantFavorite(widget.restaurantName);

  void _toggleFavorite() {
    final res = RestaurantItem(
      id: widget.restaurantName.hashCode.toString(),
      name: widget.restaurantName,
      imageUrl: _backgroundImage,
      rating: widget.initRating,
      reviewCount: 500,
      distance: widget.initDistance,
      deliveryTime: widget.initTime,
      menu: widget.restaurantMenu,
    );

    setState(() {
      DataManager().toggleRestaurantFavorite(res);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? "Đã thêm vào yêu thích!" : "Đã xóa khỏi yêu thích!"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildModernSliverAppBar(),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildModernRestaurantHeader(),
                      _buildQuickActionCards(context),
                      const SizedBox(height: 8),
                      _buildMenuSection(),
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_totalItems > 0) _buildModernFloatingBar(context),
        ],
      ),
    );
  }

  Widget _buildModernSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
          child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18), onPressed: () => Navigator.pop(context)),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
          // ⭐️ NÚT TIM LIÊN KẾT VỚI DATA MANAGER
          child: IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.red : Colors.black, size: 20),
              onPressed: _toggleFavorite
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
          child: IconButton(icon: const Icon(Icons.share, color: Colors.black, size: 20), onPressed: () => Share.share("Thử ngay ${widget.restaurantName}!")),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(_backgroundImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.restaurant, size: 100, color: Colors.grey))),
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]))),
            Positioned(
              bottom: 20, left: 20, right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.3))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.verified, color: Colors.white, size: 16), const SizedBox(width: 4), const Text('Đối tác chính thức', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]),
                  ),
                  const SizedBox(height: 12),
                  Text(widget.restaurantName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 4)])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernRestaurantHeader() {

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _gradientColors.map((c) => c.withOpacity(0.1)).toList()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(_currentTheme['icon'], color: _primaryColor, size: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {

                    Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewsScreen(rating: widget.initRating, reviewCount: 500)));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),

                      Text("${widget.initRating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 4),
                      Text("(500+ đánh giá)", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      const Icon(Icons.chevron_right, size: 16, color: Colors.grey)
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.delivery_dining, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),

                    Text(widget.initTime, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),

                    Text(widget.initDistance, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_totalItems == 0) { _showSelectItemsWarning(); return; }
                Navigator.push(context, MaterialPageRoute(builder: (_) => PickupFlashSaleScreen(item: widget.restaurantMenu[0], quantity: _totalItems)));
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _primaryColor, width: 2), boxShadow: [BoxShadow(color: _primaryColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.shopping_bag_outlined, color: _primaryColor, size: 32)), const SizedBox(height: 12), Text('Đến lấy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryColor))]),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_totalItems == 0) { _showSelectItemsWarning(); return; }
                _navigateToDelivery();
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(gradient: LinearGradient(colors: _gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: _primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.two_wheeler, color: Colors.white, size: 32)), const SizedBox(height: 12), const Text('Giao hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectItemsWarning() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Vui lòng chọn món ăn trước!'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.all(16)));
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Container(width: 4, height: 24, decoration: BoxDecoration(gradient: LinearGradient(colors: _gradientColors, begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 12),
              const Text("Thực đơn", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text("${widget.restaurantMenu.length} món", style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.restaurantMenu.length,
          itemBuilder: (context, index) {
            final item = widget.restaurantMenu[index];
            int count = _itemCounts[item.name] ?? 0;
            return _buildModernFoodCard(item, count);
          },
        ),
      ],
    );
  }

  Widget _buildModernFoodCard(FoodItem item, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: count > 0 ? _primaryColor.withOpacity(0.3) : Colors.grey.shade200, width: count > 0 ? 2 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(item.imageUrl, width: 90, height: 90, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 90, height: 90, color: Colors.grey[200], child: const Icon(Icons.fastfood, size: 40, color: Colors.grey))),
                ),


                Positioned(
                  top: 4, left: 4,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewsScreen(
                            rating: item.rating,
                            reviewCount: 100 + _random.nextInt(500),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            item.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.chevron_right, size: 10, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

                if (count > 0)
                  Positioned(
                    bottom: 4, right: 4,
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(gradient: LinearGradient(colors: _gradientColors), borderRadius: BorderRadius.circular(8)), child: Text('×$count', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                  ),
              ],
            ),

            const SizedBox(width: 15),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(formatVND(item.price), style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),

            // Buttons
            if (count == 0)
              Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: _gradientColors), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: _primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]),
                child: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () => _updateItemCount(item.name, true)),
              )
            else
              Container(
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  IconButton(icon: const Icon(Icons.remove, size: 20), onPressed: () => _updateItemCount(item.name, false)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  IconButton(icon: Icon(Icons.add, color: _primaryColor, size: 20), onPressed: () => _updateItemCount(item.name, true)),
                ]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFloatingBar(BuildContext context) {
    return Positioned(
      bottom: 20, left: 20, right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: LinearGradient(colors: _gradientColors), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: _primaryColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))]),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(formatVND(_totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)), const SizedBox(height: 4), Text('$_totalItems món đã chọn', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13))])),
              Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: IconButton(onPressed: _handleAddToCart, icon: Icon(Icons.add_shopping_cart, color: _primaryColor), iconSize: 24)),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}