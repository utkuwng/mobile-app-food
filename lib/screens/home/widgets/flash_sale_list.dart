import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/screens/food_detail/flash_sale_detail_screen.dart';
import 'package:ueh_food_delivery/data/data_manager.dart';
import 'package:ueh_food_delivery/models/food_item.dart';

class FlashSaleWidget extends StatefulWidget {
  const FlashSaleWidget({super.key});

  @override
  State<FlashSaleWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget> {
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 2, minutes: 15, seconds: 20);


  late List<FoodItem> flashSaleProducts;

  @override
  void initState() {
    super.initState();


    flashSaleProducts = DataManager().allFoodItems
        .where((item) => item.salePercentage != null && item.salePercentage! > 0)
        .toList();


    if (flashSaleProducts.length > 6) {
      flashSaleProducts = flashSaleProducts.sublist(0, 6);
    }


    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _timeLeft -= const Duration(seconds: 1);
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(duration.inHours);
    final m = twoDigits(duration.inMinutes.remainder(60));
    final s = twoDigits(duration.inSeconds.remainder(60));
    return "$h:$m:$s";
  }


  void _navigateToDetailScreen(BuildContext context, FoodItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashSaleDetailScreen(
          item: item,
          initialTimeLeft: _timeLeft,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.orange, size: 20),
                    SizedBox(width: 4),
                    Text(
                      "Flash Sale",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDuration(_timeLeft),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: flashSaleProducts.length,
              itemBuilder: (context, index) {
                final item = flashSaleProducts[index];

                double discountedPrice = item.price * (1 - (item.salePercentage! / 100));

                return InkWell(
                  onTap: () => _navigateToDetailScreen(context, item),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Stack(
                      children: [

                        Container(
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ),


                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "-${item.salePercentage}%",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    "${discountedPrice.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.')}đ",
                                    style: const TextStyle(
                                      color: Colors.yellowAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),

                                  Text(
                                    "${item.price.toStringAsFixed(0)}đ",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 9,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}