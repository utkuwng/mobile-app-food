import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../sign_in/sign_in_screen.dart';
import '../sign_in/social_login_screen.dart';
import 'package:ueh_food_delivery/helpers/database_helper.dart';
import 'package:ueh_food_delivery/models/user.dart';


class AppColors {
  static const primary = Color(0xFFFF6B9D);
  static const primaryDark = Color(0xFFE6456C);
  static const secondary = Color(0xFFFEC163);

  static const inputFill = Color(0xFFF5F6FA);

  static const textPrimary = Color(0xFF1F222B);
  static const textSecondary = Color(0xFF555B6E);
  static const textTertiary = Color(0xFF9095A0);

  static const background = Color(0xFFFFFFFF);
  static const success = Color(0xFF4ADE80);
  static const error = Color(0xFFFF5C5C);
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }


  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();

    final exists = await _dbHelper.checkEmailExists(email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (exists) {
      _showErrorSnackBar("Email đã được sử dụng");
      return;
    }

    final user = User(fullName: name, email: email, password: password);
    await _dbHelper.registerUser(user);

    if (!mounted) return;
    _showSuccessSnackBar();

    Future.delayed(const Duration(milliseconds: 1200), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, sa) => const SignInScreen(),
          transitionsBuilder: (_, a, sa, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text("Đăng ký thành công!", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
      ),
    );
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

  void _handleSocial(String platform) async {
    if (platform == "Apple") return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SocialLoginScreen(platform: platform), fullscreenDialog: true),
    );
    if (result == true) _simulateSocialSuccess(platform);
  }

  void _simulateSocialSuccess(String provider) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSuccessSnackBar();
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, sa) => const SignInScreen(),
          transitionsBuilder: (_, a, sa, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }


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
              top: -80,
              right: -30,
              child: _buildBlurBlob(AppColors.secondary.withOpacity(0.2)),
            ),
            Positioned(
              top: 150,
              left: -50,
              child: _buildBlurBlob(AppColors.primary.withOpacity(0.15)),
            ),


            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🎯 HERO HEADER
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tạo tài khoản",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tham gia cùng chúng tôi để khám phá thế giới ẩm thực.",
                              style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),


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
                                    controller: _nameController,
                                    label: "Họ và tên",
                                    icon: Icons.badge_outlined,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildRefinedInput(
                                    controller: _emailController,
                                    label: "Email",
                                    icon: Icons.alternate_email_rounded,
                                    isEmail: true,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildRefinedInput(
                                    controller: _passwordController,
                                    label: "Mật khẩu",
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 20),


                                  _buildRefinedInput(
                                    controller: _confirmController,
                                    label: "Xác nhận mật khẩu",
                                    icon: Icons.check_circle_outline_rounded,
                                    isConfirm: true,
                                    iconColor: Colors.pinkAccent,
                                  ),

                                  const SizedBox(height: 32),


                                  _buildGradientButton(
                                    text: "ĐĂNG KÝ NGAY",
                                    onPressed: _isLoading ? null : _handleSignUp,
                                    isLoading: _isLoading,
                                  ),

                                  const SizedBox(height: 32),


                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.grey[200], thickness: 1.5)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          "Hoặc đăng ký với",
                                          style: TextStyle(color: AppColors.textTertiary, fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(child: Divider(color: Colors.grey[200], thickness: 1.5)),
                                    ],
                                  ),

                                  const SizedBox(height: 28),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildSocialButton("assets/images/google.png", () => _handleSocial("Google")),
                                      _buildSocialButton("assets/images/facebook.png", () => _handleSocial("Facebook")),
                                      _buildSocialButton("assets/images/apple.png", () => _handleSocial("Apple")),
                                    ],
                                  ),

                                  const SizedBox(height: 24),


                                  RichText(
                                    text: TextSpan(
                                      text: "Đã có tài khoản? ",
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                                      children: [
                                        TextSpan(
                                          text: "Đăng nhập",
                                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (_, a, sa) => const SignInScreen(),
                                                  transitionsBuilder: (_, a, sa, child) => FadeTransition(opacity: a, child: child),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
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
      width: 250,
      height: 250,
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
    bool isConfirm = false,
    bool isEmail = false,
    Color? iconColor,
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
            obscureText: (isPassword || isConfirm)
                ? (isConfirm ? _obscureConfirm : _obscurePassword)
                : false,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
              suffixIcon: (isPassword || isConfirm)
                  ? IconButton(
                icon: Icon(
                  (isConfirm ? _obscureConfirm : _obscurePassword)
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                onPressed: () => setState(() {
                  if (isConfirm) {
                    _obscureConfirm = !_obscureConfirm;
                  } else {
                    _obscurePassword = !_obscurePassword;
                  }
                }),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              hintText: "Nhập $label...",
              hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return "Vui lòng nhập $label";
              if (isEmail && !v.contains('@')) return "Email không hợp lệ";
              if (isPassword && v.length < 6) return "Mật khẩu tối thiểu 6 ký tự";
              if (isConfirm && v != _passwordController.text) return "Mật khẩu không khớp";
              return null;
            },
          ),
        ),
      ],
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