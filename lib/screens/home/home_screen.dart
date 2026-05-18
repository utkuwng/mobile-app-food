import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/favorites/favorites_screen.dart';
import '../../screens/food_detail/food_detail_screen.dart';
import 'widgets/category_grid.dart';
import 'widgets/flash_sale_list.dart';
import 'widgets/category_items_page.dart';
import 'package:ueh_food_delivery/screens/food_detail/suggested_restaurant.dart';
import 'package:ueh_food_delivery/models/food_item.dart';
import 'package:ueh_food_delivery/data/mock_data.dart';
import 'package:ueh_food_delivery/data/data_manager.dart';
import '../profile/address_screen.dart';
import '../notification/notification_screen.dart';
import 'discount_items_screen.dart';
import '../../screens/search/search_screen.dart';
import 'package:ueh_food_delivery/entry_point.dart';
import '../../data/restaurant_data.dart';
import '../../models/restaurant_item.dart';
import '../../reviews/reviews_screen.dart';

// Màu sắc chủ đạo
const primaryColor = Color(0xFFFF5283);
const secondaryColor = Color(0xFFFF3366);
const backgroundColor = Color(0xFFF8F9FC);
const cardColor = Colors.white;

class HomeScreen extends StatefulWidget {
  final Function({
  String? category,
  RangeValues? priceRange,
  String? distance,
  String? time,
  String? fee,
  List<String>? promos,
  })? onFilterApplied;

  const HomeScreen({
    super.key,
    this.onFilterApplied,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<String> _filterDistance = ["< 1km", "1 - 3km", "3 - 5km", "Toàn khu vực", "Gần tôi nhất"];
  final List<String> _filterTime = ["Dưới 15 phút", "Dưới 30 phút", "Dưới 45 phút", "Siêu tốc"];
  final List<String> _filterFee = ["Miễn phí", "≤ 5k", "≤ 10k", "≤ 20k"];
  final List<String> _filterPromo = ["Deal Hot", "Giảm 50%", "Voucher Shop", "Mua 1 Tặng 1", "Combo Tiết Kiệm"];

  final List<Map<String, dynamic>> _categoriesData = [
    {"name": "Cơm", "prefix": "com", "img": "assets/images/com.jpg", "color": Color(0xFFFF6B9D)},
    {"name": "Bún/Phở", "prefix": "bun", "img": "assets/images/pho.jpg", "color": Color(0xFF667EEA)},
    {"name": "Bánh mì", "prefix": "banhmi", "img": "assets/images/banhmi.jpg", "color": Color(0xFFFFB75E)},
    {"name": "Gà rán", "prefix": "ga", "img": "assets/images/chicken.jpg", "color": Color(0xFFFF6B6B)},
    {"name": "Trà sữa", "prefix": "trasua", "img": "assets/images/milktea.jpg", "color": Color(0xFF4ECDC4)},
    {"name": "Cà phê", "prefix": "cafe", "img": "assets/images/coffee.jpg", "color": Color(0xFF8B5A3C)},
    {"name": "Đồ chay", "prefix": "chay", "img": "assets/images/chay.jpg", "color": Color(0xFF66BB6A)},
    {"name": "Healthy", "prefix": "healthy", "img": "assets/images/healthy.jpg", "color": Color(0xFF81C784)},
    {"name": "Pizza", "prefix": "pizza", "img": "assets/images/pizza.jpg", "color": Color(0xFFFF7043)},
    {"name": "Món Hàn", "prefix": "han", "img": "assets/images/han.jpg", "color": Color(0xFFFF4757)},
    {"name": "Món Nhật", "prefix": "nhat", "img": "assets/images/nhat.jpg", "color": Color(0xFFE74C3C)},
    {"name": "Lẩu/Nướng", "prefix": "lau", "img": "assets/images/lau.jpg", "color": Color(0xFFE67E22)},
    {"name": "Ăn vặt", "prefix": "anvat", "img": "assets/images/snack.jpg", "color": Color(0xFFF39C12)},
    {"name": "Tráng miệng", "prefix": "dessert", "img": "assets/images/dessert.jpg", "color": Color(0xFFE91E63)},
  ];

  late Timer _timer;
  Duration _flashSaleTime = const Duration(hours: 2, minutes: 15, seconds: 20);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _currentAddress = "UEH Campus N";

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<FoodItem> _searchResult = [];
  List<String> _searchHistory = [];
  bool _isSearching = false;
  final Random _random = Random();

  late final Map<String, List<FoodItem>> categoryItems = generateAllCategoryItems();
  late final List<FoodItem> _allFoodItems = categoryItems.values.expand((list) => list).toList();

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _loadSavedAddress();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_flashSaleTime.inSeconds > 0) {
        if (mounted) setState(() => _flashSaleTime -= const Duration(seconds: 1));
      } else {
        timer.cancel();
      }
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  RestaurantItem? _findRestaurantByFood(FoodItem food) {
    final allRes = RestaurantDataManager().allRestaurants;
    try {
      return allRes.firstWhere((res) => res.menu.any((item) => item.id == food.id));
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('current_delivery_address');
    if (savedAddress != null && mounted) {
      setState(() {
        _currentAddress = savedAddress;
      });
    }
  }

  Future<void> _selectAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddressScreen()),
    );

    if (result != null && result is AddressItem) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_delivery_address', result.title);
      setState(() {
        _currentAddress = result.title;
      });
    }
  }

  String _removeDiacritics(String str) {
    var withDia = 'àáâãèéêìíòóôõùúýỳỹỷỵụủứừửữựợởờớợổỗồốỏọẹẻẽềếểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹ';
    var withoutDia = 'aaaaaaaaeeeiiioooouuyyyyyuuu uuuuuuooooooooooeeeeeiiiiioooooooooooouuuuuuuyyyy';
    String result = str.toLowerCase();
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    return result.replaceAll('đ', 'd').replaceAll('ơ', 'o').replaceAll('ư', 'u').trim();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _searchHistory = prefs.getStringList('search_history') ?? []);
  }

  Future<void> _saveSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);
    if (_searchHistory.length > 5) _searchHistory.removeLast();
    await prefs.setStringList('search_history', _searchHistory);
    setState(() {});
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty || _searchFocusNode.hasFocus;
      if (query.isEmpty) {
        _searchResult = [];
      } else {
        String normalizedQuery = _removeDiacritics(query);
        _searchResult = _allFoodItems.where((food) {
          return _removeDiacritics(food.name).contains(normalizedQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                automaticallyImplyLeading: false,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: cardColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [cardColor, backgroundColor],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildModernHeader(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: Container(
                    color: cardColor,
                    child: _buildSearchArea(),
                  ),
                ),
              ),

              if (!_isSearching && _searchController.text.isEmpty) ...[
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildInfoBanner(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildQuickActionsBanner(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildStatsRow(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Danh mục món ăn",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CategoryGrid(
                    onCategorySelected: (name) {
                      final allGrouped = RestaurantDataManager().groupedRestaurants;
                      final List<RestaurantItem> listRes = allGrouped[name] ?? [];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryItemsPage(
                            categoryName: name,
                            restaurants: listRes,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _buildFlashSaleSection(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildSuggestedSection(),
                ),
              ] else if (_searchController.text.isEmpty && _searchFocusNode.hasFocus) ...[
                SliverToBoxAdapter(child: _buildSearchHistorySection()),
              ] else ...[
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: _searchResult.isEmpty
                      ? const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "Không tìm thấy món ăn",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Thử tìm kiếm với từ khóa khác",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                      : SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildModernSearchCard(_searchResult[index]),
                      childCount: _searchResult.length,
                    ),
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          Positioned(
            bottom: 24,
            right: 20,
            child: _buildFloatingCartButton(),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildModernHeader() {
    final favoriteCount = DataManager().favoriteItems.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectAddress,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Giao tới", style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: primaryColor, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _currentAddress,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[600]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  _buildHeaderIconButton(
                    icon: Icons.notifications_outlined,
                    hasNotification: true,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildHeaderIconButton(
                    icon: favoriteCount > 0 ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    badge: favoriteCount > 0 ? '$favoriteCount' : null,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen())).then((_) => setState(() {}));
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({required IconData icon, Color? color, bool hasNotification = false, String? badge, required VoidCallback onTap}) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: Icon(icon, size: 22, color: color ?? Colors.grey[800]),
          ),
        ),
        if (hasNotification)
          Positioned(
            right: 8, top: 8,
            child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
          ),
        if (badge != null)
          Positioned(
            right: 6, top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _searchFocusNode.hasFocus ? primaryColor.withOpacity(0.3) : Colors.transparent, width: 1.5),
                boxShadow: [BoxShadow(color: _searchFocusNode.hasFocus ? primaryColor.withOpacity(0.1) : Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                onSubmitted: (val) => _saveSearchHistory(val),
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Tìm món ăn...",
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.cancel, color: Colors.grey, size: 20), onPressed: () { _searchController.clear(); _onSearchChanged(""); })
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
          if (!_isSearching) ...[
            const SizedBox(width: 12),
            Container(
              height: 52, width: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showFilterBottomSheet(context),
                  borderRadius: BorderRadius.circular(16),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBanner() => Container(
    margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFB74D).withOpacity(0.3))),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFFB74D).withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.info_outline, color: Color(0xFFFF8A00), size: 20)),
      const SizedBox(width: 12),
      const Expanded(child: Text("Đặt món trước 11h để nhận ưu đãi giao hàng miễn phí! 🚀", style: TextStyle(fontSize: 13, color: Color(0xFF5D4037), fontWeight: FontWeight.w500))),
    ]),
  );

  Widget _buildQuickActionsBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🎉 Ưu đãi hôm nay", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("Giảm 30% cho đơn đầu tiên", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiscountItemsScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.3))),
                    child: const Text("Xem ngay", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.local_offer, color: Colors.white, size: 60),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(children: [
        Expanded(child: _buildStatItem(icon: Icons.restaurant_menu, label: "1000+ Món", color: const Color(0xFFFF6B9D))),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem(icon: Icons.store, label: "500+ Quán", color: const Color(0xFF667EEA))),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem(icon: Icons.delivery_dining, label: "Giao nhanh 15'", color: const Color(0xFF4CAF50))),
      ]),
    );
  }

  Widget _buildStatItem({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 18, color: color), const SizedBox(width: 6), Flexible(child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color), overflow: TextOverflow.ellipsis))]),
    );
  }

  Widget _buildFlashSaleSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xfc0388), Color(0xFFFF8E53)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xfc0388).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.local_fire_department, color: Colors.white, size: 30)),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("TRÙM DEAL NGON", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)), SizedBox(height: 4), Text("Giảm đến 50%", style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600))])),
          ]),
        ),
        Container(padding: const EdgeInsets.fromLTRB(16, 0, 0, 20), child: SizedBox(height: 220, child: FlashSaleWidget())),
      ]),
    );
  }

  Widget _buildSuggestedSection() {
    final restaurantManager = RestaurantDataManager();
    final allGrouped = restaurantManager.groupedRestaurants;
    final List<RestaurantItem> suggestedList = allGrouped.values.expand((list) => list).take(6).toList();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 100,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 90, width: double.infinity,
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF5283), Color(0xFFFF9A8B)], begin: Alignment.centerLeft, end: Alignment.centerRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: const Color(0xFFFF5283).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 100, top: 15, bottom: 15),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Text("HÔM NAY ĂN GÌ?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Text("Gợi ý quán ngon tuyển chọn", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
                      ]),
                    ),
                  ),
                  Positioned(
                    right: 10, bottom: 10,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(0, 5 * sin(value * 2 * pi)),
                          child: Transform.rotate(
                            angle: 0.1,
                            child: Container(
                              height: 100, width: 100,
                              decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.0)], center: Alignment.topCenter, radius: 0.8)),
                              child: const Center(child: Text("🍱", style: TextStyle(fontSize: 65))),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: suggestedList.length,
              itemBuilder: (context, index) {
                final restaurant = suggestedList[index];
                return _buildUltraPremiumCard(restaurant, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ⭐️⭐️ ĐÃ CẬP NHẬT: TRUYỀN DỮ LIỆU CHUẨN XÁC ĐỂ ĐỒNG BỘ ⭐️⭐️
  Widget _buildUltraPremiumCard(RestaurantItem restaurant, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SuggestedRestaurantScreen(
            restaurantName: restaurant.name,
            restaurantMenu: restaurant.menu,
            // ⭐️ ĐÃ THÊM: Truyền rating, time, distance
            initRating: restaurant.rating,
            initTime: restaurant.deliveryTime,
            initDistance: "${restaurant.distance}km",
          ),
        ),
      ),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(tag: 'restaurant_${restaurant.name}_$index', child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: Image.asset(restaurant.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover))),
                      Container(height: 160, decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.5)]))),
                      Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)]), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.emoji_events, color: Colors.white, size: 16), const SizedBox(width: 4), Text("TOP ${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))]))),
                      Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)]), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, color: Color(0xFFFFA500), size: 16), const SizedBox(width: 4), Text("${restaurant.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3142)))]))),
                      Positioned(bottom: 12, left: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [const Icon(Icons.access_time, size: 14, color: Color(0xFF4CAF50)), const SizedBox(width: 4), Text(restaurant.deliveryTime, style: const TextStyle(fontSize: 11, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600))]), Container(width: 1, height: 14, color: Colors.grey.shade300), Row(children: [const Icon(Icons.location_on, size: 14, color: Color(0xFF2196F3)), const SizedBox(width: 4), Text("${restaurant.distance}km", style: const TextStyle(fontSize: 11, color: Color(0xFF2196F3), fontWeight: FontWeight.w600))])]))),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 12),
                        Wrap(spacing: 6, runSpacing: 6, children: [_buildTag("🔥 Hot", const Color(0xFFFF6B6B)), _buildTag("⚡ Nhanh", const Color(0xFF4CAF50)), _buildTag("💰 Ưu đãi", const Color(0xFFFFA500))]),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                          ),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Đặt ngay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)), SizedBox(width: 6), Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12)]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SuggestedRestaurantScreen(
                        restaurantName: restaurant.name,
                        restaurantMenu: restaurant.menu,
                        // ⭐️ TRUYỀN DỮ LIỆU LẦN NỮA TẠI ĐÂY (VÌ INKWELL NẰM TRÊN CÙNG)
                        initRating: restaurant.rating,
                        initTime: restaurant.deliveryTime,
                        initDistance: "${restaurant.distance}km",
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(24),
                  splashColor: const Color(0xFF667EEA).withOpacity(0.1),
                  highlightColor: const Color(0xFF667EEA).withOpacity(0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3), width: 1)),
      child: Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSearchHistorySection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Tìm kiếm gần đây", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2D3142))), if (_searchHistory.isNotEmpty) GestureDetector(onTap: () async { final prefs = await SharedPreferences.getInstance(); await prefs.remove('search_history'); setState(() => _searchHistory = []); }, child: Text("Xóa tất cả", style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600)))]),
        const SizedBox(height: 16),
        if (_searchHistory.isEmpty) Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(Icons.history, size: 60, color: Colors.grey[300]), const SizedBox(height: 12), Text("Chưa có lịch sử tìm kiếm", style: TextStyle(color: Colors.grey[500]))]))) else Wrap(spacing: 10, runSpacing: 10, children: _searchHistory.map((h) => GestureDetector(onTap: () { _searchController.text = h; _onSearchChanged(h); }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.history, size: 16, color: Colors.grey[600]), const SizedBox(width: 8), Text(h, style: const TextStyle(fontSize: 14))])) )).toList()),
      ]),
    );
  }

  // ⭐️⭐️ SEARCH CARD - CŨNG ĐÃ ĐỒNG BỘ ⭐️⭐️
  Widget _buildModernSearchCard(FoodItem item) {
    final parentRestaurant = _findRestaurantByFood(item);
    final double displayRating = parentRestaurant?.rating ?? item.rating;
    final String displayDistance = parentRestaurant != null ? "${parentRestaurant.distance}km" : "1.0km";
    final String displayTime = parentRestaurant?.deliveryTime ?? "15-30'";

    return GestureDetector(
      onTap: () {
        _saveSearchHistory(item.name);
        if (parentRestaurant != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SuggestedRestaurantScreen(
            restaurantName: parentRestaurant.name,
            restaurantMenu: parentRestaurant.menu,
            // ⭐️ ĐỒNG BỘ DỮ LIỆU TỪ SEARCH CARD
            initRating: parentRestaurant.rating,
            initTime: parentRestaurant.deliveryTime,
            initDistance: "${parentRestaurant.distance}km",
          )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không tìm thấy thông tin quán ăn!")));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: backgroundColor, child: const Icon(Icons.fastfood, size: 40, color: Colors.grey)))),
                  Positioned(
                    top: 4, left: 4,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewsScreen(rating: displayRating, reviewCount: 100 + _random.nextInt(200)))),
                      child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, color: Colors.amber, size: 10), const SizedBox(width: 2), Text(displayRating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black87))])),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(parentRestaurant?.name ?? "Đang cập nhật", style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text("${item.price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.store, size: 20, color: primaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCartButton() {
    return Container(width: 60, height: 60, decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))]), child: Material(color: Colors.transparent, child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())), borderRadius: BorderRadius.circular(20), child: const Center(child: Icon(Icons.shopping_cart, color: Colors.white, size: 28)))));
  }

  void _showFilterBottomSheet(BuildContext context) {
    String? tempCategory;
    RangeValues tempPriceRange = const RangeValues(0, 500000);
    String? tempDistance;

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) { return StatefulBuilder(builder: (context, setModalState) { return Container(height: MediaQuery.of(context).size.height * 0.8, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))), child: Column(children: [const SizedBox(height: 20), Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Bộ lọc", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), TextButton(onPressed: () => setModalState(() { tempCategory = null; tempPriceRange = const RangeValues(0, 500000); }), child: const Text("Đặt lại", style: TextStyle(color: Colors.red)))] )), const Divider(), Expanded(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildSectionTitle("Danh mục món ăn"), Wrap(spacing: 8, runSpacing: 8, children: _categoriesData.map((cat) { final name = cat['name'] as String; final isSelected = tempCategory == name; return ChoiceChip(label: Text(name), selected: isSelected, onSelected: (val) => setModalState(() => tempCategory = val ? name : null), selectedColor: const Color(0xFFFF5283).withOpacity(0.2), backgroundColor: Colors.grey[100], labelStyle: TextStyle(color: isSelected ? const Color(0xFFFF5283) : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal), side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))); }).toList()), const SizedBox(height: 24), _buildSectionTitle("Khoảng giá"), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${(tempPriceRange.start / 1000).toInt()}k", style: const TextStyle(fontWeight: FontWeight.bold)), Text("${(tempPriceRange.end / 1000).toInt()}k", style: const TextStyle(fontWeight: FontWeight.bold))]), RangeSlider(values: tempPriceRange, min: 0, max: 500000, divisions: 50, activeColor: const Color(0xFFFF5283), inactiveColor: Colors.grey[200], onChanged: (v) => setModalState(() => tempPriceRange = v)), const SizedBox(height: 16), _buildSectionTitle("Khoảng cách"), _buildSingleChoiceGroup(_filterDistance, tempDistance, (val) => setModalState(() => tempDistance = val)), const SizedBox(height: 100)]))), Padding(padding: const EdgeInsets.all(24), child: SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5283)), onPressed: () { Navigator.pop(context); EntryPoint.globalKey.currentState?.jumpToSearch(category: tempCategory, priceRange: tempPriceRange, distance: tempDistance); }, child: const Text("Áp dụng bộ lọc", style: TextStyle(color: Colors.white))))) ])); }); });
  }

  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12, top: 5), child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))));

  Widget _buildSingleChoiceGroup(List<String> options, String? currentValue, Function(String) onSelected) => Wrap(spacing: 10, runSpacing: 10, children: options.map((o) => GestureDetector(onTap: () => onSelected(o), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(gradient: currentValue == o ? const LinearGradient(colors: [Color(0xFFFF5283), Color(0xFFFF3366)]) : null, color: currentValue == o ? null : Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: Text(o, style: TextStyle(color: currentValue == o ? Colors.white : Colors.black87, fontWeight: currentValue == o ? FontWeight.bold : FontWeight.normal))))).toList());
}