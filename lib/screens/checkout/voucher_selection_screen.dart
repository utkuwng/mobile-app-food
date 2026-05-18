import 'package:flutter/material.dart';
import '../../models/voucher_item.dart';

class VoucherSelectionScreen extends StatelessWidget {
  final double currentAmount;
  const VoucherSelectionScreen({super.key, required this.currentAmount});

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFFF3B77);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Chọn Voucher", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: primaryPink,
            labelColor: primaryPink,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: "Tất cả"), Tab(text: "Giảm giá"), Tab(text: "Vận chuyển")],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(allVouchers),
            _buildList(allVouchers.where((v) => v.type == 'Giảm giá món').toList()),
            _buildList(allVouchers.where((v) => v.type == 'Phí vận chuyển').toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<VoucherItem> vouchers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        final v = vouchers[index];
        bool isEligible = currentAmount >= v.minOrderAmount;
        return _buildTicket(context, v, isEligible);
      },
    );
  }

  Widget _buildTicket(BuildContext context, VoucherItem v, bool isEligible) {
    const primaryPink = Color(0xFFFF3B77);
    return Opacity(
      opacity: isEligible ? 1.0 : 0.5,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: const BoxDecoration(
                color: primaryPink,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(v.type == 'Giảm giá món' ? Icons.restaurant : Icons.local_shipping, color: Colors.white, size: 28),
                      Text(v.source, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ...List.generate(5, (i) => Positioned(
                    right: -5, top: i * 20.0 + 5,
                    child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle)),
                  )),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(v.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(v.requirement, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(v.expiration, style: const TextStyle(fontSize: 11, color: primaryPink, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: isEligible
                  ? ElevatedButton(
                onPressed: () => Navigator.pop(context, v),
                style: ElevatedButton.styleFrom(backgroundColor: primaryPink, shape: const StadiumBorder(), elevation: 0),
                child: const Text("Dùng", style: TextStyle(color: Colors.white, fontSize: 12)),
              )
                  : const Text("Chưa đủ đ/k", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}