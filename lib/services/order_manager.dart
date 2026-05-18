import 'package:flutter/material.dart';

enum OrderStatus { active, completed, cancelled }

class OrderItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String image;
  final String restaurantName;
  final String deliveryTime;
  final String address;
  OrderStatus status;

  OrderItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.image,
    required this.restaurantName,
    this.deliveryTime = "15-20 phút",
    this.address = "UEH Campus N",
    this.status = OrderStatus.active,
  });
}

class OrderManager {
  static final OrderManager _instance = OrderManager._internal();
  factory OrderManager() => _instance;
  OrderManager._internal();

  final List<OrderItem> _orders = [];

  void addOrder(OrderItem order) {
    _orders.insert(0, order);
  }

  List<OrderItem> get allOrders => _orders;
  List<OrderItem> get activeOrders => _orders.where((o) => o.status == OrderStatus.active).toList();
  List<OrderItem> get completedOrders => _orders.where((o) => o.status == OrderStatus.completed).toList();
  List<OrderItem> get cancelledOrders => _orders.where((o) => o.status == OrderStatus.cancelled).toList();

  void markAsCompleted(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) _orders[index].status = OrderStatus.completed;
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) _orders[index].status = OrderStatus.cancelled;
  }
}