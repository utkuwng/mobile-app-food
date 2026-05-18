import 'package:flutter/material.dart';

class Review {
  final String user;
  final String reviewText;
  final int stars;
  final int likes;
  final String timeAgo;
  final String avatarUrl;
  final DateTime datePosted;

  Review({
    required this.user,
    required this.reviewText,
    required this.stars,
    required this.likes,
    required this.timeAgo,
    required this.avatarUrl,
    required this.datePosted,
  });
}

enum ReviewSortOption { likes, newest }

final List<Review> mockReviews = [
  Review(user: 'Nguyễn Thị Hương', reviewText: 'Món ăn tuyệt vời. Thực đơn phong phú và chất lượng cao. Chắc chắn là trải nghiệm ẩm thực đẳng cấp 🤩', stars: 5, likes: 938, timeAgo: '6 ngày trước', avatarUrl: 'assets/images/avatar1.jpg', datePosted: DateTime.now().subtract(const Duration(days: 6))),
  Review(user: 'Trần Văn Tùng', reviewText: 'Đây là nhà hàng yêu thích tuyệt đối của tôi. Đồ ăn luôn tuyệt vời và dù gọi món gì tôi cũng hài lòng! 💯💯', stars: 4, likes: 863, timeAgo: '2 tuần trước', avatarUrl: 'assets/images/avatar2.jpg', datePosted: DateTime.now().subtract(const Duration(days: 14))),
  Review(user: 'Lê Thị Mai', reviewText: 'Các món ăn ngon, trình bày đẹp mắt. Tôi sẽ giới thiệu cho mọi người! Muốn gọi món ở đây lần nữa và lần nữa 👍', stars: 5, likes: 629, timeAgo: '2 tuần trước', avatarUrl: 'assets/images/avatar3.jpg', datePosted: DateTime.now().subtract(const Duration(days: 15))),
  Review(user: 'Phạm Minh Đức', reviewText: 'Chất lượng không còn ổn định như trước. Vẫn ổn, nhưng không xứng đáng 5 sao nữa.', stars: 3, likes: 450, timeAgo: '3 tuần trước', avatarUrl: 'assets/images/avatar4.jpg', datePosted: DateTime.now().subtract(const Duration(days: 21))),
  Review(user: 'Hoàng Văn Vinh', reviewText: 'Dịch vụ xuất sắc. Đồ ăn đóng gói cẩn thận và giao hàng nhanh chóng.', stars: 5, likes: 102, timeAgo: '4 tuần trước', avatarUrl: 'assets/images/avatar5.jpg', datePosted: DateTime.now().subtract(const Duration(days: 28))),
  Review(user: 'Võ Thanh Tú', reviewText: 'Thời gian chờ khá lâu. Đồ ăn tạm ổn, không có gì đặc biệt.', stars: 2, likes: 50, timeAgo: '1 tháng trước', avatarUrl: 'assets/images/avatar6.jpg', datePosted: DateTime.now().subtract(const Duration(days: 30))),
  Review(user: 'Đặng Ngọc Anh', reviewText: 'Địa điểm tuyệt vời cho bữa trưa nhanh! Rất khuyến khích món súp.', stars: 4, likes: 300, timeAgo: '1 ngày trước', avatarUrl: 'assets/images/avatar7.jpg', datePosted: DateTime.now().subtract(const Duration(days: 1))),
  Review(user: 'Bùi Lan Chi', reviewText: 'Tôi chỉ ăn các lựa chọn thuần chay. Chúng tạm chấp nhận được.', stars: 4, likes: 120, timeAgo: '2 tháng trước', avatarUrl: 'assets/images/avatar8.jpg', datePosted: DateTime.now().subtract(const Duration(days: 60))),
];


class ReviewsScreen extends StatefulWidget {
  final double rating;
  final int reviewCount;

  const ReviewsScreen({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {

  int _selectedStarFilter = 0;

  ReviewSortOption _currentSortOption = ReviewSortOption.likes;

  final Map<int, double> _starDistribution = {
    5: 0.45,
    4: 0.30,
    3: 0.15,
    2: 0.05,
    1: 0.05,
  };

  List<Review> get _filteredReviews {

    List<Review> filtered = mockReviews;
    if (_selectedStarFilter != 0) {
      filtered = mockReviews.where((review) => review.stars == _selectedStarFilter).toList();
    }


    if (_currentSortOption == ReviewSortOption.likes) {
      filtered.sort((a, b) => b.likes.compareTo(a.likes));
    } else if (_currentSortOption == ReviewSortOption.newest) {
      filtered.sort((a, b) => b.datePosted.compareTo(a.datePosted));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final String displayReviewCount = widget.reviewCount.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá & Nhận xét'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildRatingSummary(displayReviewCount),

              const Divider(height: 30),


              _buildFilterChips(context),

              const Divider(height: 30),


              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredReviews.length,
                itemBuilder: (context, index) {
                  final review = _filteredReviews[index];
                  return Column(
                    children: [
                      _buildReviewItem(review),
                      if (index < _filteredReviews.length - 1)
                        const Divider(height: 1, thickness: 0.5),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary(String displayReviewCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < widget.rating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 5),
            Text(
              '($displayReviewCount đánh giá)',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(width: 30),

        Expanded(
          child: Column(
            children: List.generate(5, (index) {
              final star = 5 - index;
              final percent = _starDistribution[star]!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text('$star'),
                    const SizedBox(width: 5),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.pinkAccent,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }


  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [

          _buildActionChip(
            label: 'Sắp xếp theo',
            icon: Icons.sort,
            isSelected: _currentSortOption != ReviewSortOption.likes,
            onTap: () => _showSortOptions(context),
          ),
          const SizedBox(width: 8),


          _buildStarFilterChip(0),


          _buildStarFilterChip(5),
          _buildStarFilterChip(4),
          _buildStarFilterChip(3),
          _buildStarFilterChip(2),
          _buildStarFilterChip(1),
        ],
      ),
    );
  }


  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Sắp xếp theo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                _buildSortOptionTile(setModalState, 'Mới nhất', ReviewSortOption.newest),
                _buildSortOptionTile(setModalState, 'Lượt thích', ReviewSortOption.likes),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildSortOptionTile(StateSetter setModalState, String title, ReviewSortOption option) {
    bool isSelected = _currentSortOption == option;
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.pinkAccent) : null,
      onTap: () {
        setModalState(() {
          setState(() {
            _currentSortOption = option;
          });
        });
        Navigator.pop(context);
      },
    );
  }


  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const Color selectedColor = Colors.pinkAccent;
    final Color textColor = isSelected ? Colors.white : selectedColor;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, color: textColor, size: 18),
        label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        onPressed: onTap,
        backgroundColor: isSelected ? selectedColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? selectedColor : Colors.grey.shade300),
        ),
      ),
    );
  }


  Widget _buildStarFilterChip(int starCount) {
    bool isSelected = _selectedStarFilter == starCount;
    String label = starCount == 0 ? 'Tất cả' : '$starCount';

    return _buildActionChip(
      label: label,
      icon: starCount == 0 ? Icons.all_inclusive : Icons.star,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          _selectedStarFilter = starCount;
        });
      },
    );
  }


  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueGrey.shade100,
                child: Text(review.user[0], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700)),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.user, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.stars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),

          Text(review.reviewText, style: TextStyle(color: Colors.grey[800])),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.favorite, color: Colors.pink.shade300, size: 16),
              const SizedBox(width: 5),
              Text(review.likes.toString(), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(width: 15),
              Text(review.timeAgo, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}