import 'food_item.dart';

class RestaurantItem {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String distance;
  final String deliveryTime;
  final List<FoodItem> menu;

  RestaurantItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.deliveryTime,
    required this.menu,
  });
}