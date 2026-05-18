import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const primaryColor = Color(0xFFFF5283);
const bgColor = Color(0xFFF7F7FA);

const String WALLET_ID = 'wallet';
const String CASH_ID = 'cash';
const String MOMO_ID = 'momo';
const String ZALOPAY_ID = 'zalo';
const String SELECTED_METHOD_KEY = 'selectedPaymentId';
const String DYNAMIC_CARDS_KEY = 'dynamicCardList';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedMethodId = WALLET_ID;
  List<String> _cards = [];

  final TextEditingController _cardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _cards = prefs.getStringList(DYNAMIC_CARDS_KEY) ?? ['MasterCard •••• 4679'];
    _selectedMethodId =
        prefs.getString(SELECTED_METHOD_KEY) ?? _cards.first;
    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(DYNAMIC_CARDS_KEY, _cards);
    await prefs.setString(SELECTED_METHOD_KEY, _selectedMethodId);
  }

  void _select(String id) {
    setState(() => _selectedMethodId = id);
    _saveData();
  }

  void _apply() {
    _saveData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã áp dụng phương thức thanh toán"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _addCard() {
    _cardController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("💳 Thêm thẻ mới"),
        content: TextField(
          controller: _cardController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Nhập số thẻ"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Huỷ")),
          TextButton(
            onPressed: () {
              if (_cardController.text.length >= 4) {
                final last4 = _cardController.text
                    .substring(_cardController.text.length - 4);
                final card = "Thẻ •••• $last4";
                setState(() {
                  _cards.add(card);
                  _selectedMethodId = card;
                });
                _saveData();
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Text(
      title,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
    ),
  );

  Widget _option(
      {required String id,
        required String title,
        required IconData icon,
        Color color = primaryColor,
        String? subtitle}) {
    final selected = _selectedMethodId == id;

    return GestureDetector(
      onTap: () => _select(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: selected ? primaryColor : Colors.transparent, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? primaryColor.withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: selected ? 16 : 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? primaryColor : Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        centerTitle: true,
        title: const Text("Thanh toán",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _section("Thanh toán nhanh"),
                _option(
                    id: WALLET_ID,
                    title: "Ví của tôi",
                    subtitle: "9.379.000đ",
                    icon: Icons.account_balance_wallet),
                _option(
                    id: CASH_ID,
                    title: "Tiền mặt",
                    icon: Icons.payments_outlined),

                _section("Thẻ ngân hàng"),
                ..._cards.map((c) =>
                    _option(id: c, title: c, icon: Icons.credit_card)),

                TextButton.icon(
                  onPressed: _addCard,
                  icon: const Icon(Icons.add, color: primaryColor),
                  label: const Text("Thêm thẻ mới",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600)),
                ),

                _section("Ví điện tử"),
                _option(
                    id: MOMO_ID,
                    title: "MoMo",
                    icon: Icons.circle,
                    color: Colors.pink),
                _option(
                    id: ZALOPAY_ID,
                    title: "ZaloPay",
                    icon: Icons.qr_code,
                    color: Colors.blue),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Áp dụng",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
