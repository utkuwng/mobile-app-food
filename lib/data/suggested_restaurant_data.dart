import '../models/food_item.dart';
import 'mock_data.dart';

List<FoodItem> getSuggestedRestaurants({int limit = 12}) {
  final allCategories = generateAllCategoryItems();

  final allItems = allCategories.values.expand((e) => e).toList();


  final suggested = allItems
      .where((item) => item.rating >= 4.5)
      .toList()
    ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));

  return suggested.take(limit).toList();
}

List<Map<String, dynamic>> getSuggestedRestaurantMenu({int limit = 12}) {
  final items = getSuggestedRestaurants(limit: limit);

  return items.map((item) => {
    "name": item.name,
    "desc": item.description,
    "price": item.price,

    "oldPrice": item.price + 15000,
    "img": item.imageUrl,
    "type": _mapSuggestedType(item),
  }).toList();
}
String _mapSuggestedType(FoodItem item) {
  return item.name.toLowerCase().contains("combo") ? "Combo" : "Đơn";
}

