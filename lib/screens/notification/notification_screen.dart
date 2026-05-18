import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

const primaryColor = Color(0xFFFF5283);
const backgroundColor = Color(0xFFF8F9FC);

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _service = NotificationService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  List<NotificationItem> _getFilteredNotifications(NotificationType? type) {
    if (type == null) return _service.notifications;
    return _service.notifications.where((n) => n.type == type).toList();
  }


  int _getUnreadCount(NotificationType? type) {
    final filtered = _getFilteredNotifications(type);
    return filtered.where((n) => !n.isRead).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: primaryColor),
            onPressed: () => setState(() => _service.markAllAsRead()),
            tooltip: 'Đánh dấu đã đọc tất cả',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: [
                Tab(text: 'Tất cả (${_getUnreadCount(null)})'),
                Tab(text: 'Đơn hàng (${_getUnreadCount(NotificationType.order)})'),
                Tab(text: 'Khuyến mãi (${_getUnreadCount(NotificationType.promotion)})'),
                Tab(text: 'Khác (${_getUnreadCount(NotificationType.reward) + _getUnreadCount(NotificationType.system)})'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(null),
          _buildNotificationList(NotificationType.order),
          _buildNotificationList(NotificationType.promotion),
          _buildNotificationList(null, showOnlyOthers: true),
        ],
      ),
    );
  }

  Widget _buildNotificationList(NotificationType? type, {bool showOnlyOthers = false}) {
    List<NotificationItem> notifications;
    if (showOnlyOthers) {
      notifications = _service.notifications
          .where((n) => n.type == NotificationType.reward || n.type == NotificationType.system)
          .toList();
    } else {
      notifications = _getFilteredNotifications(type);
    }

    if (notifications.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) => _buildNotificationCard(notifications[index]),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return GestureDetector(
      onTap: () => setState(() => _service.markAsRead(notification.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead ? Colors.grey.shade200 : primaryColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: notification.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(notification.icon, color: notification.iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: const Color(0xFF2D3142),
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(_getTimeAgo(notification.time), style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text('Không có thông báo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${time.day}/${time.month}/${time.year}';
  }
}