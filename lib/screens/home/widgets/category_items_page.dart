import 'package:flutter/material.dart';
import '../../../models/restaurant_item.dart';
import '../../food_detail/suggested_restaurant.dart';

class CategoryItemsPage extends StatefulWidget {
  final String categoryName;
  final List<RestaurantItem> restaurants;

  const CategoryItemsPage({
    super.key,
    required this.categoryName,
    required this.restaurants,
  });

  @override
  State<CategoryItemsPage> createState() => _CategoryItemsPageState();
}

class _CategoryItemsPageState extends State<CategoryItemsPage> {

  bool _filterHighRating = false;
  bool _filterNearMe = false;
  bool _filterFastDelivery = false;

  final Color primaryColor = const Color(0xFFFF5283);
  final Color secondaryColor = const Color(0xFFFF3366);
  final Color backgroundColor = const Color(0xFFF8F9FC);


  List<RestaurantItem> get _displayRestaurants {
    List<RestaurantItem> result = List.from(widget.restaurants);


    if (_filterHighRating) {
      result = result.where((res) => res.rating >= 4.5).toList();
    }


    if (_filterNearMe) {
      result = result.where((res) {

        double dist = double.tryParse(res.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
        return dist <= 2.0;
      }).toList();
    }

    if (_filterFastDelivery) {
      result = result.where((res) {
        try {

          final numbers = RegExp(r'\d+').allMatches(res.deliveryTime).map((m) => int.parse(m.group(0)!)).toList();

          if (numbers.isEmpty) return false;

          int maxTime = numbers.reduce((curr, next) => curr > next ? curr : next);

          return maxTime <= 25;
        } catch (e) {
          return false;
        }
      }).toList();
    }


    result.sort((a, b) => b.rating.compareTo(a.rating));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = _displayRestaurants;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
        ),
      ),
      body: Column(
        children: [

          _buildFilterBar(),

          Expanded(
            child: listToShow.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: listToShow.length,
              itemBuilder: (context, index) => _buildArtisticRestaurantCard(listToShow[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFilterChip('Đánh giá 4.5+', _filterHighRating, Icons.star_rounded, () {
            setState(() => _filterHighRating = !_filterHighRating);
          }),
          const SizedBox(width: 10),
          _buildFilterChip('Gần bạn', _filterNearMe, Icons.location_on_rounded, () {
            setState(() => _filterNearMe = !_filterNearMe);
          }),
          const SizedBox(width: 10),
          _buildFilterChip('Giao nhanh (≤25\')', _filterFastDelivery, Icons.flash_on_rounded, () {
            setState(() => _filterFastDelivery = !_filterFastDelivery);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(colors: [primaryColor, secondaryColor])
              : null,
          color: isActive ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: isActive ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisticRestaurantCard(RestaurantItem res) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SuggestedRestaurantScreen(
            restaurantName: res.name,
            restaurantMenu: res.menu,

            initRating: res.rating,
            initTime: res.deliveryTime,
            initDistance: "${res.distance}km",
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Image.asset(
                    res.imageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          res.rating.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      res.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142)
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.blue[300]),
                        const SizedBox(width: 4),
                        Text(
                          '${res.distance} km',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time_filled, size: 14, color: Colors.orangeAccent),
                        const SizedBox(width: 4),
                        Text(
                          res.deliveryTime,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text("Không tìm thấy quán phù hợp", style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}