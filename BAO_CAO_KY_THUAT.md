# Báo cáo Kỹ thuật (Phiên bản đơn giản)

Tài liệu này giải thích hệ thống theo cách dễ hiểu cho người không chuyên CNTT. Nội dung chỉ giữ các ý chính cần biết để sử dụng và quản lý ứng dụng.

---

## 1) Ứng dụng này là gì?
- Ứng dụng đặt món ăn trên điện thoại (Android), viết bằng Flutter.
- Người dùng có thể xem món, xem chi tiết, thêm vào đơn, đặt hàng, cập nhật hồ sơ.

## 2) Ai sẽ dùng tài liệu này?
- Người quản lý dự án, thành viên không chuyên kỹ thuật, và những ai cần nắm bức tranh toàn cảnh để vận hành/giới thiệu ứng dụng.

## 3) Cách cài và chạy (tóm tắt)
1. Cài Flutter và Android Studio (để có trình giả lập hoặc kết nối điện thoại thật).
2. Mở thư mục dự án.
3. Chạy lệnh: `flutter pub get` để tải thư viện.
4. Kết nối thiết bị hoặc mở trình giả lập Android.
5. Chạy: `flutter run` để mở ứng dụng.

Nếu gặp lỗi, mở thư mục `android/` bằng Android Studio để đồng bộ rồi chạy lại.

## 4) Tính năng chính
- Màn hình chào và giới thiệu.
- Đăng nhập/đăng ký (email/số điện thoại) và quên mật khẩu.
- Trang chủ, tìm kiếm, danh mục nổi bật.
- Xem chi tiết món, thêm vào đơn, xem đơn hàng.
- Hồ sơ cá nhân và chỉnh sửa thông tin.
- Bộ lọc món/nhà hàng cơ bản.

## 5) Ứng dụng lưu gì trên máy?
- Một số thông tin người dùng (ví dụ: đã đăng nhập hay chưa) được lưu cục bộ trên thiết bị để lần sau mở app nhanh hơn.
- Dữ liệu này chỉ dùng trong ứng dụng và có thể xóa khi gỡ app hoặc xóa dữ liệu ứng dụng.

## 6) Cấu trúc thư mục (hiểu nhanh)
- `lib/`: mã nguồn chính của ứng dụng (màn hình, thành phần giao diện, dịch vụ).
- `assets/`: hình ảnh, biểu tượng, phông chữ.
- `pubspec.yaml`: khai báo thư viện và tài nguyên.
- `android/`: phần cấu hình để chạy trên Android.

Bạn chỉ cần nhớ: hầu hết những gì “nhìn thấy” trong app nằm trong thư mục `lib/`.

## 7) Vận hành cơ bản
- Khi mở app, ứng dụng kiểm tra trạng thái đăng nhập rồi đưa bạn vào các màn hình phù hợp.
- Các màn hình được tổ chức rõ ràng (trang chủ, tìm kiếm, chi tiết món, giỏ/đơn, hồ sơ…).
- Ảnh và biểu tượng lấy từ thư mục `assets/`.

## 8) Khi cần chỉnh sửa đơn giản
- Thay nội dung hiển thị: chỉnh trong các tệp ở `lib/screens/`.
- Đổi màu/chữ: xem `lib/theme.dart`.
- Thêm hình/icon mới: thêm file vào `assets/` và cập nhật `pubspec.yaml`.

Không cần hiểu sâu kỹ thuật để đổi các nội dung cơ bản nêu trên.

## 9) Bảo mật và quyền riêng tư (mức cơ bản)
- Ứng dụng không yêu cầu quyền đặc biệt ngoài những gì cần để hoạt động bình thường.
- Thông tin người dùng cơ bản được lưu trên thiết bị để tiện sử dụng; có thể xóa khi cần.

## 10) Hỗ trợ
- Nếu gặp vấn đề khi cài/chạy, vui lòng:
  - Kiểm tra đã cài Flutter/Android Studio và đã kết nối thiết bị.
  - Kiểm tra lệnh `flutter pub get` có báo lỗi không.
  - Mở `android/` trong Android Studio để đồng bộ, rồi chạy lại.
- Nếu vẫn không được, liên hệ nhóm phát triển kèm ảnh chụp thông báo lỗi.

---

Phiên bản: rút gọn cho người dùng không chuyên  
Cập nhật: 10/2025
