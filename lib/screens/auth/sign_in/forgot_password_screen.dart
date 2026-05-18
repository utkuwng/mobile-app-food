import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ueh_food_delivery/helpers/database_helper.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _checkAndProceed() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
      );

      String inputEmail = _controller.text.trim();
      bool emailExists = await _dbHelper.checkEmailExists(inputEmail);

      if (!mounted) return;
      Navigator.of(context).pop();

      if (emailExists) {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationScreen(email: inputEmail),
          ),
        );
      } else {
        _showNotRegisteredDialog();
      }
    }
  }

  void _showNotRegisteredDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("😔", style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              const Text("Tài khoản chưa đăng ký", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
              const SizedBox(height: 10),
              Text("Email này chưa có trong hệ thống Bitoo Food. Bạn vui lòng kiểm tra lại hoặc đăng ký tài khoản mới nha.", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 45,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  child: const Text("Đã hiểu", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text("Quên mật khẩu", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Nhập email để lấy lại mật khẩu nha", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey[600])),

              const SizedBox(height: 40),


              SizedBox(
                height: 100,
                width: 200,
                child: Image.asset(
                  "assets/images/forgot_password.png",
                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                  },
                ),
              ),

              const SizedBox(height: 40),

              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.pinkAccent)),
                ),
                validator: (value) => (value == null || value.isEmpty) ? "Vui lòng nhập thông tin" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  onPressed: _checkAndProceed,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text("Tiếp tục", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String _dummyCode = "1234";

  @override
  void initState() {
    super.initState();
    _simulateSendingCode();
  }

  void _simulateSendingCode() async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.message, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text("Tin nhắn từ hệ thống:\nMã xác thực của bạn là $_dummyCode")),
          ],
        ),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150, left: 10, right: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Nhập mã xác thực", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                children: [
                  const TextSpan(text: "Chúng tôi đã gửi mã 4 số đến\n"),
                  TextSpan(text: widget.email, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60, height: 60,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.pinkAccent, width: 2)),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: () {
                  String code = _otpControllers.map((c) => c.text).join();
                  if (code == _dummyCode) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mã sai rồi, thử lại nhé!"), backgroundColor: Colors.red));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: const Text("Xác thực ngay", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(onPressed: _simulateSendingCode, child: const Text("Chưa nhận được mã? Gửi lại", style: TextStyle(color: Colors.pinkAccent)))
          ],
        ),
      ),
    );
  }
}


class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  void _saveNewPassword() async {
    String newPass = _passController.text.trim();
    String confirmPass = _confirmController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin"), backgroundColor: Colors.red));
      return;
    }
    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mật khẩu phải từ 6 ký tự trở lên"), backgroundColor: Colors.red));
      return;
    }
    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mật khẩu nhập lại không khớp"), backgroundColor: Colors.red));
      return;
    }

    await _dbHelper.updatePassword(widget.email, newPass);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đổi mật khẩu thành công! Đăng nhập lại nha."), backgroundColor: Colors.green));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Đặt lại mật khẩu", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Mật khẩu mới phải khác mật khẩu cũ nha", style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              const SizedBox(height: 40),

              TextField(
                controller: _passController,
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  labelText: "Mật khẩu mới",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(icon: Icon(_obscureText1 ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureText1 = !_obscureText1)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.pinkAccent), borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _confirmController,
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  labelText: "Nhập lại mật khẩu",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(icon: Icon(_obscureText2 ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureText2 = !_obscureText2)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.pinkAccent), borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  onPressed: _saveNewPassword,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text("Lưu mật khẩu", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}