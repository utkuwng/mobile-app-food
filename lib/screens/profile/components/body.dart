import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ueh_food_delivery/models/food_item.dart';
import 'package:ueh_food_delivery/data/data_manager.dart';
import 'package:ueh_food_delivery/screens/profile/payment_methods_screen.dart';

import 'package:ueh_food_delivery/screens/favorites/favorites_screen.dart';
import 'package:ueh_food_delivery/screens/profile/security_account_screen.dart';
import '../../profile/address_screen.dart';
import '../../profile/offer_screen.dart';
import '../../profile/invite_friends_screen.dart';
import '../edit_profile_screen.dart';
import '../../auth/sign_in/sign_in_screen.dart';
// ⭐️ IMPORT STATS MANAGER
import 'package:ueh_food_delivery/screens/profile/user_stats_manager.dart';
import 'package:ueh_food_delivery/services/order_manager.dart';
import 'package:ueh_food_delivery/screens/orderDetails/order_details_screen.dart'; // Đảm bảo đúng đường dẫn

const primaryColor = Color(0xFFFF5283);
const backgroundColor = Color(0xFFF5F7FA);
const cardColor = Colors.white;
const textPrimary = Color(0xFF1A1A1A);
const textSecondary = Color(0xFF757575);

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _fullName = "Andrew Ainsley";
  String _email = "andrew.ainsley@yourdomain.com";
  String _avatarUrl = "https://i.pravatar.cc/150?img=12";


  int _totalOrders = 0;
  int _totalPoints = 0;
  int _totalVouchers = 0;

  final UserStatsManager _statsManager = UserStatsManager();

  @override
  void initState() {
    super.initState();
    _loadLocalProfileData();
    _loadUserStats();
  }

  Future<void> _loadLocalProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _fullName = prefs.getString('profile_name') ?? "Andrew Ainsley";
        _email = prefs.getString('profile_email') ?? "andrew.ainsley@yourdomain.com";
        _avatarUrl = prefs.getString('profile_avatar_url') ?? "https://i.pravatar.cc/150?img=12";
      });
    }
  }


  Future<void> _loadUserStats() async {
    final orders = await _statsManager.getTotalOrders();
    final points = await _statsManager.getTotalPoints();
    final vouchers = await _statsManager.getTotalVouchers();

    if (mounted) {
      setState(() {
        _totalOrders = orders;
        _totalPoints = points;
        _totalVouchers = vouchers;
      });
    }
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
    if (result == true) {
      _loadLocalProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 260,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, Color(0xFFFF3366)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 14),
                      _buildAvatarSection(),
                      const SizedBox(height: 6),
                      Text(
                        _fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildEditProfileButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),

                _buildStatsSection(),

                const SizedBox(height: 24),


                _buildMenuCard(
                  title: "Hoạt động",
                  items: [
                    _MenuItem(
                      icon: Icons.favorite_rounded,
                      gradient: const LinearGradient(colors: [Color(0xFFFF6B9D), Color(0xFFFFC371)]),
                      title: "Món yêu thích",
                      subtitle: "Danh sách yêu thích của bạn",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FavoritesScreen(
                            ),
                          ),
                        );
                      },
                    ),
                    _MenuItem(
                      icon: Icons.local_offer_rounded,
                      gradient: const LinearGradient(colors: [Color(0xFFFFB75E), Color(0xFFED8F03)]),
                      title: "Ưu đãi & Khuyến mãi",
                      subtitle: "Xem các ưu đãi hấp dẫn",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OfferScreen()),
                      ),
                    ),
                    _MenuItem(
                      icon: Icons.account_balance_wallet_rounded,
                      gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                      title: "Phương thức thanh toán",
                      subtitle: "Quản lý thanh toán",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildMenuCard(
                  title: "Tài khoản",
                  items: [
                    _MenuItem(
                      icon: Icons.location_on_rounded,
                      gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                      title: "Địa chỉ giao hàng",
                      subtitle: "Quản lý địa chỉ nhận hàng",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddressScreen()),
                      ),
                    ),
                    _MenuItem(
                      icon: Icons.security_rounded,
                      gradient: const LinearGradient(colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)]),
                      title: "Bảo mật & Tài khoản",
                      subtitle: "Cài đặt bảo mật",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SecurityAccountScreen()),
                      ),
                    ),
                    _MenuItem(
                      icon: Icons.person_add_rounded,
                      gradient: const LinearGradient(colors: [Color(0xFFFA709A), Color(0xFFFEE140)]),
                      title: "Mời bạn bè",
                      subtitle: "Chia sẻ và nhận ưu đãi",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const InviteFriendsScreen()),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildMenuCard(
                  title: "Cài đặt",
                  items: [
                    _MenuItem(
                      icon: Icons.language_rounded,
                      gradient: const LinearGradient(colors: [Color(0xFF606C88), Color(0xFF3F4C6B)]),
                      title: "Ngôn ngữ",
                      subtitle: "Tiếng Việt",
                      trailing: const Icon(Icons.chevron_right, color: textSecondary),
                      onTap: () {},
                    ),

                  ],
                ),

                const SizedBox(height: 24),

                _buildLogoutButton(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_avatarUrl),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _navigateToEditProfile,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: primaryColor,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToEditProfile,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.edit, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  "Chỉnh sửa hồ sơ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildStatsSection() {
    final orderManager = OrderManager();

    int completedCount = orderManager.allOrders.where((o) => o.status == OrderStatus.completed).length;

    int totalPoints = completedCount * 100;

    int totalVouchers = 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [

          Expanded(
            child: _buildStatCard(
              icon: Icons.shopping_bag_rounded,
              title: "Đơn hàng",
              value: "$completedCount",
              color: const Color(0xFF667EEA),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderDetailsScreen(initialTabIndex: 1),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),


          Expanded(
            child: _buildStatCard(
              icon: Icons.star_rounded,
              title: "Điểm thưởng",
              value: "$totalPoints",
              color: const Color(0xFFFFB75E),
              onTap: () {

              },
            ),
          ),
          const SizedBox(width: 12),


          Expanded(
            child: _buildStatCard(
              icon: Icons.local_offer_rounded,
              title: "Voucher",
              value: "$totalVouchers",
              color: const Color(0xFFFF6B9D),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OfferScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showPointsDetail() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB75E).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB75E),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Điểm thưởng của bạn",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "$_totalPoints điểm",
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFB75E),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Đơn hàng hoàn thành:",
                        style: TextStyle(color: textSecondary),
                      ),
                      Text(
                        "$_totalOrders đơn",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Điểm/đơn hàng:",
                        style: TextStyle(color: textSecondary),
                      ),
                      const Text(
                        "+5 điểm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "💡 Mỗi đơn hàng thành công bạn sẽ nhận 5 điểm thưởng!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Đóng",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({required String title, required List<_MenuItem> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: List.generate(
                items.length,
                    (index) => Column(
                  children: [
                    _buildMenuItem(items[index]),
                    if (index < items.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 72),
                        child: Divider(height: 1, color: Colors.grey[200]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: item.gradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              item.trailing ??
                  const Icon(
                    Icons.chevron_right,
                    color: textSecondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showLogoutModal(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout_rounded, color: Colors.red, size: 22),
                  SizedBox(width: 12),
                  Text(
                    "Đăng xuất",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Đăng xuất",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Bạn có chắc chắn muốn đăng xuất\nkhỏi tài khoản?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: textSecondary),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                          (route) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Đăng xuất",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Gradient gradient;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });
}