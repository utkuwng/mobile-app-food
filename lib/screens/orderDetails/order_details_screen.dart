import 'package:flutter/material.dart';
import '../../services/order_manager.dart';
import '../food_detail/order_tracking_screen.dart';
import '../food_detail/delivery_flash_sale.dart';
import '../../models/cart_manager.dart';
import '../../models/food_item.dart';
import '../../models/cart_item.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int initialTabIndex;
  const OrderDetailsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final orderManager = OrderManager();
  final Color primaryPink = const Color(0xFFFF3B77);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatVND(double price) {
    return "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = orderManager.allOrders.where((o) => o.status == OrderStatus.active).toList();
    final completedOrders = orderManager.allOrders.where((o) => o.status == OrderStatus.completed).toList();
    final cancelledOrders = orderManager.allOrders.where((o) => o.status == OrderStatus.cancelled).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Đơn hàng", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TabBar(
            controller: _tabController,
            labelColor: primaryPink,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryPink,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Đang giao (${activeOrders.length})"),
              Tab(text: "Hoàn tất (${completedOrders.length})"),
              Tab(text: "Đã hủy (${cancelledOrders.length})"),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(activeOrders, canTrack: true),
          _buildOrderList(completedOrders, canTrack: false),
          _buildOrderList(cancelledOrders, canTrack: false),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderItem> orders, {required bool canTrack}) {
    if (orders.isEmpty) return _buildEmptyState();
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, canTrack);
      },
    );
  }

  Widget _buildOrderCard(OrderItem item, bool canTrack) {
    // ⭐️ LOGIC NHẬN DIỆN ĐƠN ĐẾN LẤY
    bool isPickupOrder = item.title.contains("[ĐẾN LẤY]");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(item.image, width: 75, height: 75, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 75, height: 75, color: Colors.grey[100], child: const Icon(Icons.restaurant, color: Colors.grey))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text("${item.quantity} món | ${item.restaurantName}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(formatVND(item.price * item.quantity), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryPink)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (canTrack) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCancelDialog(item),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: const Text("Hủy đơn", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ),

                // ⭐️ CHỈ HIỂN THỊ NÚT THEO DÕI NẾU KHÔNG PHẢI LÀ ĐƠN ĐẾN LẤY
                if (!isPickupOrder) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderData: item, initialStage: 1))).then((_) => setState(() {}));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primaryPink, foregroundColor: Colors.white, elevation: 8, shadowColor: primaryPink.withOpacity(0.5), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      child: const Text("Theo dõi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],

                if (isPickupOrder) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCompletePickupDialog(item);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      child: const Text("Đã nhận món", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ],
            ),
          ] else if (item.status == OrderStatus.completed) ...[

            _buildReorderButton(item),
          ],
        ],
      ),
    );
  }

  Widget _buildReorderButton(OrderItem item) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          final foodPlaceholder = FoodItem(
            id: item.id,
            name: item.title.replaceAll("[ĐẾN LẤY] ", ""),
            price: item.price,
            imageUrl: item.image,
            description: "Sản phẩm đặt lại",
            rating: 5.0,
            reviewCount: 100,
            deliveryTime: item.deliveryTime,
            restaurantName: item.restaurantName,
          );

          final reorderItem = CartItem(food: foodPlaceholder, quantity: item.quantity);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DeliveryFlashSaleScreen(
                    selectedItems: [reorderItem],
                  )
              )
          );
        },
        icon: const Icon(Icons.refresh, size: 18),
        label: const Text("ĐẶT LẠI MÓN", style: TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryPink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        ),
      ),
    );
  }

  void _showCompletePickupDialog(OrderItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận nhận hàng"),
        content: const Text("Bạn đã đến quán và nhận món thành công?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Chưa")),
          TextButton(
            onPressed: () {
              orderManager.markAsCompleted(item.id);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Xác nhận", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(OrderItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hủy đơn hàng?"),
        content: Text("Bạn có chắc chắn muốn hủy đơn hàng ${item.title} không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Quay lại")),
          TextButton(onPressed: () { orderManager.cancelOrder(item.id); setState(() {}); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã hủy đơn hàng thành công"))); }, child: const Text("Xác nhận hủy", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[300]), const SizedBox(height: 16), const Text("Chưa có đơn hàng", style: TextStyle(color: Colors.grey, fontSize: 16))]));
  }
}