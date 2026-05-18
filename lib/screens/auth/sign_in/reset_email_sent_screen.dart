import 'package:flutter/material.dart';
import '../../../constants.dart';

class ResetEmailSentScreen extends StatelessWidget {
  const ResetEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email đã gửi')),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 80, color: primaryColor),
            const SizedBox(height: 20),
            const Text('Chúng tôi đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư của bạn.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Quay lại đăng nhập'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
