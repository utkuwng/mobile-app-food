import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screens/home/home_screen.dart';
import 'screens/orderDetails/order_details_screen.dart'; // Kiểm tra lại đường dẫn cho đúng project của bạn
import 'screens/profile/profile_screen.dart';
import 'screens/search/search_screen.dart';

class EntryPoint extends StatefulWidget {
  static final GlobalKey<EntryPointState> globalKey = GlobalKey<EntryPointState>();

  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => EntryPointState();
}

class EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;

  Widget _currentSearchScreen = const SearchScreen();

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _updateScreens();
  }

  void _updateScreens() {
    _screens = [
      const HomeScreen(),
      _currentSearchScreen,
      const OrderDetailsScreen(),
      const ProfileScreen(),
    ];
  }

  void jumpToSearch({
    String? category,
    RangeValues? priceRange,
    String? distance,
    String? time,
    String? fee,
    List<String>? promos,
  }) {
    setState(() {
      _currentSearchScreen = SearchScreen(
        initCategory: category,
        initPriceRange: priceRange,
        initDistance: distance,
        initTime: time,
        initFee: fee,
        initPromos: promos,
      );
      _updateScreens();
      _selectedIndex = 1;
    });
  }

  final List<Map<String, dynamic>> _navitems = [
    {"icon": "assets/icons/home.svg", "title": "Trang chủ"},
    {"icon": "assets/icons/search.svg", "title": "Tìm kiếm"},
    {"icon": "assets/icons/order.svg", "title": "Đơn hàng"},
    {"icon": "assets/icons/profile.svg", "title": "Hồ sơ"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF5283),
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: List.generate(
          _navitems.length,
              (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _navitems[index]["icon"],
              colorFilter: ColorFilter.mode(
                index == _selectedIndex ? const Color(0xFFFF5283) : const Color(0xFF868686),
                BlendMode.srcIn,
              ),
            ),
            label: _navitems[index]["title"],
          ),
        ),
      ),
    );
  }
}