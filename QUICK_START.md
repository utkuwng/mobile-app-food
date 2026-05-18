# 🚀 Quick Start - UEH Food Delivery

## Cách Chạy Nhanh (Cho Windows)

### Lần Đầu Setup
1. **Double-click**: `setup.bat`
   - Kiểm tra Flutter SDK
   - Kiểm tra thiết bị Android
   - Cài đặt dependencies

### Chạy App
2. **Double-click**: `run_app.bat`
   - App sẽ tự động chạy trên thiết bị Android

### Build APK
3. **Double-click**: `build_apk.bat`
   - Tạo file APK để cài đặt trên điện thoại
   - File APK: `build\app\outputs\flutter-apk\app-release.apk`

### Gặp Lỗi?
4. **Double-click**: `clean_project.bat`
   - Xóa cache và cài đặt lại
   - Sau đó chạy lại `run_app.bat`

---

## Cách Chạy Bằng Android Studio

### Bước 1: Mở Project
- Mở Android Studio
- File → Open → Chọn thư mục `App_Ueh-main`

### Bước 2: Cài Đặt Dependencies
Terminal trong Android Studio:
```bash
flutter pub get
```

### Bước 3: Chọn Thiết Bị
- Click dropdown thiết bị ở thanh toolbar
- Chọn Android Emulator hoặc điện thoại đã kết nối

### Bước 4: Chạy App
- Click nút **Run** (▶️) 
- Hoặc nhấn `Shift + F10`

---

## Cách Chạy Bằng Terminal/CMD

### Windows PowerShell hoặc CMD:
```bash
cd d:\App_Vy\App_UEH\App_Ueh-main
flutter pub get
flutter run
```

---

## 📱 Cài APK Lên Điện Thoại

1. Build APK:
   ```bash
   flutter build apk --release
   ```

2. File APK tại: `build\app\outputs\flutter-apk\app-release.apk`

3. Copy file APK vào điện thoại và cài đặt

---

## ⚡ Lệnh Nhanh

| Lệnh | Mô Tả |
|------|-------|
| `flutter run` | Chạy app |
| `flutter build apk` | Build APK |
| `flutter clean` | Xóa cache |
| `flutter doctor` | Kiểm tra cấu hình |
| `flutter devices` | Xem thiết bị |

---

## 🔧 Xử Lý Lỗi

### "No devices found"
- Bật USB Debugging trên điện thoại
- Hoặc khởi động Android Emulator

### "Gradle build failed"
```bash
flutter clean
flutter pub get
```

### "Flutter command locked"
- Khởi động lại terminal
- Hoặc khởi động lại máy

---

📖 **Xem chi tiết**: `HUONG_DAN_CHAY_APP.md`
