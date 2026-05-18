import '../models/food_item.dart';

Map<String, List<FoodItem>> generateAllCategoryItems() {
  return {
    "Cơm": _generateItems("Cơm", [
      "Cơm Tấm Sườn Bì Chả", "Cơm Gà Xối Mỡ", "Cơm Niêu Sài Gòn", "Cơm Chiên Dương Châu", "Cơm Gà Hải Nam",
      "Cơm Bò Lúc Lắc", "Cơm Đùi Gà Mắm", "Cơm Xá Xíu", "Cơm Cá Kho Tộ", "Cơm Sườn Non Kho Tiêu",
      "Cơm Chiên Hải Sản", "Cơm Vịt Quay", "Cơm Trứng Cuộn", "Cơm Lam Gà Nướng", "Cơm Cháy Kho Quẹt",
      "Cơm Gà Rô Ti", "Cơm Sườn Nướng Mật Ong", "Cơm Cá Basa Kho Tộ", "Cơm Bò Kho", "Cơm Gà Teriyaki",
      "Cơm Chiên Cá Mặn", "Cơm Gà Nướng Muối Ớt", "Cơm Bò Xào Hành Tây", "Cơm Thịt Kho Trứng", "Cơm Gà Cà Ri",
      "Cơm Cá Chiên Nước Mắm", "Cơm Sườn Ram", "Cơm Bò Xào Rau Cải", "Cơm Gà Sốt Tiêu Đen", "Cơm Chiên Thập Cẩm",
      "Cơm Gà Luộc", "Cơm Cá Hồi Áp Chảo", "Cơm Bò Nướng Sa Tế", "Cơm Gà Sốt Nấm", "Cơm Chả Cá", "Cơm Gà Nướng Mật Ong", "Cơm Bò Xào Sa Tế", "Cơm Cá Thu Kho Cà", "Cơm Sườn Cốt Lết", "Cơm Gà Sốt Phô Mai",
      "Cơm Bò Xào Nấm", "Cơm Cá Lóc Kho Tộ", "Cơm Gà Chiên Giòn", "Cơm Sườn Nướng Ngũ Vị", "Cơm Gà Áp Chảo",
      "Cơm Cá Trứng Chiên", "Cơm Bò Xào Bông Cải", "Cơm Gà Kho Gừng", "Cơm Cá Diêu Hồng Chiên", "Cơm Thịt Heo Quay"
    ], "com"),

    "Bún/Phở": _generateItems("Bún/Phở", [
      "Phở Bò Tái Nạm", "Phở Gà Xé", "Bún Bò Huế", "Bún Chả Hà Nội", "Bún Đậu Mắm Tôm",
      "Bún Mắm Miền Tây", "Bún Riêu Cua", "Phở Bò Sốt Vang", "Bún Thịt Nướng", "Bún Cá Long Xuyên",
      "Bún Quậy Phú Quốc", "Phở Cuốn Hà Nội", "Bún Mọc", "Bún Thang", "Bún Xào Nghệ",
      "Phở Bò Viên", "Phở Bò Tái Chín", "Bún Cá Rô Đồng", "Bún Cá Nha Trang", "Bún Sứa",
      "Bún Bò Giò Heo", "Bún Riêu Ốc", "Bún Riêu Tóp Mỡ", "Bún Chả Cá", "Bún Cá Ngừ",
      "Phở Gà Trộn", "Phở Trộn Hà Nội", "Bún Miến Ngan", "Miến Lươn", "Miến Gà",
      "Bún Lươn Nghệ An", "Bún Ốc", "Bún Riêu Bề Bề", "Bún Cá Basa", "Bún Măng Vịt",
      "Bún Giò Heo", "Bún Thang Lươn", "Phở Áp Chảo", "Phở Bò Kho", "Phở Gà Ta",
      "Bún Cá Chấm", "Bún Bò Nam Bộ", "Bún Mắm Nêm", "Bún Riêu Chả Cá", "Bún Cá Hồi",
      "Phở Bò Tái Gân", "Bún Hải Sản", "Bún Riêu Cua Đồng", "Bún Chả Quạt"
    ], "bun"),


    "Bánh mì": _generateItems("Bánh mì", [
      "Bánh Mì Thịt Nguội", "Bánh Mì Heo Quay", "Bánh Mì Gà Xé", "Bánh Mì Ốp La", "Bánh Mì Chả Cá",
      "Bánh Mì Que Pháp", "Bánh Mì Thổ Nhĩ Kỳ", "Bánh Mì Bì", "Bánh Mì Xíu Mại", "Bánh Mì Bò Kho",
      "Bánh Mì Chảo", "Bánh Mì Nướng Muối Ớt", "Bánh Mì Nem Nướng", "Bánh Mì Pate", "Bánh Mì Thịt Nướng",
      "Bánh Mì Gà Nướng", "Bánh Mì Cá Ngừ", "Bánh Mì Gà Xốt Cay", "Bánh Mì Thập Cẩm", "Bánh Mì Phô Mai",
      "Bánh Mì Chà Bông", "Bánh Mì Heo Quay Da Giòn", "Bánh Mì Trứng Muối", "Bánh Mì Xúc Xích",
      "Bánh Mì Bò Nướng", "Bánh Mì Gà Chiên", "Bánh Mì Cá Chiên", "Bánh Mì Thịt Kho",
      "Bánh Mì Bò Sốt Tiêu", "Bánh Mì Gà Rô Ti", "Bánh Mì Pate Trứng", "Bánh Mì Chả Lụa",
      "Bánh Mì Bò Lá Lốt", "Bánh Mì Cá Mòi", "Bánh Mì Gà Xé Trộn",
      "Bánh Mì Heo Nướng", "Bánh Mì Trứng Ốp La Xúc Xích", "Bánh Mì Chả Cá Nha Trang",
      "Bánh Mì Phô Mai Tan Chảy", "Bánh Mì Bơ Tỏi",
      "Bánh Mì Thịt Xiên", "Bánh Mì Gà Teriyaki", "Bánh Mì Bò Xào", "Bánh Mì Cá Hồi",
      "Bánh Mì Gà Cay Hàn Quốc", "Bánh Mì Pate Chả", "Bánh Mì Thịt Quay", "Bánh Mì Bò Băm"
    ], "banhmi"),


    "Trà sữa": _generateItems("Trà sữa", [
      "Trà Sữa Trân Châu Đen", "Trà Sữa Khoai Môn", "Trà Sữa Matcha", "Sữa Tươi Trân Châu Đường Đen",
      "Trà Sữa Thái Xanh", "Trà Sữa Kem Cheese", "Trà Sữa Pudding", "Trà Sữa Sương Sáo",
      "Trà Sữa Socola", "Trà Sữa Dâu", "Trà Sữa Caramel", "Trà Sữa Oolong",
      "Trà Sữa Trân Châu Trắng", "Trà Sữa Hồng Trà", "Trà Sữa Lài",
      "Trà Sữa Chuối", "Trà Sữa Việt Quất", "Trà Sữa Bạc Hà",
      "Trà Sữa Oreo", "Trà Sữa Bánh Flan", "Trà Sữa Dừa",
      "Trà Sữa Đào", "Trà Sữa Vải", "Trà Sữa Nhãn",
      "Trà Sữa Trân Châu Hoàng Kim", "Trà Sữa Phô Mai Tươi",
      "Trà Sữa Sầu Riêng", "Trà Sữa Bơ",
      "Trà Sữa Gạo Rang", "Trà Sữa Trứng Nướng",
      "Sữa Tươi Matcha", "Sữa Tươi Socola",
      "Trà Sữa Táo Xanh", "Trà Sữa Kiwi",
      "Trà Sữa Nho", "Trà Sữa Cam",
      "Trà Sữa Chanh Dây", "Trà Sữa Dưa Lưới",
      "Trà Sữa Khoai Lang Tím", "Trà Sữa Hạt Dẻ",
      "Trà Sữa Yến Mạch", "Trà Sữa Ít Đường",
      "Trà Sữa Không Đá", "Trà Sữa Full Topping",
      "Trà Sữa Trân Châu Phô Mai", "Trà Sữa Socola Bạc Hà"
    ], "trasua"),


    "Ăn vặt": _generateItems("Ăn vặt", [
      "Bánh Tráng Trộn", "Cá Viên Chiên", "Khoai Tây Chiên", "Phô Mai Que", "Bắp Xào Tôm Khô",
      "Bánh Tráng Cuốn", "Bánh Tráng Nướng", "Xoài Lắc", "CóC Lắc", "Trứng Cút Lộn Xào Me",
      "Nem Chua Rán", "Gà Viên Chiên", "Khoai Lang Lắc", "Đậu Hũ Chiên", "Bánh Bao Chiên",
      "Bánh Cá Takoyaki", "Hàu Nướng Phô Mai", "Xúc Xích Chiên", "Mì Trộn Trứng",
      "Bánh Gạo Cay", "Chả Cá Viên", "Chân Gà Sả Tắc", "Chân Gà Nướng",
      "Cút Lộn Rang Me", "Bánh Chuối Chiên",
      "Khoai Môn Chiên", "Bánh Khoai Chiên",
      "Bánh Tráng Me", "Trà Tắc", "Trà Đào",
      "Snack Rong Biển", "Bánh Gạo Lắc Phô Mai",
      "Bánh Xếp Chiên", "Há Cảo Chiên",
      "Gỏi Cuốn", "Nem Nướng Xiên",
      "Bánh Flan", "Rau Câu Dừa",
      "Xôi Chiên", "Bánh Cam",
      "Bánh Tiêu", "Bánh Chuối Nướng",
      "Sữa Chua Trân Châu", "Sữa Chua Dẻo",
      "Pudding Trứng", "Bánh Mochi",
      "Bánh Plan Phô Mai", "Trái Cây Dầm"
    ], "anvat"),

    "Gà rán": _generateItems("Gà rán", [
      "Gà Rán Truyền Thống", "Gà Rán Giòn Cay", "Gà Rán Phô Mai", "Gà Rán Mật Ong", "Gà Rán Sốt Cay Hàn Quốc",
      "Gà Rán Sốt BBQ", "Gà Rán Tỏi Ớt", "Gà Rán Sốt Teriyaki", "Gà Rán Sốt Tiêu Đen", "Gà Rán Sốt Cam",
      "Gà Rán Không Xương", "Gà Rán Nguyên Miếng", "Cánh Gà Rán", "Đùi Gà Rán", "Má Đùi Gà Rán",
      "Gà Rán Lắc Phô Mai", "Gà Rán Lắc Muối Ớt", "Gà Rán Lắc Rong Biển", "Gà Rán Lắc Bơ Tỏi", "Gà Rán Lắc Sa Tế",
      "Gà Popcorn", "Gà Viên Chiên", "Gà Rán Trứng Muối", "Gà Rán Sốt Me", "Gà Rán Sốt Thái",
      "Gà Rán Sốt Xí Muội", "Gà Rán Sốt Mè Rang", "Gà Rán Sốt Mù Tạt", "Gà Rán Phô Mai Cay",
      "Gà Rán Hàn Quốc Truyền Thống", "Gà Rán Giòn Không Cay", "Gà Rán Sốt Chanh Dây",
      "Gà Rán Sốt Kem", "Gà Rán Phủ Phô Mai Tuyết",
      "Gà Rán Xốt Truffle", "Gà Rán Xốt Tương Đen",
      "Gà Rán Bơ Cay", "Gà Rán Xốt Gochujang",
      "Gà Rán Sốt Tỏi Mật Ong", "Gà Rán Sốt Phô Mai Trắng",
      "Gà Rán Cay Cấp Độ 1", "Gà Rán Cay Cấp Độ 2", "Gà Rán Cay Cấp Độ 3",
      "Gà Rán Combo Gia Đình", "Gà Rán Combo Cá Nhân",
      "Gà Rán Ăn Kèm Khoai Tây", "Gà Rán Ăn Kèm Salad"
    ], "ga"),

    "Cà phê": _generateItems("Cà phê", [
      "Cà Phê Đen", "Cà Phê Sữa", "Cà Phê Đá", "Cà Phê Sữa Đá", "Bạc Xỉu",
      "Cà Phê Muối", "Cà Phê Trứng", "Cà Phê Dừa", "Cà Phê Kem", "Cà Phê Latte",
      "Cà Phê Cappuccino", "Cà Phê Espresso", "Cà Phê Americano",
      "Cà Phê Mocha", "Cà Phê Caramel", "Cà Phê Vanilla",
      "Cold Brew Truyền Thống", "Cold Brew Cam Sả", "Cold Brew Dừa",
      "Cà Phê Sữa Tươi", "Cà Phê Sữa Oat", "Cà Phê Sữa Hạnh Nhân",
      "Cà Phê Đen Không Đường", "Cà Phê Sữa Ít Đường",
      "Cà Phê Đá Xay", "Cà Phê Mocha Đá Xay", "Cà Phê Caramel Đá Xay",
      "Cà Phê Matcha Latte", "Cà Phê Socola Nóng",
      "Cà Phê Irish", "Cà Phê Ristretto",
      "Cà Phê Affogato", "Cà Phê Phin Giấy",
      "Cà Phê Phin Truyền Thống", "Cà Phê Rang Xay",
      "Cà Phê Arabica", "Cà Phê Robusta",
      "Cà Phê Pha Máy", "Cà Phê Pha Tay",
      "Cà Phê Sữa Đặc", "Cà Phê Muối Huế",
      "Cà Phê Trứng Hà Nội", "Cà Phê Dừa Bến Tre",
      "Cà Phê Sữa Nóng", "Cà Phê Đen Nóng",
      "Cà Phê Kem Muối", "Cà Phê Socola Bạc Hà"
    ], "cafe"),

    "Đồ chay": _generateItems("Đồ chay", [
      "Cơm Chay Thập Cẩm", "Cơm Chay Kho Nấm", "Cơm Chay Đậu Hũ Sốt Cà", "Cơm Chay Nấm Đông Cô", "Cơm Chay Rau Củ",
      "Bún Chay Huế", "Bún Riêu Chay", "Bún Măng Chay", "Bún Bò Huế Chay", "Bún Thịt Nướng Chay",
      "Phở Chay", "Phở Nấm Chay", "Miến Xào Chay", "Hủ Tiếu Chay", "Mì Xào Chay",
      "Cơm Chiên Chay", "Cơm Chiên Dương Châu Chay", "Cơm Chay Gừng Sả", "Cơm Chay Đậu Que",
      "Gỏi Cuốn Chay", "Gỏi Ngó Sen Chay", "Gỏi Đu Đủ Chay",
      "Chả Giò Chay", "Nem Chay", "Bánh Xèo Chay",
      "Đậu Hũ Chiên Sả Ớt", "Đậu Hũ Kho Nấm", "Đậu Hũ Non Sốt Nấm",
      "Canh Rong Biển Chay", "Canh Chua Chay",
      "Lẩu Nấm Chay", "Lẩu Thái Chay",
      "Bún Đậu Mắm Tôm Chay", "Bún Đậu Mắm Nêm Chay",
      "Cơm Tấm Chay", "Cơm Sườn Chay",
      "Mì Quảng Chay", "Bún Mọc Chay",
      "Bánh Mì Chay", "Bánh Bao Chay",
      "Cháo Nấm Chay", "Cháo Đậu Xanh Chay",
      "Cơm Cuộn Chay", "Cơm Trộn Chay",
      "Nấm Chiên Giòn", "Rau Củ Kho Tộ"
    ], "chay"),

    "Healthy": _generateItems("Healthy", [
      "Salad Ức Gà", "Salad Cá Ngừ", "Salad Trứng Luộc", "Salad Rau Trộn", "Salad Bơ Trứng",
      "Salad Cá Hồi", "Salad Táo Hạt Óc Chó", "Salad Quinoa", "Salad Khoai Lang",
      "Cơm Gạo Lứt Ức Gà", "Cơm Gạo Lứt Cá Hồi", "Cơm Gạo Lứt Trứng Luộc",
      "Cơm Gạo Lứt Bò Áp Chảo", "Cơm Gạo Lứt Gà Nướng",
      "Bún Gạo Lứt", "Miến Rong Biển",
      "Ức Gà Áp Chảo", "Ức Gà Luộc", "Ức Gà Nướng Mật Ong Ít Đường",
      "Cá Hồi Áp Chảo", "Cá Basa Hấp",
      "Trứng Luộc 2 Trái", "Trứng Cuộn Ít Dầu",
      "Canh Rong Biển Trứng", "Canh Rau Củ",
      "Soup Bí Đỏ", "Soup Rong Biển",
      "Yogurt Hy Lạp", "Yogurt Trái Cây",
      "Smoothie Chuối", "Smoothie Dâu", "Smoothie Xanh",
      "Nước Detox Chanh Sả", "Nước Detox Táo Quế",
      "Bánh Mì Nguyên Cám", "Sandwich Healthy",
      "Cháo Yến Mạch", "Yến Mạch Trái Cây",
      "Cơm Trộn Healthy", "Cơm Cuộn Rong Biển Ít Calo",
      "Đậu Hũ Non Hấp", "Đậu Hũ Áp Chảo Ít Dầu",
      "Rau Luộc Thập Cẩm", "Khoai Lang Luộc",
      "Hạt Mix Healthy", "Trái Cây Cắt Sẵn"
    ], "healthy"),

    "Pizza": _generateItems("Pizza", [
      "Pizza Hải Sản", "Pizza Hải Sản Pesto", "Pizza Hải Sản Cocktail",
      "Pizza Pepperoni", "Pizza Xúc Xích Đức",
      "Pizza Thịt Xông Khói", "Pizza Jambon",
      "Pizza Gà Nướng", "Pizza Gà BBQ", "Pizza Gà Teriyaki",
      "Pizza Bò", "Pizza Bò BBQ", "Pizza Bò Phô Mai",
      "Pizza Thập Cẩm", "Pizza Đặc Biệt",
      "Pizza Phô Mai", "Pizza 4 Loại Phô Mai",
      "Pizza Nấm", "Pizza Rau Củ",
      "Pizza Cá Ngừ", "Pizza Cá Hồi",
      "Pizza Tôm", "Pizza Mực",
      "Pizza Trứng Muối", "Pizza Phô Mai Trứng Muối",
      "Pizza Cay Hàn Quốc", "Pizza Cay Mexico",
      "Pizza Xốt Cà Chua", "Pizza Xốt Kem",
      "Pizza Viền Phô Mai", "Pizza Viền Phô Mai Xúc Xích",
      "Pizza Viền Phô Mai Gà", "Pizza Viền Phô Mai Hải Sản",
      "Pizza Mini", "Pizza Cỡ Lớn",
      "Pizza Chay", "Pizza Chay Nấm",
      "Pizza Hải Sản Cay", "Pizza BBQ Tổng Hợp",
      "Pizza Gà Nấm", "Pizza Bò Nấm",
      "Pizza Tôm Phô Mai", "Pizza Mực Phô Mai",
      "Pizza Xúc Xích Phô Mai", "Pizza Phô Mai Kéo Sợi",
      "Pizza Cá Ngừ Phô Mai", "Pizza Hải Sản Phô Mai",
      "Pizza Truyền Thống", "Pizza Đế Mỏng"
    ], "pizza"),

    "Món Hàn": _generateItems("Món Hàn", [
      "Cơm Trộn Bibimbap", "Cơm Trộn Cay", "Cơm Trộn Thịt Bò",
      "Gà Rán Hàn Quốc", "Gà Rán Cay Hàn Quốc", "Gà Rán Phô Mai Hàn Quốc",
      "Tokbokki", "Tokbokki Phô Mai", "Tokbokki Hải Sản",
      "Mì Cay Hàn Quốc", "Mì Cay Hải Sản", "Mì Cay Phô Mai",
      "Kimbap Truyền Thống", "Kimbap Cá Ngừ", "Kimbap Phô Mai",
      "Canh Kim Chi", "Canh Rong Biển",
      "Thịt Heo Nướng Hàn Quốc", "Ba Chỉ Nướng Hàn Quốc",
      "Bulgogi", "Bulgogi Bò",
      "Cơm Cuộn Rong Biển", "Cơm Nắm Hàn Quốc",
      "Miến Trộn Japchae", "Miến Xào Hàn Quốc",
      "Trứng Cuộn Hàn Quốc", "Trứng Hấp Hàn Quốc",
      "Bánh Xèo Hàn Quốc", "Bánh Cá Hàn Quốc",
      "Gà Hầm Sâm", "Canh Sườn Bò",
      "Canh Đậu Tương", "Canh Hải Sản Cay",
      "Cơm Chiên Kim Chi", "Mì Trộn Cay",
      "Tokbokki Trứng", "Tokbokki Xúc Xích",
      "Mandu Chiên", "Mandu Hấp",
      "Bánh Gạo Lắc Phô Mai",
      "Mì Đen Jajangmyeon",
      "Mì Trộn Cay Gochujang",
      "Cơm Trộn Hải Sản",
      "Cơm Gà Hàn Quốc",
      "Gà Cay Phô Mai Kéo Sợi",
      "Set Món Hàn Quốc"
    ], "han"),

    "Món Nhật": _generateItems("Món Nhật", [
      "Sushi Cá Hồi", "Sushi Cá Ngừ", "Sushi Tôm",
      "Sashimi Cá Hồi", "Sashimi Cá Ngừ",
      "Cơm Cuộn California", "Cơm Cuộn Cá Hồi",
      "Cơm Cuộn Trứng", "Cơm Cuộn Bơ",
      "Ramen Truyền Thống", "Ramen Tonkotsu", "Ramen Miso",
      "Udon Hải Sản", "Udon Bò", "Udon Gà",
      "Tempura Tôm", "Tempura Rau Củ",
      "Cơm Bò Gyudon", "Cơm Gà Teriyaki",
      "Cơm Cá Hồi Teriyaki",
      "Takoyaki", "Okonomiyaki",
      "Mì Soba Lạnh", "Mì Soba Nóng",
      "Trứng Cuộn Tamagoyaki",
      "Canh Miso", "Canh Rong Biển Nhật",
      "Cơm Nắm Onigiri", "Cơm Nắm Cá Ngừ",
      "Cơm Nắm Cá Hồi",
      "Gà Karaage",
      "Cơm Chiên Nhật Bản",
      "Bánh Mochi", "Bánh Mochi Kem",
      "Sushi Chay",
      "Cơm Lươn Unagi",
      "Mì Ramen Cay",
      "Cơm Trộn Nhật",
      "Cơm Thịt Heo Nhật",
      "Cơm Gà Nhật",
      "Hải Sản Nướng Nhật",
      "Bánh Cá Taiyaki",
      "Trà Sữa Matcha",
      "Kem Matcha",
      "Set Sushi Tổng Hợp",
      "Set Món Nhật",
      "Lẩu Nhật Sukiyaki",
      "Lẩu Nhật Shabu Shabu"
    ], "nhat"),

    "Lẩu/Nướng": _generateItems("Lẩu/Nướng", [
      "Lẩu Thái", "Lẩu Hải Sản", "Lẩu Bò", "Lẩu Gà Lá Giang", "Lẩu Gà Ớt Hiểm",
      "Lẩu Cá Kèo", "Lẩu Cá Diêu Hồng", "Lẩu Mắm", "Lẩu Nấm", "Lẩu Chay",
      "Lẩu Kim Chi", "Lẩu Tứ Xuyên",
      "Ba Chỉ Nướng", "Sườn Nướng", "Bò Nướng",
      "Gà Nướng Muối Ớt", "Gà Nướng Mật Ong",
      "Hải Sản Nướng", "Tôm Nướng", "Mực Nướng",
      "Hàu Nướng Phô Mai", "Hàu Nướng Mỡ Hành",
      "Bạch Tuộc Nướng", "Bạch Tuộc Nướng Sa Tế",
      "Thịt Heo Nướng", "Thịt Bò Nướng",
      "Combo Nướng 1 Người", "Combo Nướng 2 Người",
      "Combo Lẩu 1 Người", "Combo Lẩu 2 Người",
      "Lẩu Bò Nhúng Dấm", "Lẩu Riêu Cua",
      "Lẩu Ếch", "Lẩu Gà Tiềm Ớt Hiểm",
      "Lẩu Hải Sản Chua Cay",
      "Nướng BBQ Tổng Hợp",
      "Nướng Hàn Quốc",
      "Nướng Nhật Bản",
      "Nướng Muối Ớt",
      "Nướng Sa Tế",
      "Combo Lẩu Nướng",
      "Lẩu Thập Cẩm",
      "Lẩu Cá Tầm",
      "Lẩu Bò Mỹ",
      "Lẩu Hải Sản Đặc Biệt",
      "Nướng Hải Sản Phô Mai",
      "Nướng Gà Nguyên Con"
    ], "lau"),

    "Tráng miệng": _generateItems("Tráng miệng", [
      "Bánh Flan", "Bánh Flan Phô Mai", "Rau Câu Dừa",
      "Chè Thái", "Chè Khúc Bạch", "Chè Đậu Đỏ",
      "Chè Ba Màu", "Chè Chuối", "Chè Bưởi",
      "Kem Vanilla", "Kem Socola", "Kem Matcha",
      "Kem Dừa", "Kem Sầu Riêng",
      "Bánh Mochi", "Bánh Mochi Kem",
      "Bánh Tiramisu", "Bánh Cheesecake",
      "Bánh Brownie", "Bánh Su Kem",
      "Trái Cây Dầm", "Trái Cây Tô",
      "Sữa Chua Trân Châu", "Sữa Chua Dẻo",
      "Sữa Chua Hy Lạp",
      "Pudding Trứng", "Pudding Socola",
      "Bánh Chuối", "Bánh Chuối Nướng",
      "Bánh Da Lợn", "Bánh Bò",
      "Xôi Xoài", "Xôi Dừa",
      "Bánh Cam", "Bánh Tiêu",
      "Bánh Plan Caramel",
      "Kem Trái Cây", "Kem Que",
      "Thạch Trái Cây",
      "Thạch Phô Mai",
      "Bánh Tart Trứng",
      "Bánh Cupcake",
      "Bánh Donut",
      "Bánh Waffle",
      "Bánh Pancake",
      "Kem Ý Gelato",
      "Tráng Miệng Tổng Hợp",
      "Set Tráng Miệng"
    ], "dessert"),


  };
}

double _calculateFlexiblePrice(String category, int index) {
  double base = 30000;
  if (category == "Bánh mì" || category == "Ăn vặt") base = 35000;
  else if (category == "Trà sữa" || category == "Cà phê") base = 45000;
  else if (category == "Cơm" || category == "Bún/Phở") base = 65000;
  else if (category == "Món Nhật") base = 150000;

  final List<double> variations = [0, 20000, 50000, 15000, 80000, 10000, 45000, 5000];
  return base + variations[index % variations.length];
}


List<FoodItem> _generateItems(String category, List<String> names, String prefix) {
  return List.generate(names.length, (index) {
    String uniqueId = "${prefix}_${index + 1}";
    double fixedPrice = _calculateFlexiblePrice(category, index);

    final List<double> ratings = [4.5, 4.8, 4.2, 5.0, 3.9, 4.6, 4.1, 4.9];
    double fixedRating = ratings[index % ratings.length];

    int fixedReviews = 50 + (index * 73) % 800;

    final List<double> distances = [1.2, 3.5, 0.5, 5.2, 2.1, 4.0];
    double fixedDistance = distances[index % distances.length];

    final List<String> times = ["15-20'", "25-35'", "10-20'", "40-50'"];
    String fixedTime = times[index % times.length];


    int? salePercent;
    if ((index * 7 + 3) % 10 < 3) {
      final sales = [10, 20, 30, 50];
      salePercent = sales[index % sales.length];
    }

    String mockRestaurant = "$category Quán ${index % 3 + 1}";

    return FoodItem(
      id: uniqueId,
      name: names[index],
      imageUrl: "assets/images/${prefix}_${index + 1}.jpg",
      description: "${fixedDistance}km • Giao hàng tiêu chuẩn",
      rating: fixedRating,
      reviewCount: fixedReviews,
      deliveryTime: fixedTime,
      price: fixedPrice,
      salePercentage: salePercent?.toDouble(),
      isFavorite: false,
      restaurantName: mockRestaurant,
    );
  });
}