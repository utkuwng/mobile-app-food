import '../models/food_item.dart';
import '../models/restaurant_item.dart';
import 'mock_data.dart';

class DataManager {

  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;


  late final Map<String, List<FoodItem>> _allCategoryItems;
  final List<RestaurantItem> _favoriteRestaurants = [];


  DataManager._internal() {
    _allCategoryItems = generateAllCategoryItems();
  }


  Map<String, List<FoodItem>> get categoryItems => _allCategoryItems;


  List<FoodItem> get allFoodItems {
    return _allCategoryItems.values
        .expand((list) => list)
        .toList();
  }


  List<FoodItem> get favoriteItems {
    return allFoodItems.where((item) => item.isFavorite).toList();
  }


  FoodItem? findItemById(String id) {
    try {
      return allFoodItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }


  void toggleFavorite(String foodId) {

    for (var key in _allCategoryItems.keys) {
      List<FoodItem> list = _allCategoryItems[key]!;

      for (int i = 0; i < list.length; i++) {
        if (list[i].id == foodId) {

          list[i] = list[i].copyWith(isFavorite: !list[i].isFavorite);
          print("Đã đổi trạng thái tim món ${list[i].name} thành: ${list[i].isFavorite}");
          return;
        }
      }
    }
  }




  List<RestaurantItem> get favoriteRestaurants => _favoriteRestaurants;


  bool isRestaurantFavorite(String resName) {
    return _favoriteRestaurants.any((r) => r.name == resName);
  }


  void toggleRestaurantFavorite(RestaurantItem restaurant) {
    if (isRestaurantFavorite(restaurant.name)) {

      _favoriteRestaurants.removeWhere((r) => r.name == restaurant.name);
      print("Đã xóa nhà hàng ${restaurant.name} khỏi yêu thích");
    } else {

      _favoriteRestaurants.add(restaurant);
      print("Đã thêm nhà hàng ${restaurant.name} vào yêu thích");
    }
  }
}