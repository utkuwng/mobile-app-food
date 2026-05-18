import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ueh_food_delivery/constants.dart';
import 'package:ueh_food_delivery/helpers/database_helper.dart';

import 'package:ueh_food_delivery/screens/auth/sign_in/sign_in_screen.dart';

class SecurityAccountScreen extends StatefulWidget {
  const SecurityAccountScreen({super.key});

  @override
  State<SecurityAccountScreen> createState() => _SecurityAccountScreenState();
}

class _SecurityAccountScreenState extends State<SecurityAccountScreen> {
  bool _faceId = true;
  bool _rememberMe = true;
  bool _touchId = false;

  String _currentName = "";
  String _currentEmail = "";
  String _currentPassword = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentName = prefs.getString(StorageKeys.name) ?? "";
      _currentEmail = prefs.getString(StorageKeys.email) ?? "";
    });

    var user = await DatabaseHelper().getUser(_currentEmail);
    if (user != null) {
      _currentPassword = user['password'];
    }
  }

  Future<void> _updateInfo(String newEmail, String newPass) async {
    await DatabaseHelper().updateUserInfo(_currentEmail, _currentName, newEmail, newPass);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.email, newEmail);
    setState(() {
      _currentEmail = newEmail;
      _currentPassword = newPass;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cập nhật thành công!"), backgroundColor: Colors.green));
  }


  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Xóa tài khoản?", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
          "Hành động này không thể hoàn tác. Tất cả dữ liệu, đơn hàng và điểm thưởng của bạn sẽ bị xóa vĩnh viễn khỏi hệ thống.",
          textAlign: TextAlign.justify,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {

              await DatabaseHelper().deleteUser(_currentEmail);


              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                    (route) => false,
              );
            },
            child: const Text("Xóa Vĩnh Viễn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đổi mật khẩu"),
        content: TextField(controller: passController, obscureText: true, decoration: const InputDecoration(hintText: "Nhập mật khẩu mới")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              if (passController.text.isNotEmpty) {
                _updateInfo(_currentEmail, passController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5283)),
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _showChangeEmailDialog() {
    final emailController = TextEditingController(text: _currentEmail);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đổi Email"),
        content: TextField(controller: emailController, decoration: const InputDecoration(hintText: "Nhập email mới")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                _updateInfo(emailController.text, _currentPassword);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5283)),
            child: const Text("Lưu", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Bảo mật & Tài khoản", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF5283).withOpacity(0.3)), // Viền nhẹ
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle, color: Color(0xFFFF5283), size: 40),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tài khoản hiện tại:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(_currentEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                )
              ],
            ),
          ),

          _buildSectionTitle("QUẢN LÝ TÀI KHOẢN"),
          _buildOptionTile(Icons.lock_outline, "Đổi mật khẩu", _showChangePasswordDialog),
          _buildOptionTile(Icons.email_outlined, "Thay đổi Email", _showChangeEmailDialog),


          const SizedBox(height: 24),
          _buildSectionTitle("BẢO MẬT NÂNG CAO"),

          _buildSwitchTile("Ghi nhớ đăng nhập", _rememberMe, (v) => setState(() => _rememberMe = v)),
          _buildSwitchTile("Sử dụng Face ID", _faceId, (v) => setState(() => _faceId = v)),
          _buildSwitchTile("Sử dụng vân tay (Touch ID)", _touchId, (v) => setState(() => _touchId = v)),

          const SizedBox(height: 24),
          _buildSectionTitle("QUYỀN RIÊNG TƯ"),

          _buildOptionTile(Icons.delete_forever, "Xóa tài khoản vĩnh viễn", _showDeleteConfirmDialog, isDanger: true),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.2)),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap, {bool isDanger = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))], // Bóng nhẹ
        border: Border.all(color: Colors.grey.shade100), // Viền mờ
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isDanger ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle
          ),
          child: Icon(icon, color: isDanger ? Colors.red : Colors.black87, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDanger ? Colors.red : Colors.black87)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],

        border: Border.all(
          color: value ? const Color(0xFFFF5283).withOpacity(0.3) : Colors.grey.shade300,
        ),
      ),
      child: SwitchListTile(
        activeColor: const Color(0xFFFF5283),
        activeTrackColor: const Color(0xFFFF5283).withOpacity(0.2),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade200,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

}