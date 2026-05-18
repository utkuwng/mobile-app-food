import 'package:flutter/material.dart';

class FoodItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final int reviewCount;
  final String description;
  final bool isFavorite;
  final String restaurantName;


  final double? salePercentage;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.rating = 4.5,
    this.deliveryTime = "20-30 min",
    this.reviewCount = 100,
    this.description = "",
    this.isFavorite = false,
    this.restaurantName = "",
    this.salePercentage,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    double? rating,
    String? deliveryTime,
    int? reviewCount,
    String? description,
    bool? isFavorite,
    String? restaurantName,
    double? salePercentage,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      restaurantName: restaurantName ?? this.restaurantName,
      salePercentage: salePercentage ?? this.salePercentage,
    );
  }
}