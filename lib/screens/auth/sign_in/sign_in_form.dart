import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // THÊM DÒNG NÀY
import 'package:ueh_food_delivery/constants.dart';
import 'package:ueh_food_delivery/screens/home/home_screen.dart';
import 'package:ueh_food_delivery/helpers/database_helper.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _obscurePassword = true;

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();


      var user = await _dbHelper.loginUser(email, password);

      if (user != null) {

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.name, user['fullName']);
        await prefs.setString(StorageKeys.email, user['email']);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tài khoản hoặc mật khẩu không đúng"),
            backgroundColor: Colors.red,
          ),
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
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
            validator: (val) => (val!.isEmpty) ? "Vui lòng nhập email" : null,
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
            validator: (val) => (val!.isEmpty) ? "Vui lòng nhập mật khẩu" : null,
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSignIn,
              child: const Text("Đăng nhập"),
            ),
          ),
        ],
      ),
    );
  }
}