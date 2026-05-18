import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/order_manager.dart';
import '../../entry_point.dart';
import '../../services/notification_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderItem? orderData;
  final int initialStage;

  const OrderTrackingScreen({super.key, this.orderData, this.initialStage = 0});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with TickerProviderStateMixin {
  late int _stage;
  int _timelineStep = 1;
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _bikeController;
  late AnimationController _dustController;
  late AnimationController _cloudController;
  late AnimationController _sparkleController;

  double _slidePosition = 5.0;
  final double _maxWidth = 260.0;

  late OrderItem currentOrder;
  final orderManager = OrderManager();

  final Color primaryPink = const Color(0xFFFF3B77);
  final Color secondaryOrange = const Color(0xFFFEA731);
  final Color accentBlue = const Color(0xFF4A90E2);

  late List<Map<String, dynamic>> _steps;

  @override
  void initState() {
    super.initState();
    _stage = widget.initialStage;
    currentOrder = widget.orderData ?? orderManager.allOrders.first;

    int totalMinutes = int.tryParse(currentOrder.deliveryTime.split(' ')[0]) ?? 20;

    DateTime now = DateTime.now();
    String formatTime(int minutesAdded) {
      DateTime time = now.add(Duration(minutes: minutesAdded));
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }

    _steps = [
      {"time": formatTime(0), "title": "Đơn hàng đã đặt", "desc": "Hệ thống đã nhận đơn", "icon": Icons.receipt_long},
      {"time": formatTime((totalMinutes * 0.1).round()), "title": "Nhà hàng xác nhận", "desc": "${currentOrder.restaurantName} đang làm món", "icon": Icons.restaurant},
      {"time": formatTime((totalMinutes * 0.3).round()), "title": "Tài xế đã lấy hàng", "desc": "Shipper đang mang món ăn đến bạn", "icon": Icons.shopping_bag},
      {"time": formatTime((totalMinutes * 0.7).round()), "title": "Đang giao hàng", "desc": "Tài xế đang cách bạn khoảng 500m", "icon": Icons.two_wheeler},
      {"time": formatTime(totalMinutes), "title": "Đã đến nơi", "desc": "Shipper đang ở ${currentOrder.address}", "icon": Icons.home},
    ];

    _radarController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _bikeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _dustController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _cloudController = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
    _sparkleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    if (_stage == 0) {
      Timer(const Duration(seconds: 4), () { if (mounted) setState(() => _stage = 1); });
    }

    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_stage == 1 && _timelineStep < _steps.length) {
        if (mounted) setState(() => _timelineStep++);
      } else if (_timelineStep == _steps.length) {
        timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(covariant OrderTrackingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_timelineStep >= 3 && _timelineStep < 5) {
      if (!_bikeController.isAnimating) {
        _bikeController.repeat(reverse: true);
      }
      if (!_dustController.isAnimating) {
        _dustController.repeat();
      }
    } else {
      _bikeController.stop();
      _dustController.stop();
    }

    if (_timelineStep >= 5) {
      if (!_sparkleController.isAnimating) {
        _sparkleController.repeat();
      }
    } else {
      _sparkleController.stop();
    }
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _bikeController.dispose();
    _dustController.dispose();
    _cloudController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: _stage == 0 ? _buildSearchingUI() : _buildTrackingUI(),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryPink.withAlpha((255 * 0.4).toInt()), blurRadius: 15, offset: const Offset(0, 8))],
        gradient: LinearGradient(colors: [primaryPink, secondaryOrange]),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          orderManager.markAsCompleted(currentOrder.id);


          NotificationService().addNotification(
            title: "✅ Giao hàng thành công!",
            message: "Bạn đã nhận món '${currentOrder.title}'. Hãy thưởng thức và đánh giá 5 sao nhé!",
            type: NotificationType.order,
            icon: Icons.check_circle,
            iconColor: Colors.green,
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => EntryPoint(key: EntryPoint.globalKey)), // Nhớ thêm globalKey nếu cần
                (route) => false,
          );
        },
        child: const Text("ĐÃ NHẬN ĐƯỢC HÀNG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildSearchingUI() {
    return Container(
      key: const ValueKey('searching'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryPink.withAlpha((255 * 0.05).toInt()), Colors.white, secondaryOrange.withAlpha((255 * 0.05).toInt())],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader("Đang tìm tài xế"),
            const SizedBox(height: 30),
            _buildSummaryCard(),
            const Spacer(),
            _buildComplexRadarAnimation(),
            const Spacer(),
            const Text("Đang tìm tài xế gần bạn...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text("Vui lòng chờ trong giây lát", style: TextStyle(color: Colors.grey)),
            const Spacer(),
            _buildImprovedSlideToCancel(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryPink.withAlpha((255 * 0.1).toInt()), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryPink, secondaryOrange]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentOrder.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text("${currentOrder.deliveryTime} • ${currentOrder.restaurantName}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplexRadarAnimation() {
    return SizedBox(
      height: 350,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: primaryPink.withAlpha((255 * 0.1).toInt()), blurRadius: 30, spreadRadius: 10)],
            ),
          ),
          AnimatedBuilder(
            animation: _radarController,
            builder: (context, child) => Stack(
              alignment: Alignment.center,
              children: [
                _radarWave(80 + (120 * _radarController.value), 0.8 - (0.8 * _radarController.value)),
                _radarWave(80 + (240 * _radarController.value), 0.4 - (0.4 * _radarController.value)),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) => Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.1),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [primaryPink, secondaryOrange]),
                  boxShadow: [BoxShadow(color: primaryPink.withAlpha((255 * 0.4).toInt()), blurRadius: 20)],
                ),
                child: const Icon(Icons.delivery_dining, color: Colors.white, size: 45),
              ),
            ),
          ),
          ..._buildFloatingDrivers(),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingDrivers() {
    return const [
      Positioned(top: 50, left: 80, child: _SingleFloatDrv(delay: 0)),
      Positioned(top: 100, right: 70, child: _SingleFloatDrv(delay: 500)),
      Positioned(bottom: 80, left: 60, child: _SingleFloatDrv(delay: 1000)),
      Positioned(bottom: 120, right: 90, child: _SingleFloatDrv(delay: 1500)),
    ];
  }

  Widget _radarWave(double s, double o) {
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryPink.withAlpha((255 * o * 0.5).toInt()), width: 2)),
    );
  }

  Offset _calculateBikePosition(Size size) {
    const double startX = 60;
    const double startY = 120;
    final double endX = size.width / 2;
    final double endY = size.height / 2 - 120;

    double progress = 0.0;
    if (_timelineStep >= 3) {
      progress = (_timelineStep - 3) / 2.0;
      progress = progress.clamp(0.0, 1.0);
    }

    final double midX = (startX + endX) / 2 + 40;
    final double midY = (startY + endY) / 2 - 20;

    final double x = pow(1 - progress, 2) * startX + 2 * (1 - progress) * progress * midX + pow(progress, 2) * endX;
    final double y = pow(1 - progress, 2) * startY + 2 * (1 - progress) * progress * midY + pow(progress, 2) * endY;

    return Offset(x, y);
  }

  Widget _buildAnimatedBike(Size size) {
    final Offset bikePos = _calculateBikePosition(size);
    final bool isMoving = _timelineStep >= 3 && _timelineStep < 5;
    final bool hasArrived = _timelineStep >= 5;

    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      left: bikePos.dx - 30,
      top: bikePos.dy - 30,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([_bikeController, _sparkleController, _dustController]),
          builder: (context, child) {
            return Transform.translate(
              offset: isMoving ? Offset(0, sin(_bikeController.value * pi * 2) * 4) : Offset.zero,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (hasArrived) ..._buildArrivalSparkles(),
                  if (isMoving) ..._buildEnhancedDust(),
                  if (isMoving)
                    const Positioned(
                      left: -15,
                      top: 5,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [Color(0x66FEA731), Color(0x00FEA731)]),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: hasArrived ? Colors.green.withAlpha((255 * 0.6).toInt()) : (isMoving ? secondaryOrange.withAlpha((255 * 0.5).toInt()) : primaryPink.withAlpha((255 * 0.3).toInt())),
                          blurRadius: hasArrived ? 25 : (isMoving ? 20 : 15),
                          spreadRadius: hasArrived ? 8 : (isMoving ? 5 : 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.two_wheeler,
                      size: 44,
                      color: hasArrived ? Colors.green : secondaryOrange,
                    ),
                  ),
                  if (hasArrived)
                    const Positioned(
                      right: -2,
                      top: -2,
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 3)),
                            boxShadow: [BoxShadow(color: Color(0x80008000), blurRadius: 10, spreadRadius: 2)],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.check, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ),
                  if (isMoving)
                    const Positioned(
                      top: -25,
                      left: 10,
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFFEA731),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [BoxShadow(color: Color(0x66FEA731), blurRadius: 8)],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text("🏃 45 km/h", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildArrivalSparkles() {
    return List.generate(3, (index) {
      final double angle = (index * pi * 2 / 3) + (_sparkleController.value * pi * 2);
      final double distance = 35 + (sin(_sparkleController.value * pi * 2) * 5);

      return Positioned(
        left: 30 + cos(angle) * distance - 4,
        top: 30 + sin(angle) * distance - 4,
        child: Opacity(
          opacity: 0.6 + (sin(_sparkleController.value * pi * 2) * 0.4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.green.withAlpha((255 * 0.8).toInt()), blurRadius: 6)],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildEnhancedDust() {
    return List.generate(3, (index) {
      final double progress = (_dustController.value + (index * 0.15)) % 1.0;
      final double opacity = (1.0 - progress) * 0.8;
      final double offsetX = -25 - (progress * 50) - (index * 8);
      final double offsetY = (sin((progress + index * 0.2) * pi * 3) * 8);
      final double size = 10 - (index * 1.5) - (progress * 5);

      return Positioned(
        left: offsetX,
        top: offsetY + 25,
        child: Opacity(
          opacity: opacity.clamp(0.0, 0.7),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: RadialGradient(colors: [Colors.grey[400]!.withAlpha((255 * 0.8).toInt()), Colors.grey[300]!.withAlpha(0)]),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDetailedHome() {
    final bool hasArrived = _timelineStep >= 5;

    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasArrived)
              Transform.scale(
                scale: 1.0 + (sin(_sparkleController.value * pi * 2) * 0.2),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 28,
                    shadows: [Shadow(color: Colors.amber.withAlpha((255 * 0.8).toInt()), blurRadius: 15)],
                  ),
                ),
              ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: hasArrived ? Colors.green : primaryPink, width: 3),
                    boxShadow: [BoxShadow(color: hasArrived ? Colors.green.withAlpha((255 * 0.4).toInt()) : primaryPink.withAlpha((255 * 0.3).toInt()), blurRadius: 25, spreadRadius: 5)],
                  ),
                  child: Icon(Icons.home, size: 38, color: hasArrived ? Colors.green : primaryPink),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: hasArrived ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: hasArrived ? Colors.green.withAlpha((255 * 0.3).toInt()) : Colors.black.withAlpha((255 * 0.1).toInt()), blurRadius: 12)],
              ),
              child: Text(
                hasArrived ? "✅ Đã giao hàng!" : "📍 Điểm đến của bạn",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: hasArrived ? Colors.white : Colors.black87),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEnhancedCustomMap() {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.white, Colors.green[50]!],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final Size size = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: _cloudController,
                  builder: (context, child) => Stack(
                    children: _buildSkyElements(),
                  ),
                ),
                ..._buildRoadElements(size),
                RepaintBoundary(
                  child: CustomPaint(
                    size: size,
                    painter: RoutePainter(primaryPink, _timelineStep, secondaryOrange),
                  ),
                ),
                Stack(
                  children: _buildCityElements(size),
                ),
                Center(child: _buildDetailedHome()),
                _buildAnimatedBike(size),
                const Positioned(left: 45, top: 105, child: _BuildStartPoint()),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSkyElements() {
    return [
      Positioned(
        right: 40,
        top: 60,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber[200],
            boxShadow: [BoxShadow(color: Colors.amber.withAlpha((255 * 0.5).toInt()), blurRadius: 30, spreadRadius: 10)],
          ),
        ),
      ),
      Positioned(left: 60 + (_cloudController.value * 20), top: 80, child: _buildCloud(80, 40)),
      Positioned(right: 100 - (_cloudController.value * 20), top: 120, child: _buildCloud(100, 50)),
      Positioned(left: 200 + (_cloudController.value * 20), top: 150, child: _buildCloud(70, 35)),
    ];
  }

  Widget _buildCloud(double width, double height) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha((255 * 0.05).toInt()), blurRadius: 10)],
        ),
      ),
    );
  }

  List<Widget> _buildRoadElements(Size size) {
    return [
      ...List.generate(10, (i) => Positioned(
        left: 0,
        top: i * 40.0,
        right: 0,
        child: Container(
          height: 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black.withAlpha(0), Colors.black.withAlpha((255 * 0.03).toInt()), Colors.black.withAlpha(0)],
            ),
          ),
        ),
      )),
      ...List.generate(20, (i) => Positioned(
        left: i * 40.0,
        top: 0,
        bottom: 0,
        child: Container(
          width: 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withAlpha(0), Colors.black.withAlpha((255 * 0.03).toInt()), Colors.black.withAlpha(0)],
            ),
          ),
        ),
      )),
    ];
  }

  List<Widget> _buildCityElements(Size size) {
    return [
      Positioned(left: 30, bottom: 180, child: _BuildBuilding(width: 45, height: 70, color: Colors.blue[100]!, floors: 3)),
      Positioned(right: 40, bottom: 200, child: _BuildBuilding(width: 50, height: 85, color: Colors.purple[100]!, floors: 4)),
      Positioned(right: 120, bottom: 160, child: _BuildBuilding(width: 40, height: 60, color: Colors.pink[100]!, floors: 3)),
      const Positioned(left: 100, bottom: 190, child: _BuildShop()),
    ];
  }

  Widget _buildTrackingUI() {
    return Stack(
      key: const ValueKey('tracking'),
      children: [
        _buildEnhancedCustomMap(),
        const Positioned(top: 50, left: 20, child: _CustomBackBtn()),
        Positioned(bottom: 0, left: 0, right: 0, child: _buildDriverInfoCard()),
      ],
    );
  }

  Widget _buildDriverInfoCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              const CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nguyễn Văn Minh", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    Text("Honda Wave RSX • 59A1-234.56", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              _actionBtn(Icons.chat_bubble, accentBlue),
              const SizedBox(width: 10),
              _actionBtn(Icons.call, Colors.green),
            ],
          ),
          const Divider(height: 30),
          SizedBox(
            height: 220,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _steps.length,
              itemBuilder: (context, index) => _buildStepItem(_steps[index], index < _timelineStep, index == _timelineStep - 1, index == _steps.length - 1),
            ),
          ),
          if (_timelineStep == _steps.length) _buildFinishButton(),
        ],
      ),
    );
  }

  Widget _buildStepItem(Map step, bool isPast, bool isCurrent, bool isLast) {
    final Color color = isCurrent ? primaryPink : (isPast ? Colors.black87 : Colors.grey[300]!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isPast ? primaryPink.withAlpha((255 * 0.1).toInt()) : Colors.grey[100]!, shape: BoxShape.circle),
              child: Icon(step['icon'], color: color, size: 18),
            ),
            if (!isLast) Container(width: 2, height: 40, color: isPast ? primaryPink : Colors.grey[200]),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(step['title'], style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600, color: color)),
                    Text(step['time'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isPast ? Colors.black54 : Colors.grey[300])),
                  ],
                ),
                Text(step['desc'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImprovedSlideToCancel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(30)),
      child: Stack(
        children: [
          const Center(child: Text("Vuốt để hủy đơn", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            left: _slidePosition,
            top: 5,
            bottom: 5,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _slidePosition += details.delta.dx;
                  _slidePosition = _slidePosition.clamp(5.0, _maxWidth);
                });
              },
              onHorizontalDragEnd: (details) {
                if (_slidePosition >= _maxWidth - 20) {
                  orderManager.cancelOrder(currentOrder.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã gửi yêu cầu hủy đơn thành công"), backgroundColor: Colors.orange),
                  );
                } else {
                  setState(() => _slidePosition = 5);
                }
              },
              child: Container(
                width: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String t) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _customBackBtn(),
          const SizedBox(width: 15),
          Text(t, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _customBackBtn() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((255 * 0.05).toInt()), blurRadius: 10)],
      ),
      child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
    );
  }

  Widget _actionBtn(IconData i, Color c) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withAlpha((255 * 0.1).toInt()), borderRadius: BorderRadius.circular(12)),
      child: Icon(i, color: c, size: 22),
    );
  }
}

class _SingleFloatDrv extends StatelessWidget {
  final int delay;

  const _SingleFloatDrv({required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 2000 + delay),
      builder: (context, double v, child) => Transform.translate(
        offset: Offset(0, sin(v * pi * 2) * 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Icon(Icons.two_wheeler, size: 20, color: Colors.grey[300]),
        ),
      ),
    );
  }
}

class _BuildStartPoint extends StatelessWidget {
  const _BuildStartPoint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFF3B77), width: 2),
        boxShadow: [BoxShadow(color: const Color(0x4Dff3b77), blurRadius: 15, spreadRadius: 3)],
      ),
      child: const Icon(Icons.restaurant, size: 24, color: Color(0xFFFF3B77)),
    );
  }
}

class _BuildBuilding extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final int floors;

  const _BuildBuilding({required this.width, required this.height, required this.color, required this.floors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((255 * 0.1).toInt()), blurRadius: 8, offset: const Offset(2, 2))],
      ),
      child: Column(
        children: List.generate(floors, (i) => Expanded(
          child: Row(
            children: List.generate(2, (j) => Expanded(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.blue[200], borderRadius: BorderRadius.circular(2)),
              ),
            )),
          ),
        )),
      ),
    );
  }
}

class _BuildShop extends StatelessWidget {
  const _BuildShop();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((255 * 0.1).toInt()), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red[200],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: const Center(child: Text("🍔", style: TextStyle(fontSize: 16))),
            ),
          ),
          Expanded(child: Container(color: Colors.orange[100])),
        ],
      ),
    );
  }
}

class _CustomBackBtn extends StatelessWidget {
  const _CustomBackBtn();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((255 * 0.05).toInt()), blurRadius: 10)],
      ),
      child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
    );
  }
}

class RoutePainter extends CustomPainter {
  final Color color;
  final int timelineStep;
  final Color accentColor;

  RoutePainter(this.color, this.timelineStep, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    const double startX = 60;
    const double startY = 120;
    final double endX = size.width / 2;
    final double endY = size.height / 2 - 120;

    final path = Path()
      ..moveTo(startX, startY)
      ..quadraticBezierTo((startX + endX) / 2 + 40, (startY + endY) / 2 - 20, endX, endY);

    final bgPaint = Paint()
      ..color = color.withAlpha((255 * 0.15).toInt())
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, bgPaint);

    if (timelineStep >= 3) {
      double progress = ((timelineStep - 3) / 2.0).clamp(0.0, 1.0);

      final pathMetrics = path.computeMetrics();
      for (var metric in pathMetrics) {
        final extractPath = metric.extractPath(0, metric.length * progress);

        final rect = extractPath.getBounds();
        final progressPaint = Paint()
          ..strokeWidth = 10
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(colors: [color, accentColor], begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(rect);

        canvas.drawPath(extractPath, progressPaint);

        final dashPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        _drawDashedPath(canvas, extractPath, dashPaint);

        if (progress < 1.0) {
          final tangent = metric.getTangentForOffset(metric.length * progress);
          if (tangent != null) {
            final glowPaint = Paint()
              ..color = accentColor.withAlpha((255 * 0.6).toInt())
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

            canvas.drawCircle(tangent.position, 8, glowPaint);
            canvas.drawCircle(tangent.position, 5, Paint()..color = Colors.white);
          }
        }
      }
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const double dashWidth = 10;
    const double dashSpace = 8;
    final pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = metric.getTangentForOffset(distance);
        final end = metric.getTangentForOffset(distance + dashWidth);
        if (start != null && end != null) {
          canvas.drawLine(start.position, end.position, paint);
        }
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) => oldDelegate.timelineStep != timelineStep;
}