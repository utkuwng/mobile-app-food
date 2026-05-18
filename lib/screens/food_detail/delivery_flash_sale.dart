import 'package:flutter/material.dart';
import '../../models/cart_manager.dart';
import '../../models/cart_item.dart';
import '../../models/food_item.dart';
import '../../models/voucher_item.dart';
import '../checkout/voucher_selection_screen.dart';
import '../profile/address_screen.dart';
import 'order_tracking_screen.dart';
import '../../services/order_manager.dart';

class DeliveryFlashSaleScreen extends StatefulWidget {
  final List<CartItem>? selectedItems;

  const DeliveryFlashSaleScreen({super.key, this.selectedItems});

  @override
  State<DeliveryFlashSaleScreen> createState() => _DeliveryFlashSaleScreenState();
}

class _DeliveryFlashSaleScreenState extends State<DeliveryFlashSaleScreen> {
  late AddressItem _selectedAddress;

  final Color primaryPink = const Color(0xFFFF3B77);
  final Color bgGrey = const Color(0xFFF8F8F8);
  final cart = CartManager();
  final TextEditingController _noteController = TextEditingController();

  VoucherItem? _appliedVoucher;
  late List<CartItem> _displayItems;

  int _selectedDeliveryIndex = 1;
  final List<Map<String, dynamic>> _deliveryOptions = [
    {"title": "Hỏa tốc", "time": "15 phút", "fee": 35000.0, "icon": Icons.bolt},
    {"title": "Nhanh", "time": "25 phút", "fee": 20000.0, "icon": Icons.moped},
    {"title": "Tiết kiệm", "time": "45 phút", "fee": 12000.0, "icon": Icons.eco},
  ];

  String formatVND(double price) => "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";

  @override
  void initState() {
    super.initState();

    _selectedAddress = globalAddressList.firstWhere((a) => a.isDefault, orElse: () => globalAddressList[0]);


    if (widget.selectedItems != null && widget.selectedItems!.isNotEmpty) {
      _displayItems = widget.selectedItems!;
    } else {
      _displayItems = List.from(cart.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = _displayItems.fold(0, (sum, item) => sum + (item.food.price * item.quantity));
    double deliveryFee = (_deliveryOptions[_selectedDeliveryIndex]['fee'] as num).toDouble();
    double discount = _appliedVoucher?.discountValue ?? 0.0;
    double total = (subtotal + deliveryFee - discount).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context)
        ),
        title: const Text('Xác nhận đơn hàng', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDeliveryAddressCard(),
            _buildDeliveryTimeSelector(),
            _buildOrderNote(),
            _buildOrderItemsCard(),
            _buildPromoSection(subtotal),
            _buildPaymentDetailCard(subtotal, deliveryFee, discount, total),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(total, subtotal, discount),
    );
  }


  Widget _buildDeliveryAddressCard() {
    return Container(
      width: double.infinity, margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)]),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressScreen()));
          if (result != null && result is AddressItem) setState(() => _selectedAddress = result);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [Icon(Icons.near_me, color: primaryPink, size: 18), const SizedBox(width: 8), const Text("GIAO ĐẾN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11))]),
                const Text("Thay đổi", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
              ]),
              const SizedBox(height: 15),
              Row(children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: primaryPink.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.location_on, color: primaryPink, size: 24)),
                const SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_selectedAddress.detailAddress, style: const TextStyle(fontWeight: FontWeight.bold)), Text('${_selectedAddress.contactName} • ${_selectedAddress.contactPhone}', style: const TextStyle(color: Colors.grey, fontSize: 13))])),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryTimeSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Text("TỐC ĐỘ GIAO HÀNG", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11))),
      SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 16),
          itemCount: _deliveryOptions.length,
          itemBuilder: (context, index) {
            bool isSelected = _selectedDeliveryIndex == index;
            var option = _deliveryOptions[index];
            return GestureDetector(
              onTap: () => setState(() => _selectedDeliveryIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250), width: 140, margin: const EdgeInsets.only(right: 12, bottom: 10),
                decoration: BoxDecoration(color: isSelected ? primaryPink : Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? primaryPink : Colors.grey.shade200)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(option['icon'], color: isSelected ? Colors.white : primaryPink),
                  Text(option['title'], style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                  Text(option['time'], style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 11)),
                  Text(formatVND(option['fee']), style: TextStyle(color: isSelected ? Colors.white : primaryPink, fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildOrderNote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(children: [
        const Icon(Icons.edit_note, color: Colors.grey),
        const SizedBox(width: 12),
        const Text("Ghi chú: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: TextField(controller: _noteController, decoration: const InputDecoration(hintText: "Thêm ghi chú của bạn...", border: InputBorder.none, hintStyle: TextStyle(fontSize: 14)))),
      ]),
    );
  }

  Widget _buildOrderItemsCard() {
    return Container(
      margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("MÓN ĐÃ CHỌN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const Divider(height: 25),
        ..._displayItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(item.food.imageUrl, width: 50, height: 50, fit: BoxFit.cover)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${item.quantity}x ${item.food.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(item.food.description, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1)
            ])),
            Text(formatVND(item.food.price * item.quantity), style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        )).toList(),
      ]),
    );
  }

  Widget _buildPromoSection(double subtotal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherSelectionScreen(currentAmount: subtotal)));
          if (result != null && result is VoucherItem) setState(() => _appliedVoucher = result);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const Icon(Icons.confirmation_num_outlined, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(child: Text(_appliedVoucher != null ? "Đã áp dụng: ${_appliedVoucher!.title}" : "Sử dụng mã giảm giá (Voucher)", style: TextStyle(fontWeight: FontWeight.w600, color: _appliedVoucher != null ? primaryPink : Colors.black))),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ]),
        ),
      ),
    );
  }

  Widget _buildPaymentDetailCard(double sub, double fee, double disc, double tot) {
    return Container(
      margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        _rowPrice("Tạm tính", formatVND(sub)),
        const SizedBox(height: 10),
        _rowPrice("Phí giao hàng", formatVND(fee)),
        if (disc > 0) ...[const SizedBox(height: 10), _rowPrice("Giảm giá", "-${formatVND(disc)}", isDisc: true)],
        const Divider(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Tổng cộng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(formatVND(tot), style: TextStyle(color: primaryPink, fontWeight: FontWeight.bold, fontSize: 22))]),
      ]),
    );
  }

  Widget _rowPrice(String l, String p, {bool isDisc = false}) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: TextStyle(color: Colors.grey[600])), Text(p, style: TextStyle(fontWeight: FontWeight.w600, color: isDisc ? Colors.green : Colors.black))]);

  Widget _buildBottomAction(double total, double subtotal, double discount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tổng thanh toán", style: TextStyle(color: Colors.grey, fontSize: 11)),
                Text(formatVND(total), style: TextStyle(color: primaryPink, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryPink, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (_displayItems.isEmpty) return;

                  final firstItem = _displayItems.first;
                  final dynamicOrder = OrderItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _displayItems.length > 1
                        ? "${firstItem.food.name} và ${_displayItems.length - 1} món..."
                        : firstItem.food.name,
                    quantity: _displayItems.fold(0, (sum, item) => sum + item.quantity),
                    price: total,
                    image: firstItem.food.imageUrl,
                    restaurantName: firstItem.food.restaurantName ?? "Bitoo Đối Tác",
                    address: _selectedAddress.detailAddress,
                    deliveryTime: _deliveryOptions[_selectedDeliveryIndex]['time'],
                    status: OrderStatus.active,
                  );
                  OrderManager().addOrder(dynamicOrder);

                  if (widget.selectedItems != null) {
                    for (var item in widget.selectedItems!) {
                      int idx = cart.items.indexWhere((i) => i.food.id == item.food.id);
                      if (idx != -1) cart.removeItem(idx);
                    }
                  } else {
                    cart.clearCart();
                  }

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderData: dynamicOrder)));
                },
                child: const Text('ĐẶT ĐƠN NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}