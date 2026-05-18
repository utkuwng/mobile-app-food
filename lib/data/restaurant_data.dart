import '../models/restaurant_item.dart';
import '../models/food_item.dart';
import 'mock_data.dart';

class RestaurantDataManager {

  static final RestaurantDataManager _instance = RestaurantDataManager._internal();
  factory RestaurantDataManager() => _instance;


  late final Map<String, List<RestaurantItem>> _groupedRestaurants;
  late final List<RestaurantItem> _allRestaurantsList;

  RestaurantDataManager._internal() {

    _groupedRestaurants = _generateAndGroupRestaurants();

    _allRestaurantsList = _groupedRestaurants.values.expand((list) => list).toList();
  }


  Map<String, List<RestaurantItem>> get groupedRestaurants => _groupedRestaurants;
  List<RestaurantItem> get allRestaurants => _allRestaurantsList;


  Map<String, List<RestaurantItem>> _generateAndGroupRestaurants() {
    final allCategoryItems = generateAllCategoryItems();
    Map<String, List<RestaurantItem>> groupedData = {};

    allCategoryItems.forEach((category, foodList) {
      List<RestaurantItem> restaurants = [];
      List<String> names = _restaurantNames[category] ?? [];


      int itemsPerRes = names.isNotEmpty ? (foodList.length / names.length).floor() : 0;

      for (int i = 0; i < names.length; i++) {
        int startIndex = i * itemsPerRes;
        int endIndex = (i == names.length - 1) ? foodList.length : startIndex + itemsPerRes;

        List<FoodItem> subMenu = foodList.sublist(startIndex, endIndex);

        String resId = "${category.toLowerCase().replaceAll('/', '_')}_res_$i";

        restaurants.add(RestaurantItem(
          id: resId,
          name: names[i],
          imageUrl: subMenu.isNotEmpty ? subMenu[0].imageUrl : "assets/images/default.jpg",
          rating: 4.5 + (i % 5) * 0.1,
          reviewCount: 100 + (i * 25),
          distance: (1.0 + i * 0.4).toStringAsFixed(1),
          deliveryTime: "${15 + i * 2}-${25 + i * 2}'",
          menu: subMenu,
        ));
      }
      groupedData[category] = restaurants;
    });

    return groupedData;
  }

  final Map<String, List<String>> _restaurantNames = {
    "Cơm": ["Cơm Nhà Gió Bếp", "Cơm Bếp Xưa Sài Gòn", "Cơm Thố Đậm Đà", "Cơm Mộc Quán", "Cơm Nóng Ba Gian", "Cơm Quê Góc Phố", "Cơm Bếp Việt 1988", "Cơm Niêu Lửa Hồng", "Cơm Nhà Mình", "Cơm Sạch An Nhiên"],
    "Bún/Phở": ["Phở Bò Gia Truyền Ký", "Bún Bò Huế Cố Đô", "Bún Chả Hàng Tre", "Phở Bát Đá Quán", "Bún Đậu Làng Mơ", "Bún Riêu Cua Đồng 36", "Phở Xưa Phố Cổ", "Bún Mọc Bếp Việt", "Bún Quậy Biển Xanh", "Phở Gánh Đêm"],
    "Bánh mì": ["Bánh Mì Lò Than Xưa", "Bánh Mì Góc Phố 79", "Bánh Mì Bếp Việt", "Bánh Mì Ông Ba", "Bánh Mì Que Hải Phòng", "Bánh Mì Kebab Istanbul", "Bánh Mì Phố Cổ", "Bánh Mì Chảo 5 Sao", "Bánh Mì Nem Nướng Nha Trang", "Bánh Mì Heo Quay Lửa Hồng"],
    "Gà rán": ["Gà Rán Golden Fry", "Chicken House Korea", "Happy Bee Chicken", "Louisiana Fried Chicken", "Texas Crispy Chicken", "Burger & Chicken Hub", "Gà Rán Oppa", "Doner Chicken", "Papa Crispy Chicken", "K-Chicken Street"],
    "Trà sữa": ["Trà Sữa Moon Tea", "Milk Tea Koi House", "Ding Ding Tea", "Alley Milk Tea", "Toco Fresh Tea", "Boba Pop House", "Phê Trà Corner", "Snowy Ice Cream & Tea", "Brown Sugar Milk Tea", "Phúc An Tea & Coffee"],
    "Cà phê": ["Nhà Cà Phê Phố Nhỏ", "Cao Nguyên Coffee", "Huyền Thoại Cà Phê Việt", "Cà Phê Xưa", "Sài Gòn Kafe 1987", "Urban Brew Coffee", "Cheese & Bean Coffee", "Góc Phố Coffee", "Laha Brew House", "Rang Xay Thủ Công"],
    "Đồ chay": ["Chay An Lạc Quán", "Bếp Chay Tĩnh Tâm", "Cơm Chay Hương Thiền", "Lẩu Nấm Chay Bình An", "Chay Sen Việt", "Bếp Chay Từ Bi", "Tiệm Chay Hoan Nhiên", "Chay Mộc Nhiên", "Cơm Chay Thiện Duyên", "Lẩu Chay Phúc Lành"],
    "Healthy": ["Green Bowl Kitchen", "Eat Clean Corner", "Healthy Meal Box", "Fresh Poke Bowl", "Salad & More Bar", "Green Fresh Kitchen", "Bếp Xanh Lành Mạnh", "Nutri Fit House", "Grain Balance", "Pure Life Bowl"],
    "Pizza": ["Pizza Oven House", "Italian Pizza Corner", "Cheesy Crust Pizza", "Woodfire Pizza Lab", "Pizza Italiano", "Pizza Logic House", "Basta Pizza Bistro", "Pepperoni Street Pizza", "Cowboy Steak & Pizza", "Alfresco Italian Kitchen"],
    "Món Hàn": ["K-Town Topokki", "Seoul BBQ House", "King Grill Korea", "K-Pub Street Food", "Sườn Nướng Hàn Phố", "Garden Seoul BBQ", "Busan Kitchen", "Hanok Korean Food", "Korea Grill Bornga", "Seoul Home Kitchen"],
    "Món Nhật": ["Sushi Sakura House", "Hokkaido Fresh Kitchen", "Ichi Sushi", "Manwa Japanese Hotpot", "Udon Maru", "Tokyo Bento Deli", "Sushi Tora", "Tano Japanese Kitchen", "Hatoya Sushi Bar", "Yen Japanese Dining"],
    "Lẩu/Nướng": ["Hotpot Master House", "Taiwan Pot Corner", "Kichi Hotpot Express", "Ashima Mushroom Pot", "Lẩu Phố Gia Truyền", "Panda Grill & Pot", "Buk Buk BBQ House", "Lẩu Cá Biển Quán", "Lẩu Gà Lá É Cao Nguyên", "Ba Cừu Hotpot"],
    "Ăn vặt": ["Bánh Tráng Góc Phố", "Ốc Đêm Sài Gòn", "Phá Lấu Lòng Ngon", "Cá Viên Chiên Gia Vị", "Bắp Xào Phố Nhỏ", "Nem Chua Rán Vỉa Hè", "Xoài Lắc Muối Ớt", "Hột Vịt Lộn Đêm Khuya", "Da Heo Cháy Tỏi", "Ăn Vặt Tuổi Thơ"],
    "Tráng miệng": ["Chè Thái Hương Sen", "Kem Phố Cổ", "Bánh Flan Nhà Làm", "Chè Khúc Bạch An Nhiên", "Hồng Trà Ngọt Lành", "Dessert 1988", "Modern Sweet House", "Black Sugar Dessert", "Xôi Xoài Nhiệt Đới", "Rau Câu Thanh Mát"],
  };
}