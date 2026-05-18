import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final Function(String categoryName) onCategorySelected;

  const CategoryGrid({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"name": "Cơm", "prefix": "com", "img": "assets/images/com.jpg"},
      {"name": "Bún/Phở", "prefix": "bun", "img": "assets/images/pho.jpg"},
      {"name": "Bánh mì", "prefix": "banhmi", "img": "assets/images/banhmi.jpg"},
      {"name": "Gà rán", "prefix": "ga", "img": "assets/images/chicken.jpg"},
      {"name": "Trà sữa", "prefix": "trasua", "img": "assets/images/milktea.jpg"},
      {"name": "Cà phê", "prefix": "cafe", "img": "assets/images/coffee.jpg"},
      {"name": "Đồ chay", "prefix": "chay", "img": "assets/images/chay.jpg"},
      {"name": "Healthy", "prefix": "healthy", "img": "assets/images/healthy.jpg"},
      {"name": "Pizza", "prefix": "pizza", "img": "assets/images/pizza.jpg"},
      {"name": "Món Hàn", "prefix": "han", "img": "assets/images/han.jpg"},
      {"name": "Món Nhật", "prefix": "nhat", "img": "assets/images/nhat.jpg"},
      {"name": "Lẩu/Nướng", "prefix": "lau", "img": "assets/images/lau.jpg"},
      {"name": "Ăn vặt", "prefix": "anvat", "img": "assets/images/snack.jpg"},
      {"name": "Tráng miệng", "prefix": "dessert", "img": "assets/images/dessert.jpg"},
    ];

    return SizedBox(
      height: 250,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 19,
          crossAxisSpacing: 20,
          childAspectRatio: 1.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final cat = categories[index];

          return GestureDetector(
            onTap: () => onCategorySelected(cat["name"]!),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(cat["img"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat["name"]!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
