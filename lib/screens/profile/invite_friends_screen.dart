import 'package:flutter/material.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  void _handleSms(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang mở ứng dụng Tin nhắn...')));
  }

  void _handleEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang soạn Email mời bạn bè...')));
  }

  void _handleCopyLink(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã sao chép liên kết tải App!')));
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(255, 82, 131, 1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Mời bạn bè", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.card_giftcard_rounded, size: 100, color: primaryColor),
            ),
            const SizedBox(height: 30),
            const Text("Tặng bạn 50k, tặng mình 50k", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "Chia sẻ niềm vui ẩm thực! Bạn bè nhận ưu đãi đặt đơn đầu tiên, bạn nhận ngay voucher 50k vào ví.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 40),


            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("BITOO_PRO_2025", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  GestureDetector(
                    onTap: () => _handleCopyLink(context),
                    child: const Text("SAO CHÉP", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),


            _buildInviteItem(context, Icons.message_rounded, "Mời qua Tin nhắn (SMS)", () => _handleSms(context)),
            _buildInviteItem(context, Icons.email_rounded, "Mời qua Email", () => _handleEmail(context)),
            _buildInviteItem(context, Icons.share_rounded, "Chia sẻ qua ứng dụng khác", () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }
}