import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/order_manager.dart';
import '../../data/data_manager.dart';
import '../../models/food_item.dart';
import '../food_detail/food_detail_screen.dart';

const primaryColor = Color.fromRGBO(255, 82, 131, 1);
const backgroundColor = Color(0xFFF5F5F5);

class VoucherItem {
  final String title;
  final String description;
  final String requirement;
  final String expiration;
  final String type;
  final String source;

  VoucherItem({
    required this.title,
    required this.description,
    required this.requirement,
    required this.expiration,
    required this.type,
    required this.source,
  });
}

final List<VoucherItem> allVouchers = [
  VoucherItem(
    title: "Mã giảm 20% trên giá món (Tối đa 50k)",
    description: "Ưu đãi có hạn",
    requirement: "Đặt tối thiểu 50.000đ",
    expiration: "HSD: 31/12/2025",
    type: "Giảm giá món",
    source: "Quán chọn lọc",
  ),
  VoucherItem(
    title: "Giảm 15k phí vận chuyển",
    description: "Freeship cho đơn hàng",
    requirement: "Đơn từ 40.000đ",
    expiration: "Hết hạn trong: 24 giờ",
    type: "Phí vận chuyển",
    source: "Quán chọn lọc",
  ),
];

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPoints = 0;
  double _convertedValue = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _calculatePoints();
  }

  void _calculatePoints() {
    final orderManager = OrderManager();
    int completedCount = orderManager.allOrders.where((o) => o.status == OrderStatus.completed).length;
    _currentPoints = completedCount * 100;
    _convertedValue = _currentPoints * 33.34;
  }

  String formatVND(double price) {
    return "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showVoucherDetailsDialog(BuildContext context, VoucherItem voucher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow(Icons.source_outlined, 'Nguồn', voucher.source),
                _buildDetailRow(Icons.check_circle_outline, 'Yêu cầu', voucher.requirement),
                _buildDetailRow(Icons.history_toggle_off, 'Hạn sử dụng', voucher.expiration),
                _buildDetailRow(Icons.category_outlined, 'Loại', voucher.type),
                _buildDetailRow(Icons.description_outlined, 'Mô tả', voucher.description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Ưu đãi & Khuyến mãi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: const [Tab(text: "Tất cả"), Tab(text: "Giảm giá món"), Tab(text: "Phí vận chuyển")],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildPointHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVoucherList(allVouchers),
                _buildVoucherList(allVouchers.where((v) => v.type == 'Giảm giá món').toList()),
                _buildVoucherList(allVouchers.where((v) => v.type == 'Phí vận chuyển').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherList(List<VoucherItem> vouchers) {
    if (vouchers.isEmpty) {
      return Center(child: Text("Không có ưu đãi nào thuộc loại này.", style: TextStyle(color: Colors.grey[600])));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vouchers.length,
      itemBuilder: (context, index) => _buildOfferCard(vouchers[index]),
    );
  }

  Widget _buildPointHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFDF2F5),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.white, Color(0xFFFFF0F5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
          border: Border.all(color: primaryColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: const Color(0xFFFFECB3), shape: BoxShape.circle, border: Border.all(color: Colors.amber, width: 2), boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 8)]),
              child: const Icon(Icons.stars_rounded, color: Colors.amber, size: 32),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("$_currentPoints", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87)),
                      const SizedBox(width: 5),
                      const Text("điểm", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(4)),
                        child: Text("≈ ${formatVND(_convertedValue)}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[700])),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text("Điểm sẽ hết hạn vào 31/12/2025", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(VoucherItem voucher) {
    final bool isPartner = voucher.source == 'Quán đối tác';
    final Color tagColor = isPartner ? const Color(0xFFFEE440) : primaryColor;
    final IconData icon = voucher.type == 'Giảm giá món' ? Icons.restaurant : Icons.local_shipping;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 90,
              decoration: BoxDecoration(
                color: isPartner ? const Color(0xFFFEE440) : primaryColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: 32), const SizedBox(height: 6), Text(isPartner ? "ĐỐI TÁC" : "BITOO", textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1))])),
                  ...List.generate(6, (index) => Positioned(top: index * 18.0 + 8, right: -6, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle)))),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text(voucher.requirement, style: TextStyle(fontSize: 12, color: Colors.grey[600]))]),
                    const SizedBox(height: 8),
                    Row(children: [Expanded(child: Text(voucher.expiration, style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.w600))), GestureDetector(onTap: () => _showVoucherDetailsDialog(context, voucher), child: const Text("Điều kiện", style: TextStyle(fontSize: 11, color: Colors.blue, decoration: TextDecoration.underline)))]),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherApplicableItemsScreen(voucher: voucher)));
              },
              child: Container(
                width: 50,
                // ⭐️ FIX LỖI BORDERSTYLE Ở ĐÂY: Dùng solid thay vì dashed
                decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey[200]!, style: BorderStyle.solid, width: 1))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Dùng\nngay", textAlign: TextAlign.center, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 11)), const SizedBox(height: 4), Icon(Icons.arrow_forward_ios, size: 12, color: primaryColor.withOpacity(0.5))]),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class VoucherApplicableItemsScreen extends StatelessWidget {
  final VoucherItem voucher;
  const VoucherApplicableItemsScreen({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final List<FoodItem> allItems = List<FoodItem>.from(DataManager().allFoodItems)..shuffle();
    final applicableItems = allItems.take(10).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Áp dụng cho", style: TextStyle(color: Colors.black, fontSize: 14)), Text(voucher.title, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16))]),
        backgroundColor: Colors.white, elevation: 0.5, iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: applicableItems.length,
        itemBuilder: (context, index) {
          final item = applicableItems[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailScreen(item: item, relatedItems: allItems))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
              child: Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(item.imageUrl, width: 90, height: 90, fit: BoxFit.cover)),
                const SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1),
                  const SizedBox(height: 4), Text(item.description, style: TextStyle(color: Colors.grey[600], fontSize: 12), maxLines: 1),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${item.price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ", style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)), Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white, size: 18))])
                ]))
              ]),
            ),
          );
        },
      ),
    );
  }
}