import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final String orderType;


  const CheckoutScreen({super.key, required this.orderType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán ($orderType)'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Giao diện Thanh toán cho: $orderType',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}