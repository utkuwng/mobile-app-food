import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/models/restaurant_item.dart';
import 'package:ueh_food_delivery/data/data_manager.dart';
import '../food_detail/suggested_restaurant.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {


  List<RestaurantItem> get _favoriteRestaurants => DataManager().favoriteRestaurants;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
            "Nhà hàng yêu thích",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _favoriteRestaurants.isEmpty
          ? _buildEmptyState()
          : _buildRestaurantList(),
    );
  }

  Widget _buildRestaurantList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _favoriteRestaurants.length,
      itemBuilder: (context, index) {
        final res = _favoriteRestaurants[index];
        // Vuốt để xóa
        return Dismissible(
          key: Key(res.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.redAccent,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            setState(() {
              DataManager().toggleRestaurantFavorite(res);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Đã xóa ${res.name} khỏi yêu thích")),
            );
          },
          child: _buildRestaurantCard(res),
        );
      },
    );
  }

  Widget _buildRestaurantCard(RestaurantItem res) {
    return GestureDetector(
      onTap: () async {

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SuggestedRestaurantScreen(
              restaurantName: res.name,
              restaurantMenu: res.menu,

              initRating: res.rating,
              initTime: res.deliveryTime,
              initDistance: res.distance,
            ),
          ),
        );

        if (mounted) setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    res.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => Container(height: 150, color: Colors.grey[200]),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {

                        DataManager().toggleRestaurantFavorite(res);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Color(0xFFFF5283),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          res.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142)
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "${res.rating}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(res.deliveryTime, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("${res.distance}km", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  )
                ],
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5283).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border, size: 50, color: Color(0xFFFF5283)),
          ),
          const SizedBox(height: 16),
          const Text(
            "Chưa có nhà hàng yêu thích!",
            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            "Hãy thả tim các quán ngon để lưu lại nhé.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}