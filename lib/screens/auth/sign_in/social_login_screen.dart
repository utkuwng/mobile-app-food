import 'package:flutter/material.dart';

class SocialLoginScreen extends StatefulWidget {
  final String platform;
  const SocialLoginScreen({super.key, required this.platform});

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  bool _isLoading = false;


  final _emailController = TextEditingController();
  final _passController = TextEditingController();


  int _googleStep = 1;
  bool _showPassword = false;


  Color get _headerColor => widget.platform == "Facebook" ? const Color(0xFF3b5998) : Colors.white;
  Color get _btnColor => widget.platform == "Facebook" ? const Color(0xFF1877F2) : const Color(0xFF1a73e8);
  String get _url => widget.platform == "Facebook" ? "m.facebook.com" : "accounts.google.com";


  void _handleFinishLogin() async {
    if (_passController.text.isEmpty) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context, true);
  }


  void _googleNextStep() {
    if (_googleStep == 1) {

      if (_emailController.text.isNotEmpty) {
        setState(() => _googleStep = 2);
      }
    } else {

      _handleFinishLogin();
    }
  }


  Future<bool> _onWillPop() async {

    if (widget.platform == "Google" && _googleStep == 2) {
      setState(() => _googleStep = 1);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: const Color(0xFFF0F2F5),
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(_url, style: const TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
          centerTitle: true,
        ),

        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: _btnColor))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: widget.platform == "Facebook"
              ? _buildFacebookUI()
              : _buildGoogleUI(),
        ),
      ),
    );
  }


  Widget _buildFacebookUI() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset("assets/images/facebook.png", height: 60),
        const SizedBox(height: 10),
        const Text("Facebook", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1877F2))),
        const SizedBox(height: 30),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Số di động hoặc email",
            filled: true, fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _passController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Mật khẩu",
            filled: true, fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity, height: 45,
          child: ElevatedButton(
            onPressed: _handleFinishLogin,
            style: ElevatedButton.styleFrom(backgroundColor: _btnColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), elevation: 0),
            child: const Text("Đăng nhập", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(onPressed: (){}, child: const Text("Quên mật khẩu?", style: TextStyle(color: Color(0xFF1877F2)))),
        const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 20),
        const Text("Meta © 2025", style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }


  Widget _buildGoogleUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Image.asset("assets/images/google.png", height: 35),

        const SizedBox(height: 15),


        if (_googleStep == 1) ...[
          const Text("Đăng nhập", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black)),
          const SizedBox(height: 10),
          const Text("Tiếp tục tới Bitoo Food", style: TextStyle(fontSize: 16, color: Colors.black87)),

          const SizedBox(height: 30),

          TextField(
            controller: _emailController,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: "Email hoặc số điện thoại",
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF1a73e8), width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            ),
          ),

          const SizedBox(height: 10),
          TextButton(
              onPressed: (){},
              style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
              child: const Text("Bạn quên địa chỉ email?", style: TextStyle(color: Color(0xFF1a73e8), fontWeight: FontWeight.w600))
          ),

          const SizedBox(height: 30),

          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
              children: const [
                TextSpan(text: "Trước khi sử dụng Bitoo Food, bạn có thể xem "),
                TextSpan(text: "chính sách quyền riêng tư", style: TextStyle(color: Color(0xFF1a73e8), fontWeight: FontWeight.w600)),
                TextSpan(text: " và "),
                TextSpan(text: "điều khoản dịch vụ", style: TextStyle(color: Color(0xFF1a73e8), fontWeight: FontWeight.w600)),
                TextSpan(text: " của ứng dụng này."),
              ],
            ),
          ),

          const SizedBox(height: 40),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: (){}, child: const Text("Tạo tài khoản", style: TextStyle(color: Color(0xFF1a73e8), fontWeight: FontWeight.w600))),
              ElevatedButton(
                onPressed: _googleNextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0b57d0), // Xanh đậm hơn chút
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Bo tròn kiểu mới
                  elevation: 0,
                ),
                child: const Text("Tiếp theo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],


        if (_googleStep == 2) ...[
          const Text("Chào mừng", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black)),
          const SizedBox(height: 10),


          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(_emailController.text, style: const TextStyle(fontWeight: FontWeight.w500)), // EMAIL NGƯỜI DÙNG
                const SizedBox(width: 5),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
              ],
            ),
          ),

          const SizedBox(height: 30),


          TextField(
            controller: _passController,
            obscureText: !_showPassword,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: "Nhập mật khẩu của bạn",
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF1a73e8), width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            ),
          ),

          const SizedBox(height: 10),


          Row(
            children: [
              SizedBox(
                height: 24, width: 24,
                child: Checkbox(
                    value: _showPassword,
                    activeColor: const Color(0xFF1a73e8),
                    onChanged: (val) => setState(() => _showPassword = val!)
                ),
              ),
              const SizedBox(width: 8),
              const Text("Hiện mật khẩu"),
            ],
          ),

          const SizedBox(height: 40),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: (){}, child: const Text("Bạn quên mật khẩu?", style: TextStyle(color: Color(0xFF1a73e8), fontWeight: FontWeight.w600))),
              ElevatedButton(
                onPressed: _googleNextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0b57d0),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: const Text("Tiếp theo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ]
      ],
    );
  }
}