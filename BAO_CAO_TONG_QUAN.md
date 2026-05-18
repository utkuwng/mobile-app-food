# Báo cáo Tổng quan (Phiên bản đơn giản)

Tài liệu này giới thiệu ngắn gọn về ứng dụng theo cách dễ hiểu, dành cho người không chuyên CNTT. Mục tiêu: giúp bạn biết ứng dụng làm gì, cách chạy nhanh, và những phần quan trọng cần quan tâm.

---

## 1) Ứng dụng này là gì?
- Ứng dụng đặt món ăn trên điện thoại (Android), giao diện hiện đại, dễ dùng.
- Người dùng có thể duyệt món, tìm kiếm, xem chi tiết, thêm vào đơn và quản lý hồ sơ.

## 2) Ai nên đọc tài liệu này?
- Quản lý, giảng viên, sinh viên hoặc thành viên dự án không chuyên kỹ thuật muốn hiểu bức tranh tổng quan để vận hành/giới thiệu ứng dụng.

## 3) Tính năng chính (tóm tắt)
- Màn hình chào và giới thiệu.
- Đăng ký/đăng nhập, quên mật khẩu cơ bản.
- Trang chủ, tìm kiếm, danh mục nổi bật.
- Xem chi tiết món, thêm vào đơn hàng, xem đơn hàng.
- Hồ sơ cá nhân và chỉnh sửa thông tin.

## 4) Cách chạy nhanh (5 bước)
1. Cài Flutter và Android Studio.
2. Mở thư mục dự án trên máy.
3. Chạy: `flutter pub get` để tải thư viện.
4. Kết nối điện thoại thật hoặc mở Android emulator.
5. Chạy: `flutter run` để mở ứng dụng.

Nếu gặp lỗi, hãy mở thư mục `android/` bằng Android Studio để đồng bộ rồi chạy lại.

## 5) Cấu trúc dự án (nhớ những mục này là đủ)
- `lib/`: Mã nguồn chính của ứng dụng (màn hình, thành phần giao diện, dịch vụ).
- `assets/`: Hình ảnh, biểu tượng, phông chữ dùng trong app.
- `pubspec.yaml`: Khai báo thư viện và tài nguyên.
- `android/`: Cấu hình để build/chạy trên Android.

Bạn có thể hiểu đơn giản: phần “nhìn thấy” trong ứng dụng nằm chủ yếu ở `lib/`.

## 6) Dữ liệu được lưu như thế nào?
- Một số thông tin cơ bản (ví dụ trạng thái đăng nhập) được lưu cục bộ trên thiết bị để tiện cho lần sử dụng sau.
- Bạn có thể xóa dữ liệu này bằng cách đăng xuất, gỡ ứng dụng, hoặc xóa dữ liệu ứng dụng.

## 7) Khi cần chỉnh sửa nội dung đơn giản
- Thay chữ/hiển thị: xem các tệp trong `lib/screens/`.
- Đổi màu/chữ: xem `lib/theme.dart`.
- Thêm hình/icon: thêm vào `assets/` rồi cập nhật `pubspec.yaml`.

Không cần kiến thức sâu để thực hiện các thay đổi cơ bản nêu trên.

## 8) Hỗ trợ và xử lý sự cố
- Kiểm tra đã cài đúng Flutter/Android Studio và kết nối thiết bị.
- Đảm bảo đã chạy `flutter pub get` trước khi `flutter run`.
- Nếu lỗi build, mở `android/` trong Android Studio để đồng bộ, sau đó chạy lại.
- Nếu vẫn lỗi, chụp màn hình thông báo và liên hệ nhóm phát triển.

---

Phiên bản: rút gọn cho người không chuyên  
Cập nhật: 10/2025
