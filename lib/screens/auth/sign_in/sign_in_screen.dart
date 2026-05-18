import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'social_login_screen.dart';
import 'forgot_password_screen.dart';
import '../sign_up/sign_up_screen.dart';
import 'package:ueh_food_delivery/entry_point.dart';
import 'package:ueh_food_delivery/helpers/database_helper.dart';
import 'package:ueh_food_delivery/constants.dart';


class AppColors {
  static const primary = Color(0xFFFF6B9D);
  static const primaryDark = Color(0xFFE6456C);
  static const secondary = Color(0xFFFEC163);


  static const inputFill = Color(0xFFF5F6FA);

  static const textPrimary = Color(0xFF2D3142);
  static const textSecondary = Color(0xFF9098B1);
  static const textTertiary = Color(0xFFB0B5C2);

  static const background = Color(0xFFFFFFFF);
  static const success = Color(0xFF4ADE80);
  static const error = Color(0xFFFF5C5C);
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final user = await _dbHelper.loginUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.name, user['fullName']);
      await prefs.setString(StorageKeys.email, user['email']);
      _showSuccessAndNavigate();
    } else {
      _showErrorSnackBar("Email hoặc mật khẩu không đúng");
    }
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Đăng nhập thành công!", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => EntryPoint(key: EntryPoint.globalKey),
        ),
            (route) => false,
      );
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  void _handleSocialLogin(String platform) async {
    if (platform == "Apple") {
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SocialLoginScreen(platform: platform), fullscreenDialog: true),
    );
    if (result == true) _simulateLoginSuccess(platform);
  }

  void _simulateLoginSuccess(String provider) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSuccessAndNavigate();
  }
  // -------------------------

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [

            Positioned(
              top: -100,
              right: -50,
              child: _buildBlurBlob(AppColors.primary.withOpacity(0.2)),
            ),
            Positioned(
              top: 100,
              left: -80,
              child: _buildBlurBlob(AppColors.secondary.withOpacity(0.15)),
            ),


            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 80, 24, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Xin chào,\nMừng bạn quay lại!",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Đăng nhập để tiếp tục hành trình khám phá ẩm thực.",
                              style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),


                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.08),
                                blurRadius: 40,
                                offset: const Offset(0, -10),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // INPUTS
                                  _buildRefinedInput(
                                    controller: _emailController,
                                    label: "Email",
                                    icon: Icons.alternate_email_rounded,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildRefinedInput(
                                    controller: _passwordController,
                                    label: "Mật khẩu",
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                  ),


                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildRememberMe(),
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                                          ),
                                          child: const Text(
                                            "Quên mật khẩu?",
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // LOGIN BUTTON
                                  _buildGradientButton(
                                    text: "ĐĂNG NHẬP",
                                    onPressed: _isLoading ? null : _handleLogin,
                                    isLoading: _isLoading,
                                  ),

                                  const SizedBox(height: 32),


                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.grey[200], thickness: 1.5)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          "Hoặc tiếp tục với",
                                          style: TextStyle(color: AppColors.textTertiary, fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(child: Divider(color: Colors.grey[200], thickness: 1.5)),
                                    ],
                                  ),

                                  const SizedBox(height: 32),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildSocialButton("assets/images/google.png", () => _handleSocialLogin("Google")),
                                      _buildSocialButton("assets/images/facebook.png", () => _handleSocialLogin("Facebook")),
                                      _buildSocialButton("assets/images/apple.png", () => _handleSocialLogin("Apple")),
                                    ],
                                  ),

                                  const SizedBox(height: 40),


                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Chưa có tài khoản? ",
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                                        children: const [
                                          TextSpan(
                                            text: "Đăng ký ngay",
                                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),


                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBlurBlob(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }


  Widget _buildRefinedInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 22),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              hintText: "Nhập $label...",
              hintStyle: TextStyle(color: AppColors.textTertiary.withOpacity(0.7), fontSize: 14),
            ),
            validator: (v) => v == null || v.isEmpty ? "Vui lòng nhập $label" : null,
          ),
        ),
      ],
    );
  }


  Widget _buildRememberMe() {
    return GestureDetector(
      onTap: () => setState(() => _rememberMe = !_rememberMe),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _rememberMe ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: _rememberMe ? null : Border.all(color: AppColors.textTertiary, width: 2),
            ),
            child: _rememberMe
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 10),
          const Text(
            "Ghi nhớ tôi",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  Widget _buildGradientButton({required String text, VoidCallback? onPressed, bool isLoading = false}) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: onPressed != null
            ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark])
            : LinearGradient(colors: [Colors.grey[300]!, Colors.grey[400]!]),
        boxShadow: onPressed != null
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white),
        ),
      ),
    );
  }


  Widget _buildSocialButton(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Image.asset(asset),
      ),
    );
  }
}