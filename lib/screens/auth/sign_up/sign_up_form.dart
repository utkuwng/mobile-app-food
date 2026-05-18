import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/constants.dart';
import 'package:ueh_food_delivery/screens/home/home_screen.dart';

import 'package:ueh_food_delivery/helpers/database_helper.dart';
import 'package:ueh_food_delivery/models/user.dart';
import '../sign_in/sign_in_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();


  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;


  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String name = _nameController.text.trim();


      bool emailExists = await _dbHelper.checkEmailExists(email);

      if (emailExists) {

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tài khoản đã tồn tại! Vui lòng dùng email khác."),
            backgroundColor: Colors.red,
          ),
        );
      } else {

        User newUser = User(
          fullName: name,
          email: email,
          password: password,
        );

        await _dbHelper.registerUser(newUser);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng ký thành công! Vui lòng đăng nhập."),
            backgroundColor: Colors.green,
          ),
        );


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Họ tên", prefixIcon: Icon(Icons.person)),
            validator: (val) => (val == null || val.isEmpty) ? 'Trường này là bắt buộc' : null,
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Trường này là bắt buộc';
              if (!val.contains('@')) return 'Email không hợp lệ';
              return null;
            },
          ),

          const SizedBox(height: defaultPadding),


          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "Mật khẩu",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Trường này là bắt buộc';
              if (val.length < 6) return 'Mật khẩu phải >= 6 ký tự';
              return null;
            },
          ),

          const SizedBox(height: defaultPadding),


          TextFormField(
            controller: _confirmController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: "Xác nhận mật khẩu",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Nhập lại mật khẩu';
              if (val != _passwordController.text) return 'Mật khẩu nhập lại không trùng khớp'; // Báo lỗi theo yêu cầu
              return null;
            },
          ),

          const SizedBox(height: defaultPadding),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSignUp, // Gọi hàm xử lý ở trên
              child: const Text("Đăng ký"),
            ),
          ),
        ],
      ),
    );
  }
}