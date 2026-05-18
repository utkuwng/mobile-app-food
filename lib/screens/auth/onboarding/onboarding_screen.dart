import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/constants.dart';
import 'package:ueh_food_delivery/screens/auth/sign_in/welcome_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 3),
                        ),
                        child: const Icon(Icons.restaurant_menu, color: primaryColor, size: 30),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'BITOO',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  strokeWidth: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardData = [
    {
      "image": "assets/images/logo1.png",
      "title": "Món Ngon Tận Nhà",
      "description": "Thưởng thức ẩm thực đa dạng từ BITOO ngay tại không gian thoải mái của bạn."
    },
    {
      "image": "assets/images/logo2.png",
      "title": "Giao Hàng Thần Tốc",
      "description": "Đội ngũ shipper siêu đẳng sẽ giao món ăn nóng hổi chỉ trong vài phút."
    },
    {
      "image": "assets/images/logo3.png",
      "title": "Ưu Đãi Mỗi Ngày",
      "description": "Săn deal hời, mã giảm giá và nhận quà bất ngờ từ BITOO mỗi ngày."
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _controller,
                itemCount: _onboardData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardContent(
                    image: _onboardData[index]["image"]!,
                    title: _onboardData[index]["title"]!,
                    description: _onboardData[index]["description"]!,
                    screenHeight: screenHeight,
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardData.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          width: _currentPage == index ? 24 : 6,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.pinkAccent
                                : Colors.pinkAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          _currentPage == _onboardData.length - 1 ? "Bắt đầu ngay" : "Tiếp theo",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double screenHeight;

  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: screenHeight * 0.35,
          fit: BoxFit.contain,
        ),
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}