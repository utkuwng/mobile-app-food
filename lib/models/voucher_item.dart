class VoucherItem {
  final String title;
  final String description;
  final String requirement;
  final String expiration;
  final String type;
  final String source;
  final double minOrderAmount;
  final double discountValue;

  VoucherItem({
    required this.title,
    required this.description,
    required this.requirement,
    required this.expiration,
    required this.type,
    required this.source,
    required this.minOrderAmount,
    required this.discountValue,
  });
}


final List<VoucherItem> allVouchers = [
  VoucherItem(
    title: "Giảm 20k đơn từ 50k",
    description: "Ưu đãi có hạn",
    requirement: "Đơn tối thiểu 50.000đ",
    expiration: "HSD: 31/12/2025",
    type: "Giảm giá món",
    source: "Bitoo Chọn Lọc",
    minOrderAmount: 50000.0,
    discountValue: 20000.0,
  ),
  VoucherItem(
    title: "Freeship 15k",
    description: "Tiết kiệm phí vận chuyển",
    requirement: "Đơn từ 40.000đ",
    expiration: "HSD: 30/11/2025",
    type: "Phí vận chuyển",
    source: "Đối Tác",
    minOrderAmount: 40000.0,
    discountValue: 15000.0,
  ),
];