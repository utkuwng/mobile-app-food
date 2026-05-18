import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/models/food_item.dart';
import 'package:ueh_food_delivery/data/data_manager.dart';

import '../../screens/food_detail/flash_sale_detail_screen.dart';

class DiscountItemsScreen extends StatelessWidget {
  const DiscountItemsScreen({super.key});

  String _formatPrice(double price) {
    return "${price.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ";
  }

  @override
  Widget build(BuildContext context) {

    final allItems = DataManager().allFoodItems;


    final discountedItems = allItems.map((item) {

      return item.copyWith(salePercentage: 30);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Ưu Đãi Giảm 30%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: discountedItems.length,
        itemBuilder: (context, index) {
          final item = discountedItems[index];
          return _buildDiscountFoodCard(context, item);
        },
      ),
    );
  }

  Widget _buildDiscountFoodCard(BuildContext context, FoodItem item) {

    double finalPrice = item.price * 0.7;

    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlashSaleDetailScreen(
              item: item,
              initialTimeLeft: const Duration(hours: 2),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(item.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 0, left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5283),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(8)),
                    ),
                    child: const Text('GIẢM 30%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(item.description, style: TextStyle(color: Colors.grey[600], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [

                      Text(
                        _formatPrice(item.price),
                        style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(width: 8),

                      Text(
                        _formatPrice(finalPrice),
                        style: const TextStyle(color: Color(0xFFFF5283), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}