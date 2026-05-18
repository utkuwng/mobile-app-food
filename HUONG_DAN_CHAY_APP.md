# Hướng Dẫn Chạy App UEH Food Delivery

## Yêu Cầu Hệ Thống

- Flutter SDK (>= 3.5.0)
- Android Studio
- Android SDK
- Thiết bị Android hoặc Emulator

## Các Bước Chạy App

### 1. Cài Đặt Dependencies

Mở Terminal trong Android Studio và chạy lệnh:

```bash
cd C:\Users\ADMIN\Documents\App_Vy\App_Vy\App_Vy\App_UEH\App_Ueh-main
flutter pub get
```

### 2. Kiểm Tra Thiết Bị

Kiểm tra thiết bị Android đã kết nối:

```bash
flutter devices
```

### 3. Chạy App (Debug Mode)

**Cách 1: Sử dụng lệnh**
```bash
flutter run
```

**Cách 2: Trong Android Studio**
- Mở file `lib/main.dart`
- Click nút "Run" (▶️) hoặc nhấn `Shift + F10`
- Chọn thiết bị Android

### 4. Build App (Release Mode)

Build file APK:
```bash
flutter build apk --release
```

Build file APK chia theo ABI (file nhỏ hơn):
```bash
flutter build apk --split-per-abi
```

File APK sẽ được lưu tại:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Các Lệnh Hữu Ích

### Clean Project
Xóa cache và build cũ:
```bash
flutter clean
flutter pub get
```

### Kiểm Tra Lỗi
```bash
flutter doctor
```

### Hot Reload
Khi app đang chạy, nhấn `r` trong terminal để hot reload

### Hot Restart
Khi app đang chạy, nhấn `R` trong terminal để hot restart

### Xem Log
```bash
flutter logs
```

### Chạy trên thiết bị cụ thể
```bash
flutter run -d <device_id>
```

## Cấu Trúc Dự Án

```
lib/
├── main.dart              # Entry point
├── entry_point.dart       # Bottom navigation
├── constants.dart         # Constants và validators
├── services/
│   └── user_service.dart  # Quản lý dữ liệu user
└── screens/
    ├── onboarding/        # Màn hình giới thiệu
    ├── auth/              # Đăng nhập
    ├── signUp/            # Đăng ký
    ├── home/              # Trang chủ
    ├── profile/           # Hồ sơ
    └── editProfile/       # Chỉnh sửa hồ sơ
```

## Tính Năng Chính

✅ Đăng ký tài khoản (lưu dữ liệu bền vững)
✅ Đăng nhập
✅ Xem và chỉnh sửa thông tin cá nhân
✅ Tìm kiếm nhà hàng
✅ Đặt món ăn
✅ Xem đơn hàng

## Lưu Ý

- Dữ liệu được lưu bằng SharedPreferences
- Khi thoát app và vào lại, dữ liệu vẫn được giữ nguyên
- Đảm bảo đã cài đặt Flutter SDK và Android Studio đúng cách

## Xử Lý Lỗi Thường Gặp

### Lỗi: "Unable to locate Android SDK"
```bash
flutter config --android-sdk <path-to-android-sdk>
```

### Lỗi: Gradle Build Failed
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Lỗi: "Waiting for another flutter command to release the startup lock"
```bash
# Xóa file lock
# Windows:
del %USERPROFILE%\AppData\Local\Temp\flutter_tools_lock_*

# Hoặc khởi động lại máy
```

## Hỗ Trợ

Nếu gặp vấn đề, vui lòng:
1. Chạy `flutter doctor` để kiểm tra cấu hình
2. Xem log chi tiết với `flutter run -v`
3. Clean project và thử lại

---

**Phát triển bởi**: UEH Food Delivery Team
**Phiên bản**: 1.0.0+1
