# 📚 GIẢI THÍCH CODE CHO NGƯỜI MỚI BẮT ĐẦU

## 🎯 Mục Đích File Này
File này giải thích chi tiết cách hoạt động của các file code trong dự án, dành cho người mới học Flutter/Dart.

---

## 📂 CẤU TRÚC DỰ ÁN

```
lib/
├── main.dart                    # File chính - Điểm bắt đầu app
├── entry_point.dart             # Màn hình chính với bottom navigation
├── constants.dart               # Các hằng số (màu sắc, padding, validators)
├── services/
│   └── user_service.dart        # Quản lý dữ liệu người dùng (lưu/tải)
└── screens/
    ├── onboarding/              # Màn hình giới thiệu
    ├── auth/                    # Màn hình đăng nhập
    ├── signUp/                  # Màn hình đăng ký
    ├── profile/                 # Màn hình hồ sơ
    └── editProfile/             # Màn hình chỉnh sửa hồ sơ
```

---

## 🔑 CÁC KHÁI NIỆM QUAN TRỌNG

### 1. Widget là gì?
- **Widget** = Thành phần giao diện trong Flutter
- Mọi thứ bạn nhìn thấy đều là Widget: Button, Text, Image, Screen...
- Có 2 loại chính:
  - **StatelessWidget**: Không thay đổi (ví dụ: Text cố định)
  - **StatefulWidget**: Có thể thay đổi (ví dụ: Form có thể nhập liệu)

### 2. State là gì?
- **State** = Trạng thái/Dữ liệu của Widget
- Khi State thay đổi → Widget tự động vẽ lại (rebuild)
- Ví dụ: `_obscureText = true` → hiển thị mật khẩu dạng ****

### 3. Controller là gì?
- **TextEditingController** = Bộ điều khiển cho ô nhập liệu (TextField)
- Dùng để:
  - Lấy giá trị người dùng nhập: `controller.text`
  - Đặt giá trị mặc định: `controller.text = "Nguyễn Văn A"`
  - Xóa giá trị: `controller.clear()`

### 4. Async/Await là gì?
- **async** = Hàm bất đồng bộ (không chờ đợi)
- **await** = Đợi kết quả trước khi chạy tiếp
- Ví dụ:
```dart
// ❌ KHÔNG DÙNG AWAIT - Lỗi vì chưa có dữ liệu
final data = _userService.getUserData();  
print(data);  // In ra: Instance of 'Future<Map>'

// ✅ DÙNG AWAIT - Đợi lấy dữ liệu xong mới in
final data = await _userService.getUserData();
print(data);  // In ra: {fullName: 'Nguyễn Văn A', email: '...'}
```

### 5. setState() là gì?
- **setState()** = Thông báo cho Flutter biết State đã thay đổi
- Flutter sẽ gọi lại `build()` để vẽ lại giao diện
- Ví dụ:
```dart
// Thay đổi biến PHẢI đặt trong setState()
setState(() {
  _isLoading = false;  // Tắt loading
  _userName = "Nguyễn Văn A";  // Cập nhật tên
});
// → Flutter sẽ vẽ lại màn hình với dữ liệu mới
```

---

## 📖 GIẢI THÍCH TỪNG FILE QUAN TRỌNG

### 📄 1. `lib/main.dart`
**Vai trò**: File đầu tiên chạy khi mở app

**Luồng hoạt động**:
```
1. main() được gọi
2. runApp(MyApp()) → Khởi động app
3. MyApp → Cấu hình theme (màu sắc, style)
4. home: OnboardingScreen() → Hiển thị màn hình đầu tiên
```

**Code quan trọng**:
```dart
void main() {
  runApp(const MyApp());  // Khởi động app
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(...),  // Cấu hình giao diện
      home: OnboardingScreen(),  // Màn hình đầu tiên
    );
  }
}
```

---

### 📄 2. `lib/services/user_service.dart`
**Vai trò**: Quản lý dữ liệu người dùng (lưu vào thiết bị)

**Công nghệ**: SharedPreferences (lưu dữ liệu dạng key-value)

**Các hàm quan trọng**:

#### a. `saveUserData()` - Lưu thông tin khi đăng ký
```dart
final success = await _userService.saveUserData(
  fullName: "Nguyễn Văn A",
  email: "a@ueh.edu.vn",
);
// → Lưu vào storage: user_full_name = "Nguyễn Văn A"
// → Lưu vào storage: user_email = "a@ueh.edu.vn"
```

#### b. `getUserData()` - Lấy thông tin đã lưu
```dart
final userData = await _userService.getUserData();
// → Trả về: {'fullName': 'Nguyễn Văn A', 'email': 'a@ueh.edu.vn', ...}
```

#### c. `updateUserData()` - Cập nhật thông tin
```dart
await _userService.updateUserData(
  fullName: "Trần Thị B",  // Chỉ đổi tên, email giữ nguyên
);
```

**Singleton Pattern**:
- Chỉ có 1 instance duy nhất trong toàn bộ app
- Gọi `UserService()` nhiều lần → Vẫn là cùng 1 object
- Lợi ích: Tiết kiệm bộ nhớ, dữ liệu nhất quán

---

### 📄 3. `lib/entry_point.dart`
**Vai trò**: Màn hình chính với 4 tab ở dưới

**Hoạt động**:
```
Người dùng nhấn tab "Tìm kiếm" (index = 1)
  ↓
onTap(1) được gọi
  ↓
setState(() { _selectedIndex = 1; })
  ↓
Flutter vẽ lại: body = _screens[1] = SearchScreen()
  ↓
Màn hình Tìm kiếm được hiển thị
```

**Code quan trọng**:
```dart
// Danh sách 4 màn hình
final _screens = [
  HomeScreen(),         // Tab 0
  SearchScreen(),       // Tab 1
  OrderDetailsScreen(), // Tab 2
  ProfileScreen(),      // Tab 3
];

// Hiển thị màn hình theo tab đang chọn
body: _screens[_selectedIndex],

// Khi nhấn tab → Đổi _selectedIndex → Vẽ lại màn hình
onTap: (value) {
  setState(() {
    _selectedIndex = value;
  });
},
```

---

### 📄 4. `lib/screens/signUp/components/sign_up_form.dart`
**Vai trò**: Form đăng ký tài khoản

**Luồng hoạt động**:
```
1. Người dùng nhập: Họ tên, Email, Mật khẩu
2. Nhấn nút "Đăng ký"
3. validate() → Kiểm tra dữ liệu hợp lệ
4. Nếu OK → saveUserData() → Lưu vào storage
5. Hiển thị thông báo "Đăng ký thành công"
6. Chuyển sang màn hình tiếp theo
```

**Validate là gì?**
```dart
// Kiểm tra không được để trống
validator: requiredValidator.call,

// Kiểm tra định dạng email
validator: emailValidator.call,

// Kiểm tra tùy chỉnh: Mật khẩu khớp
validator: (value) {
  if (value != _passwordController.text) {
    return 'Mật khẩu không khớp';  // Hiển thị lỗi
  }
  return null;  // OK, không có lỗi
},
```

**Ẩn/Hiện mật khẩu**:
```dart
bool _obscureText = true;  // true = ẩn, false = hiện

TextFormField(
  obscureText: _obscureText,  // Áp dụng trạng thái
  ...
)

// Icon mắt để toggle
GestureDetector(
  onTap: () {
    setState(() {
      _obscureText = !_obscureText;  // Đảo ngược
    });
  },
  child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
)
```

---

### 📄 5. `lib/screens/editProfile/edit_profile_screen.dart`
**Vai trò**: Màn hình chỉnh sửa thông tin cá nhân

**Luồng hoạt động**:
```
1. initState() → Gọi _loadUserData()
2. _loadUserData() → Lấy dữ liệu từ UserService
3. setState() → Điền dữ liệu vào các ô nhập liệu
4. Người dùng chỉnh sửa
5. Nhấn "Lưu" → _saveUserData()
6. updateUserData() → Lưu vào storage
7. Navigator.pop() → Quay lại màn hình Profile
8. Profile reload dữ liệu mới
```

**Lifecycle của StatefulWidget**:
```
initState()        → Chạy 1 lần khi tạo widget
  ↓
build()           → Vẽ giao diện
  ↓
setState()        → Gọi khi có thay đổi → Gọi lại build()
  ↓
dispose()         → Chạy khi widget bị hủy (giải phóng bộ nhớ)
```

---

## 🛠️ CÁC PATTERN & BEST PRACTICES

### 1. Singleton Pattern (UserService)
```dart
// ❌ KHÔNG DÙNG SINGLETON
final service1 = UserService();  // Object 1
final service2 = UserService();  // Object 2 (lãng phí bộ nhớ)

// ✅ DÙNG SINGLETON
final service1 = UserService();  // Object 1
final service2 = UserService();  // Vẫn là Object 1 (tiết kiệm)
```

### 2. Dispose Controllers
```dart
// ❌ QUÊN DISPOSE → Rò rỉ bộ nhớ
class _MyState extends State<MyWidget> {
  final controller = TextEditingController();
  // Không có dispose() → controller không bao giờ bị hủy
}

// ✅ LUÔN DISPOSE
@override
void dispose() {
  controller.dispose();  // Giải phóng bộ nhớ
  super.dispose();
}
```

### 3. Check mounted trước khi dùng context
```dart
// ❌ KHÔNG CHECK → Có thể crash nếu widget đã bị hủy
Navigator.pop(context);

// ✅ CHECK mounted
if (mounted) {
  Navigator.pop(context);
}
```

### 4. Trim() input
```dart
// ❌ KHÔNG TRIM → Lưu cả khoảng trắng
saveUserData(fullName: "  Nguyễn Văn A  ");
// → Lưu: "  Nguyễn Văn A  " (có khoảng trắng thừa)

// ✅ DÙNG TRIM
saveUserData(fullName: "  Nguyễn Văn A  ".trim());
// → Lưu: "Nguyễn Văn A" (sạch sẽ)
```

---

## 🔍 CÁCH DEBUG & KIỂM TRA

### 1. Print để kiểm tra giá trị
```dart
final userData = await _userService.getUserData();
print('Dữ liệu user: $userData');  // In ra console
```

### 2. Kiểm tra null
```dart
final name = userData['fullName'];
if (name == null) {
  print('Tên chưa được lưu');
} else {
  print('Tên: $name');
}

// Hoặc dùng toán tử ??
final displayName = userData['fullName'] ?? 'Người dùng';
```

### 3. Try-catch để bắt lỗi
```dart
try {
  await _userService.saveUserData(...);
  print('Lưu thành công');
} catch (e) {
  print('Lỗi: $e');
}
```

---

## 📝 TÓM TẮT FLOW CHÍNH

### Flow Đăng Ký:
```
1. User nhập thông tin → SignUpForm
2. Nhấn "Đăng ký" → validate()
3. Nếu OK → UserService.saveUserData()
4. Lưu vào SharedPreferences
5. Hiển thị SnackBar "Thành công"
6. Navigator → Màn hình tiếp theo
```

### Flow Chỉnh Sửa Profile:
```
1. Mở EditProfileScreen
2. initState() → _loadUserData()
3. UserService.getUserData() → Lấy dữ liệu
4. setState() → Điền vào form
5. User chỉnh sửa
6. Nhấn "Lưu" → validate()
7. UserService.updateUserData()
8. Navigator.pop(true) → Quay lại
9. ProfileScreen nhận true → reload
10. Hiển thị dữ liệu mới
```

### Flow Hiển thị Profile:
```
1. ProfileScreen được mở
2. initState() → _loadUserData()
3. UserService.getUserData()
4. setState() → Cập nhật _userName, _userEmail
5. build() được gọi → Hiển thị lên UI
```

---

## 💡 MẸO HỌC TẬP

1. **Đọc code từ trên xuống**: main.dart → entry_point.dart → các màn hình
2. **Theo dõi luồng dữ liệu**: User input → Controller → Service → Storage
3. **Chú ý lifecycle**: initState → build → setState → dispose
4. **Thực hành với print()**: In ra giá trị để hiểu code chạy như thế nào
5. **Đọc comment trong code**: Mỗi dòng quan trọng đều có giải thích

---

## 🎓 TÀI LIỆU THAM KHẢO

- **Flutter Docs**: https://docs.flutter.dev/
- **Dart Docs**: https://dart.dev/guides
- **SharedPreferences**: https://pub.dev/packages/shared_preferences
- **Flutter Widget Catalog**: https://docs.flutter.dev/ui/widgets

---

**Chúc bạn học tập tốt! 🚀**
