import 'package:flutter/material.dart';

enum NotificationType { order, promotion, reward, system }

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;
  final IconData icon;
  final Color iconColor;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    required this.icon,
    required this.iconColor,
  });
}

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();


  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'promo_1',
      type: NotificationType.promotion,
      title: '⚡ FLASH SALE GIỜ VÀNG',
      message: 'Đói chưa? Deal 1K, 9K đang chờ bạn săn ngay bây giờ! Số lượng có hạn.',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      icon: Icons.flash_on,
      iconColor: Colors.orange,
    ),
    NotificationItem(
      id: 'promo_2',
      type: NotificationType.promotion,
      title: '☔ Mưa gió ngại đi?',
      message: 'Ở nhà để Bitoo lo! Tặng bạn mã FREESHIP cho đơn từ 40k. Đặt ngay cho nóng!',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.umbrella,
      iconColor: Colors.blue,
    ),
    NotificationItem(
      id: 'reward_1',
      type: NotificationType.reward,
      title: '🎁 Bạn có quà chưa mở!',
      message: 'Chúc mừng bạn nhận được Voucher giảm 50% cho lần đặt tiếp theo.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.card_giftcard,
      iconColor: const Color(0xFFFF5283),
    ),
  ];

  List<NotificationItem> get notifications => _notifications;


  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
    required IconData icon,
    required Color iconColor,
  }) {
    final newItem = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      title: title,
      message: message,
      time: DateTime.now(),
      icon: icon,
      iconColor: iconColor,
      isRead: false,
    );
    _notifications.insert(0, newItem);
  }


  void markAsRead(String id) {
    final index = _notifications.indexWhere((element) => element.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
    }
  }


  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
  }
}