import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../models/cart_manager.dart';
import '../../models/voucher_item.dart';
import '../checkout/voucher_selection_screen.dart';
import '../../services/order_manager.dart';
import '../../services/notification_service.dart'; // Đảm bảo import này đúng
import '../../entry_point.dart';

class PickupFlashSaleScreen extends StatefulWidget {
  final FoodItem item;
  final int quantity;

  const PickupFlashSaleScreen({super.key, required this.item, required this.quantity});

  @override
  State<PickupFlashSaleScreen> createState() => _PickupFlashSaleScreenState();
}

class _PickupFlashSaleScreenState extends State<PickupFlashSaleScreen> {
  final Color primaryPink = const Color(0xFFFF3B77);
  VoucherItem? _appliedVoucher;
  String _selectedPickupTime = "Trong 15 phút tới";

  final List<String> _timeSlots = [
    "Trong 15 phút tới",
    "Trong 30 phút tới",
    "Trong 1 giờ tới",
    "Chiều nay (17:00 - 18:00)",
  ];

  String formatVND(double price) => "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";


  void _handlePlaceOrder() {
    final firstItem = widget.item;


    final pickupOrder = OrderItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "[ĐẾN LẤY] ${firstItem.name}",
      quantity: widget.quantity,
      price: widget.item.price,
      image: firstItem.imageUrl,
      restaurantName: "BITOO Partner Store",
      address: "279 Nguyễn Tri Phương, Quận 10",
      deliveryTime: _selectedPickupTime,
      status: OrderStatus.active,
    );


    OrderManager().addOrder(pickupOrder);


    NotificationService().addNotification(
      title: "Đặt đơn thành công!",
      message: "Bạn đã đặt đơn ${firstItem.name}. Vui lòng đến lấy lúc $_selectedPickupTime.",
      type: NotificationType.order,
      icon: Icons.store,
      iconColor: Colors.pinkAccent,
    );


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Đặt đơn thành công!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text("Đơn hàng đã được chuyển vào mục 'Đang giao'.", textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => EntryPoint(key: EntryPoint.globalKey)),
                      (route) => false
              );
            },
            child: const Text("VỀ TRANG CHỦ", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = widget.item.price * widget.quantity;
    double discount = _appliedVoucher?.discountValue ?? 0.0;
    double total = (subtotal - discount).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Xác nhận đến lấy', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStoreCard(),
            _buildTimeSelector(),
            _buildItemCard(),
            _buildPromoSection(subtotal),
            _buildBillCard(subtotal, discount, total),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(total),
    );
  }

  Widget _buildStoreCard() {
    return Container(
      width: double.infinity, margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.store, color: primaryPink), const SizedBox(width: 8), const Text("ĐỊA CHỈ NHÀ HÀNG", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))]),
          const SizedBox(height: 15),
          const Text("BITOO Partner - Chi nhánh Quận 10", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text("279 Nguyễn Tri Phương, Phường 5, Quận 10, TP.HCM", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonFormField<String>(
        value: _selectedPickupTime,
        decoration: const InputDecoration(labelText: "Giờ bạn đến lấy", border: InputBorder.none),
        items: _timeSlots.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
        onChanged: (val) => setState(() => _selectedPickupTime = val!),
      ),
    );
  }

  Widget _buildItemCard() {
    return Container(
      margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(widget.item.imageUrl, width: 60, height: 60, fit: BoxFit.cover)),
        const SizedBox(width: 15),
        Expanded(child: Text("${widget.quantity}x ${widget.item.name}", style: const TextStyle(fontWeight: FontWeight.bold))),
        Text(formatVND(widget.item.price * widget.quantity)),
      ]),
    );
  }

  Widget _buildPromoSection(double subtotal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const Icon(Icons.confirmation_num, color: Colors.orange),
        title: Text(_appliedVoucher?.title ?? "Sử dụng mã giảm giá"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherSelectionScreen(currentAmount: subtotal)));
          if (res != null) setState(() => _appliedVoucher = res);
        },
      ),
    );
  }

  Widget _buildBillCard(double sub, double disc, double tot) {
    return Container(
      margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Tạm tính"), Text(formatVND(sub))]),
        const SizedBox(height: 10),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Phí dịch vụ"), Text("Miễn phí", style: TextStyle(color: Colors.blue))]),
        if (disc > 0) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Voucher"), Text("-${formatVND(disc)}", style: const TextStyle(color: Colors.green))]),
        const Divider(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("TỔNG CỘNG", style: TextStyle(fontWeight: FontWeight.bold)), Text(formatVND(tot), style: TextStyle(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 20))]),
      ]),
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryPink, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: _handlePlaceOrder, // ⭐️ Đã gọi đúng hàm xử lý
        child: const Text("XÁC NHẬN ĐẶT TRƯỚC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}