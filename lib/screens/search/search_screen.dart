import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/data/mock_data.dart';
import 'package:ueh_food_delivery/screens/food_detail/food_detail_screen.dart';
import '../home/widgets/category_items_page.dart';
import 'package:ueh_food_delivery/models/food_item.dart';
import '../../data/data_manager.dart';
import '../../data/restaurant_data.dart';
import '../../models/restaurant_item.dart';
import 'package:ueh_food_delivery/screens/food_detail/suggested_restaurant.dart';
import '../../reviews/reviews_screen.dart';

const primaryColor = Color(0xFFFF5283);
const secondaryColor = Color(0xFFFF3366);
const backgroundColor = Color(0xFFF8F9FC);

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initCategory;
  final RangeValues? initPriceRange;
  final String? initDistance;
  final String? initTime;
  final String? initFee;
  final List<String>? initPromos;

  const SearchScreen({
    super.key,
    this.initialQuery,
    this.initCategory,
    this.initPriceRange,
    this.initDistance,
    this.initTime,
    this.initFee,
    this.initPromos,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animController;

  late final List<FoodItem> _allFoodItems;
  List<RestaurantItem> _searchResultRestaurants = [];
  List<FoodItem> _searchResultItems = [];

  bool _isDisplayingRestaurants = true;
  bool _isLoadingMore = false;
  bool _isLoadingInitial = false;
  final Random _random = Random();

  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 500000);
  String? _selectedDistance;
  String? _selectedTime;
  String? _selectedFee;
  List<String> _selectedPromos = [];

  final List<Map<String, dynamic>> _categoriesData = [
    {"name": "Cơm", "img": "assets/images/com.jpg", "color": Color(0xFFFF6B9D)},
    {"name": "Bún/Phở", "img": "assets/images/pho.jpg", "color": Color(0xFF667EEA)},
    {"name": "Bánh mì", "img": "assets/images/banhmi.jpg", "color": Color(0xFFFFB75E)},
    {"name": "Gà rán", "img": "assets/images/chicken.jpg", "color": Color(0xFFFF6B6B)},
    {"name": "Trà sữa", "img": "assets/images/milktea.jpg", "color": Color(0xFF4ECDC4)},
    {"name": "Cà phê", "img": "assets/images/coffee.jpg", "color": Color(0xFF8B5A3C)},
    {"name": "Đồ chay", "img": "assets/images/chay.jpg", "color": Color(0xFF66BB6A)},
    {"name": "Healthy", "img": "assets/images/healthy.jpg", "color": Color(0xFF81C784)},
    {"name": "Pizza", "img": "assets/images/pizza.jpg", "color": Color(0xFFFF7043)},
    {"name": "Món Hàn", "img": "assets/images/han.jpg", "color": Color(0xFFFF4757)},
    {"name": "Món Nhật", "img": "assets/images/nhat.jpg", "color": Color(0xFFE74C3C)},
    {"name": "Lẩu/Nướng", "img": "assets/images/lau.jpg", "color": Color(0xFFE67E22)},
    {"name": "Ăn vặt", "img": "assets/images/snack.jpg", "color": Color(0xFFF39C12)},
    {"name": "Tráng miệng", "img": "assets/images/dessert.jpg", "color": Color(0xFFE91E63)},
  ];

  final List<String> _filterDistance = ["< 1km", "1 - 3km", "3 - 5km", "Toàn khu vực", "Gần tôi nhất"];
  final List<String> _filterTime = ["Dưới 15 phút", "Dưới 30 phút", "Dưới 45 phút", "Siêu tốc"];
  final List<String> _filterFee = ["Miễn phí", "≤ 5k", "≤ 10k", "≤ 20k"];
  final List<String> _filterPromo = ["Deal Hot", "Giảm 50%", "Voucher Shop", "Mua 1 Tặng 1", "Combo Tiết Kiệm"];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? "");
    _allFoodItems = DataManager().allFoodItems;
    _animController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animController.forward();

    _selectedCategory = widget.initCategory;
    if (widget.initPriceRange != null) _priceRange = widget.initPriceRange!;
    _selectedDistance = widget.initDistance;
    _selectedTime = widget.initTime;
    _selectedFee = widget.initFee;
    _selectedPromos = widget.initPromos ?? [];

    _generateInitialSearchResults();

    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    } else if (widget.initCategory != null || widget.initDistance != null) {
      _applyFilterMockLogic();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        _loadMoreData();
      }
    });
  }

  String _normalize(String str) {
    var withDia = 'àáâãèéêìíòóôõùúýỳỹỷỵụủứừửữựợởờớợổỗồốỏọẹẻẽềếểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹ';
    var withoutDia = 'aaaaaaaaeeeiiioooouuyyyyyuuu uuuuuuooooooooooeeeeeiiiiioooooooooooouuuuuuuyyyy';
    String result = str.toLowerCase();
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    return result.replaceAll('đ', 'd').replaceAll('ơ', 'o').replaceAll('ư', 'u').trim();
  }

  RestaurantItem? _findRestaurantByFood(FoodItem food) {
    final allRes = RestaurantDataManager().allRestaurants;
    try {
      return allRes.firstWhere((res) => res.menu.any((item) => item.id == food.id));
    } catch (e) {
      return null;
    }
  }

  void _generateInitialSearchResults() {
    final allRes = RestaurantDataManager().allRestaurants;
    if (allRes.isEmpty) {
      setState(() => _isDisplayingRestaurants = true);
      return;
    }
    final List<RestaurantItem> shuffled = List.from(allRes)..shuffle(_random);
    setState(() {
      _isDisplayingRestaurants = true;
      _searchResultRestaurants = shuffled.take(10).toList();
      _searchResultItems = [];
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      _generateInitialSearchResults();
      return;
    }
    final normalizedQuery = _normalize(query);
    final matchedFoods = _allFoodItems
        .where((food) => _normalize(food.name).contains(normalizedQuery))
        .toList();

    setState(() {
      _searchResultItems = matchedFoods;
      _isDisplayingRestaurants = false;
    });
  }

  List<FoodItem> _getCombinedFilteredList() {
    List<FoodItem> result = List.from(_allFoodItems);

    if (_selectedCategory != null) {
      final catItems = generateAllCategoryItems()[_selectedCategory!] ?? [];
      final catIds = catItems.map((e) => e.id).toSet();
      result = result.where((item) => catIds.contains(item.id)).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _normalize(_searchController.text);
      result = result.where((item) =>
      _normalize(item.name).contains(query) ||
          _normalize(item.description).contains(query)
      ).toList();
    }

    result = result.where((item) =>
    item.price >= _priceRange.start && item.price <= _priceRange.end
    ).toList();

    if ((_selectedDistance != null && _selectedDistance != "Toàn khu vực") || _selectedTime != null) {
      result = result.where((item) {
        final parentRes = _findRestaurantByFood(item);
        if (parentRes == null) return false;

        bool distPass = true;
        bool timePass = true;

        if (_selectedDistance != null && _selectedDistance != "Toàn khu vực") {
          try {
            double dist = double.parse(parentRes.distance);
            if (_selectedDistance == "< 1km") distPass = dist < 1.0;
            else if (_selectedDistance == "1 - 3km") distPass = dist >= 1.0 && dist <= 3.0;
            else if (_selectedDistance == "3 - 5km") distPass = dist > 3.0 && dist <= 5.0;
            else if (_selectedDistance == "Gần tôi nhất") distPass = dist < 2.0;
          } catch (_) { distPass = false; }
        }

        if (_selectedTime != null) {
          try {
            int minTime = int.parse(parentRes.deliveryTime.split('-')[0].replaceAll(RegExp(r'[^0-9]'), ''));
            if (_selectedTime == "Dưới 15 phút") timePass = minTime <= 15;
            else if (_selectedTime == "Dưới 30 phút") timePass = minTime <= 30;
            else if (_selectedTime == "Dưới 45 phút") timePass = minTime <= 45;
            else if (_selectedTime == "Siêu tốc") timePass = minTime <= 20;
          } catch (_) { timePass = true; }
        }

        return distPass && timePass;
      }).toList();
    }

    return result;
  }

  void _applyFilterMockLogic() {
    setState(() => _isLoadingInitial = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final filteredList = _getCombinedFilteredList();
      setState(() {
        _isLoadingInitial = false;
        _isDisplayingRestaurants = false;
        _searchResultItems = filteredList;
      });
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;
    if (_isDisplayingRestaurants) return;

    final sourceList = _getCombinedFilteredList();
    final currentIds = _searchResultItems.map((e) => e.id).toSet();
    final availableToAdd = sourceList.where((item) => !currentIds.contains(item.id)).toList();

    if (availableToAdd.isEmpty) return;

    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _searchResultItems.addAll(availableToAdd.take(5));
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            if (_searchController.text.isEmpty) _buildCategorySection(),
            _buildTitleSection(),
            Expanded(
              child: _isLoadingInitial
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : (_isDisplayingRestaurants ? _searchResultRestaurants.isEmpty : _searchResultItems.isEmpty)
                  ? _buildEmptyState()
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: (_isDisplayingRestaurants ? _searchResultRestaurants.length : _searchResultItems.length) + 1,
                itemBuilder: (context, index) {
                  int listLen = _isDisplayingRestaurants ? _searchResultRestaurants.length : _searchResultItems.length;
                  if (index == listLen) {
                    return _isLoadingMore
                        ? const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator(color: primaryColor)))
                        : const SizedBox(height: 50);
                  }
                  if (_isDisplayingRestaurants) {
                    return _buildSearchRestaurantCard(_searchResultRestaurants[index]);
                  } else {
                    return _buildFoodCard(_searchResultItems[index], index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: const Center(
        child: Text(
          "Tìm kiếm món ăn",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 4))],
        ),
        child: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onChanged: _performSearch,
          onSubmitted: _performSearch,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: "Bạn đang thèm món gì?",
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: primaryColor),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _generateInitialSearchResults();
                  });
                })
                : IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryColor, secondaryColor]), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.tune, color: Colors.white, size: 18),
              ),
              onPressed: () => _showFilterBottomSheet(context),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            "Danh mục phổ biến",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categoriesData.length,
            itemBuilder: (context, index) {
              final cat = _categoriesData[index];
              return GestureDetector(
                onTap: () {
                  final listRes = RestaurantDataManager().groupedRestaurants[cat['name']] ?? [];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryItemsPage(
                        categoryName: cat['name'],
                        restaurants: listRes,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 85,
                  margin: const EdgeInsets.only(right: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (cat['color'] as Color? ?? Colors.grey).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(cat["img"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat['name'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
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

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Container(width: 4, height: 24, decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryColor, secondaryColor]), borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Text(
            _isDisplayingRestaurants ? "Gợi ý nhà hàng" : "Món ăn tìm được",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRestaurantCard(RestaurantItem restaurant) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SuggestedRestaurantScreen(
        restaurantName: restaurant.name,
        restaurantMenu: restaurant.menu,
        initRating: restaurant.rating,
        initTime: restaurant.deliveryTime,
        initDistance: "${restaurant.distance}km",
      ))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))]),
        child: Column(
          children: [
            Stack(
              children: [
                Hero(tag: 'res_img_${restaurant.name}', child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: Image.asset(restaurant.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover))),
                Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 18), Text(" ${restaurant.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(restaurant.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)), maxLines: 1, overflow: TextOverflow.ellipsis)), const Icon(Icons.verified, color: Colors.blue, size: 18)]),
                  const SizedBox(height: 8),
                  Row(children: [Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]), const SizedBox(width: 4), Text(restaurant.deliveryTime, style: TextStyle(color: Colors.grey[600], fontSize: 13)), const SizedBox(width: 12), Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]), const SizedBox(width: 4), Text("${restaurant.distance}km", style: TextStyle(color: Colors.grey[600], fontSize: 13))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFoodCard(FoodItem item, int index) {

    final parentRestaurant = _findRestaurantByFood(item);


    final double displayRating = parentRestaurant?.rating ?? item.rating;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Interval((index * 0.1).clamp(0.0, 1.0), 1.0, curve: Curves.easeOut))),
      child: GestureDetector(
        onTap: () {
          if (parentRestaurant != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SuggestedRestaurantScreen(
              restaurantName: parentRestaurant.name,
              restaurantMenu: parentRestaurant.menu,

              initRating: parentRestaurant.rating,
              initTime: parentRestaurant.deliveryTime,
              initDistance: "${parentRestaurant.distance}km",
            )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không tìm thấy thông tin quán ăn!")));
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Row(
            children: [

              Stack(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset(item.imageUrl, width: 90, height: 90, fit: BoxFit.cover)),
                  Positioned(
                    top: 4, left: 4,
                    child: GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReviewsScreen(
                              rating: displayRating,
                              reviewCount: 100 + _random.nextInt(200),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 10),
                            const SizedBox(width: 2),

                            Text(
                              displayRating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(parentRestaurant?.name ?? "Đang cập nhật", style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),

                    const SizedBox(height: 4),
                    if (parentRestaurant != null)
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 2),
                          Text("${parentRestaurant.distance}km", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                          const SizedBox(width: 10),
                          Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 2),
                          Text(parentRestaurant.deliveryTime, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                        ],
                      ),

                    const SizedBox(height: 6),
                    Text("${item.price.toInt()}đ", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              Column(children: [Icon(Icons.storefront_rounded, color: primaryColor.withOpacity(0.8), size: 28), const SizedBox(height: 4), const Text("Xem quán", style: TextStyle(fontSize: 10, color: Colors.grey))]),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.search_off, size: 80, color: primaryColor)),
          const SizedBox(height: 24),
          const Text("Không tìm thấy món ăn", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: Column(
              children: [
                Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Bộ lọc tìm kiếm", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                    TextButton(onPressed: () => setModalState(() { _selectedCategory = null; _priceRange = const RangeValues(0, 500000); _selectedDistance = null; _selectedTime = null; _selectedFee = null; _selectedPromos.clear(); }), child: const Text("Đặt lại", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)))
                  ]),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _buildSectionTitle("Danh mục món ăn"),
                      Wrap(spacing: 8, runSpacing: 8, children: _categoriesData.map((cat) {
                        bool isSelected = _selectedCategory == cat['name'];
                        return ChoiceChip(label: Text(cat['name']), selected: isSelected, onSelected: (val) => setModalState(() => _selectedCategory = val ? cat['name'] : null), selectedColor: primaryColor.withOpacity(0.2), labelStyle: TextStyle(color: isSelected ? primaryColor : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal));
                      }).toList()),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Khoảng giá"),
                      RangeSlider(values: _priceRange, min: 0, max: 500000, divisions: 50, activeColor: primaryColor, onChanged: (v) => setModalState(() => _priceRange = v)),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${(_priceRange.start / 1000).toInt()}k", style: const TextStyle(fontWeight: FontWeight.bold)), Text("${(_priceRange.end / 1000).toInt()}k", style: const TextStyle(fontWeight: FontWeight.bold))]),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Khoảng cách"),
                      _buildSingleChoiceGroup(_filterDistance, _selectedDistance, (val) => setModalState(() => _selectedDistance = val)),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Thời gian giao hàng"),
                      _buildSingleChoiceGroup(_filterTime, _selectedTime, (val) => setModalState(() => _selectedTime = val)),
                      const SizedBox(height: 50),
                    ]),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(24), child: SizedBox(width: double.infinity, height: 56, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: () { Navigator.pop(context); _applyFilterMockLogic(); }, child: const Text("Áp dụng bộ lọc", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))))),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12, top: 5), child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142))));

  Widget _buildSingleChoiceGroup(List<String> options, String? currentValue, Function(String) onSelected) => Wrap(
    spacing: 10, runSpacing: 10,
    children: options.map((o) => GestureDetector(
      onTap: () => onSelected(o),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(gradient: currentValue == o ? const LinearGradient(colors: [primaryColor, secondaryColor]) : null, color: currentValue == o ? null : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Text(o, style: TextStyle(color: currentValue == o ? Colors.white : Colors.black87, fontWeight: currentValue == o ? FontWeight.bold : FontWeight.normal)),
      ),
    )).toList(),
  );
}